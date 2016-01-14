#!/bin/sh

# Make sure only root can run this script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Get JDK 8u65 ARMHF v6/7
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-arm32-vfp-hflt.tar.gz -O jdk.tar.gz

# Get latest javafx ARMHF binaries
wget http://gluonhq.com/download/javafx-embedded-sdk -O armv6hf-sdk.zip

# Extract JDK to /opt/
tar -xzvf jdk.tar.gz -C /opt/
JAVA_HOME=/opt/jdk1.8.0_65

# Extract javafx binaries here
unzip armv6hf-sdk.zip

# Insert javafx binaries into JRE
rm -f $JAVA_HOME/jre/lib/ext/jfx*jar $JAVA_HOME/jre/lib/arm/libjavafx_font_t2k.so
cp -r armv6hf/rt/lib $JAVA_HOME/jre/

# Update alternatives
update-alternatives --install /usr/bin/java $JAVA_HOME/bin/java 3
update-alternatives --config java <<< '3'

# Cleanup
rm -rf jdk/
rm -rf armv6hf-sdk/
