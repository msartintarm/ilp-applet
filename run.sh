#!/bin/bash
# Platform-independent, but uses Bash
set -e

JAVA_ARCHIVES="\
slib/commons-logging-1.1.jar \
slib/xmlrpc-client-3.1.3.jar \
slib/xmlrpc-common-3.1.3.jar \
slib/plugin.jar \
slib/ws-commons-util-1.0.2.jar "

JAVA_FILES="\
NeosClient/*.java \
org/neos/client/*.java "

OTHER_FILES="\
case3 "

# Substring replacement
JAVA_CLASSES=${JAVA_FILES//"java"/"class"}
JAVA_CLASS_PATH=${JAVA_ARCHIVES//" "/";"}

MANIFEST_FILE='Manifest-Version: 1.0\nTrusted-Library: true\nMain-Class: NeosClient.Neos\nCreated-By: Michael Sartin-Tarm\nCodebase: *\nPermissions: all-permissions\nClass-Path: '$JAVA_ARCHIVES'\n'

MANIFEST_GENERAL='
Trusted-Library: true\nCodebase: *\nPermissions: all-permissions\n'

pushd eclipse >> /dev/null

# Create manifests
echo -e $MANIFEST_FILE >& manifest_eclipse.txt
echo -e $MANIFEST_GENERAL >& manifest_general.txt
# Add entries to manifest for other files
for JAR in $JAVA_ARCHIVES; do
    cp ${JAR/slib/slib-old} $JAR
    jar ufm $JAR manifest_general.txt
done

# Create Java classes
javac -classpath $JAVA_CLASS_PATH $JAVA_FILES
# Zip classes, manifest, and GAMS files into one JAR
jar cfm Neos.jar manifest_eclipse.txt $JAVA_CLASSES $OTHER_FILES

# Sign the JARs
pushd .. >& /dev/null
for JAR in Neos.jar $JAVA_ARCHIVES; do
    echo Signing $JAR
    jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed eclipse/$JAR jarkey
done
popd >& /dev/null



popd >> /dev/null
