#!/bin/bash

# Make sure only root can run this script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Get JDK 8u65 ARMHF v6/7
echo 'Retrieving JDK 8u65 ARMHF v6/7...'
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-arm32-vfp-hflt.tar.gz -O jdk.tar.gz

echo 'Retrieving javafx ARMHF v6 binaries...'
# Get latest javafx ARMHF binaries
wget http://gluonhq.com/download/javafx-embedded-sdk -O armv6hf-sdk.zip

# Extract JDK to /opt/
echo 'Extracting JDK...'
tar -xzvf jdk.tar.gz -C /opt/
export JAVA_HOME='/opt/jdk1.8.0_65'
echo "Installed JDK to ${JAVA_HOME}"

# Extract javafx binaries here
echo 'Extracting javafx ARMHF v6 binaries...'
unzip armv6hf-sdk.zip

# Insert javafx binaries into JRE
echo 'Removing existing javafx detritis...'
rm -f $JAVA_HOME/jre/lib/ext/jfx*jar $JAVA_HOME/jre/lib/arm/libjavafx_font_t2k.so
echo 'Copying javafx binaries into JRE...'
cp -r armv6hf-sdk/rt/lib/ $JAVA_HOME/jre/

# Update alternatives
echo 'Updating alternatives...'
update-alternatives --install '/usr/bin/java' 'java' "${JAVA_HOME}/bin/java" 3
update-alternatives --config java <<< '1'

# Cleanup
echo 'Cleaning up...'
rm -rf jdk.tar.gz
rm -rf armv6hf-sdk/
rm -rf armv6hf-sdk.zip

echo 'Finished.'
