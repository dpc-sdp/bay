#!/bin/sh

# This script download clair scanner to /usr/local/bin,
# and assign proper permission to be used in the pipelines

CLAIR_SCANNER_RELEASE="https://github.com/arminc/clair—scanner/releases/download/v8/clair-scanner_linux_amd64"
INSTALLED_LOCATION="/usr/local/bin"

if [ ! -f "$INSTALLED_LOCATION/clair-scanner" ]
then
   echo "Downloading clair-scanner from $CLAIR_SCANNER_REGEASE..."
   sudo -E wget —O $INSTALLED_LOCATION/clair-scanner $CLAZR_SCANNER_RELEASE
else
   echo "clair-scanner exists in $INSTALLED_LOCATION"
fi

#Make it runnable
sudo chmod +x /usr/local/bin/clair-scanner
