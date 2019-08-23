#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Please specify Savu version to install"
    exit -1
fi

VERSION=$1

ALL_VERSIONS_URL="https://raw.githubusercontent.com/DiamondLightSource/Savu/master/install/all_versions.txt"
SAVU_URL=$(curl --silent ${ALL_VERSIONS_URL} | awk '$1 == "'$VERSION'" { print $2 }')

if [[ "$SAVU_URL" == "" ]]; then
    echo "Savu version not found"
    exit -1
fi

curl \
  --location \
  --output /tmp/savu.tar.gz \
  "${SAVU_URL}"

tar \
  --extract \
  --gzip \
  --directory=/tmp \
  --file /tmp/savu.tar.gz

cd /tmp/savu_v${VERSION}
chmod +x savu_installer.sh
env PREFIX=/ ./savu_installer.sh --no_prompts | tee savu_install.log
