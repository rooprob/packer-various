#!/bin/bash
set -x
version=1.1.2
release=1
arch=all
pkgpath=https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${version}

packages="python-gcimagebundle google-startup-scripts google-compute-daemon"
requirements="kpartx ethtool"

apt-get -y install $requirements

for pkg in $packages; do
    curl -L -o /usr/src/${pkg}_${version}-${release}_${arch}.deb $pkgpath/${pkg}_${version}-${release}_${arch}.deb || \
        {
            echo "error: downloading package $pkg for GoogleCloudPlatform from github" >&2
            exit 1
        }
done;

for pkg in $packages; do
    dpkg -i /usr/src/${pkg}_${version}-${release}_${arch}.deb || \
        {
            echo "error: dpkg install $pkg" >&2
            exit 1
        }
done;
