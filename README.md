packer-various
==============

Date: 2014-06-20
Author: Robert Fielding <fieldingrp@gmail.com>

What
----
Google Compute Engine compatible build of Ubuntu Server

 * Ubuntu 12.04.4 x86_64

How
---

 * Build QEMU x86_64 with virtio
 * Post install Google Utils and Settings
 * Clean-up and lockdown
 * Upload to Google Cloud Storage
 * Add to Google Compute Engine
 * Add instance as required (including specify boot options, such as role,
   environment etc)

Build
-----
Create Qemu VM on KVM capable system, such as Linux on Haswell CPU.

    $ cd google-compute-engine
    $ packer build qemu-ubuntu-12.04.4-server-amd64.json

This will create an output directory output-qemu containing disk.raw.

Note: If you use Macbook running OSX, you may need to modify the qemuargs
-machine option to remove "accel=kvm", see
qemu-ubuntu-12.04.4-server-amd64.json for more details,

      "qemuargs":[
         [
           "-machine",
           "type=pc-1.0"
         ],
        ...


Post build
----------
Create GCE compatible disk image with GNU Tar with sparse file support (note
BSD tar on OSX does not work)

    $ tar -C output-qemu  -Szcvf u12gce1-5.tar.gz disk.raw

Upload into Google Cloud Storage

    $ gsutil cp u12gce1-5.tar.gz gs://gce-images

Install into Google Compute Engine

    $ gcutil listimages
    $ gcutil addimage u12gce1-5 gs://gce-images/u12gce1-5.tar.gz

First boot and cloud init
-------------------------
There is a stub startup-scripts/puppet-client.sh designed to integrate into our
environment. Localize as required for your site and upload to GCS.

This script makes use of metadata "facts" passed in at boot time to customize
integration into our Puppet environment.

Example only,
    $ gcutil addinstance my-inst1 --machine_type=n1-standard-1 \
        --image=u12gce1-5 \
        --zone=us-central1-a \
        --wait_until_running \
        --auto_delete_boot_disk \
        --service_account_scopes=storage-rw,compute-rw \
        --metadata_from_file=startup-script:startup-scripts/puppet-client.sh \
        --metadata='ENVIRONMENT:develop' \
        --metadata='INSTALLATION:foo' \
        --metadata='LOCATION:gce' \
        --metadata='REGION:us-central-1' \
        --metadata='ROLE:generic'

Debugging
---------
Building a fresh install is a very iterative process. You'll build locally a
few times, tuning options. This will continue in GCE, where you'll need to use
the gcutil getserialportoutput.

The postbuild scripts set up the instance of Google's GCE. To debug, you can
tune the install for a local environment.

The packer installation requires a known username and password. Find it (and
localize it) in google-compute-engine/http/ubuntu-12.04.4-server-amd64-preseed.cfg).

This user is removed by the scripts/cleanup.sh. While developing an image,
comment out this part of the script.

The default SSH is configured to passwordless SSH in scripts/google-gce-setup.sh.
Modify this for locally accessing via Qemu command -redir line below.

Once up in GCE and you have a problem, included is an emergency SSH daemon
configured on port 2022 with password access. This will be shielded by default
security firewall on GCE. Remove from build process once everything is
confirmed for your gold master image.

Console output is redirected in scripts/google-gce-setup.sh, see
GRUB_CMDLINE_LINUX. When booting locally it will appear that the boot has hung
just after grub. You should still be able to VNC/SSH to the instance after a
few moments.

Using qmenu, like this to boot the instance:

    $ qemu-system-x86_64 -m 1024m -name server \
         -netdev user,id=user.0 \
         -device virtio-net,netdev=user.0 \
         -drive file=disk.raw,if=virtio \
         -vnc 0.0.0.0:44 \
         -machine type=pc-1.0,accel=kvm \
         -display none \
         -boot once=d -redir tcp:3224::22

Note the -machine setting if you do not have KVM acceleration support.

Note the -redir for port mapping SSH to localhost; you may like to adjust for
the emergency SSH on 2022.


