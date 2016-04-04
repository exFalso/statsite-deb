#!/bin/bash -ex

set -o pipefail

NAME="Andras Slemmer"
EMAIL="0slemi0@gmail.com"

# Install dependencies
apt-get update
apt-get install -y build-essential scons dh-make bzr-builddeb wget

cd build/

# Get sources
wget -nc https://github.com/armon/statsite/archive/v0.7.1.tar.gz

# Prepare package
export LOGNAME=bugsbunny
bzr whoami "bugs@bunny.com"
echo s | bzr dh-make statsite 0.7.1 ./v0.7.1.tar.gz

# Adjust templates
cp ../docker/debian/* statsite/debian/
cp -r ../docker/deb_tree statsite/debian/

cd statsite/

# Build .deb
debuild -us -uc -S
