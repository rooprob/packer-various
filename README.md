packer-various
==============

Google Compute Engine (really a Qemu) via Packer

 * Ubuntu 12.04.4 x86_64

QUICK HOWTO

 * Build QEMU x86_64
 * Post install Google Utils and Settings
 * Clean-up

Install into Google Cloud Storage
 * GNU Tar and upload to Google Cloud Storage (manually)
 * gcsutil cp

Install into Google Compute Engine
 * gceutil addimage
 * gceutil addinstance

Extra bonus: customisations per-instance with a cloud-init
 * startup script
 * gceutil --vars

Debug Note:
 This was derived from a vagrant build, so there's a vagrant user, however the
passwords is slightly less obvious. The cleanup scripts will neutralize this
for cutting a release to GCS. Just note this exists if you'd like to debug the
