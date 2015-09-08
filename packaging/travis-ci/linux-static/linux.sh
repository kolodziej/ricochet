#!/bin/bash

# This file should be used only in Travis-CI environment

set -e

if [ ! -d .git ] || [ ! -f ricochet.pro ]; then
    echo "Must be run from source directory"
    exit 1
fi

VERSION=`git describe --tags HEAD`
TOR_BINARY=`which tor`

if [ -z "$TOR_BINARY" ] || [ ! -f "$TOR_BINARY" ]; then
    echo "Missing TOR_BINARY: $TOR_BINARY"
    exit 1
fi

DEPLOY_PATH=deploy/ricochet/
mkdir -p $DEPLOY_PATH
# Copy binaries to staging area
cp ricochet $DEPLOY_PATH
cp "$TOR_BINARY" $DEPLOY_PATH/
# Copy extra files
cp -R ./packaging/travis-ci/linux-static/content/* $DEPLOY_PATH

cd $DEPLOY_PATH
cd ..
tar cfj ricochet-${VERSION}-static.tar.bz2 ricochet
tar fjt *.bz2
