#!/bin/bash -ex

set -o pipefail

VERSION=$1
BUILD_NUMBER=$2

NAME="Andras Slemmer"
EMAIL="0slemi0@gmail.com"

# Install dependencies
apt-get update
apt-get install -y build-essential scons dh-make bzr-builddeb wget

cd build/

# Get sources
wget -nc https://github.com/armon/statsite/archive/v$VERSION.tar.gz

# Prepare package
export LOGNAME=bugsbunny
bzr whoami "bugs@bunny.com"
echo s | bzr dh-make statsite $VERSION ./v$VERSION.tar.gz

# Adjust templates
cp ../docker/debian/* statsite/debian/
cp -r ../docker/deb_tree statsite/debian/

sed -i "s/SED_VERSION_STRING_HERE/$VERSION-$BUILD_NUMBER/" statsite/debian/changelog

cd statsite/

# Build .deb
debuild -us -uc -S
