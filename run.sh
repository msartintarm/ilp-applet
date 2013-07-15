#!/bin/bash
# Platform-independent, but uses Bash
set -e

JAVA_ARCHIVES="\
commons-logging-1.1.jar \
xmlrpc-client-3.1.3.jar \
xmlrpc-common-3.1.3.jar \
plugin.jar \
ws-commons-util-1.0.2.jar "

JAVA_FILES="\
NeosClient/*.java \
org/neos/client/*.java "

OTHER_FILES="\
case2 \
case3 "

MANIFEST_GENERAL='
Trusted-Library: true\nCodebase: *\nPermissions: all-permissions\n'
MANIFEST_FILE='Manifest-Version: 1.0\nTrusted-Library: true\nMain-Class: NeosClient.Neos\nCreated-By: Michael Sartin-Tarm\nCodebase: *\nPermissions: all-permissions\nClass-Path: '${JAVA_ARCHIVES//"jar"/"jar.sig"}'\n'

cd src

# Create manifests
echo -e $MANIFEST_FILE >& manifest_eclipse.txt
echo -e $MANIFEST_GENERAL >& manifest_general.txt

# Create Java classes
javac -classpath ${JAVA_ARCHIVES//" "/";"} $JAVA_FILES
# Zip classes, manifest, and GAMS files into one JAR
jar cfm Neos.jar manifest_eclipse.txt ${JAVA_FILES//"java"/"class"} $OTHER_FILES

# Add entries to manifest for other JARs
for JAR in $JAVA_ARCHIVES; do
    MANIFESTED_JAR=${JAR/"jar"/"jar.sig"}
    cp $JAR $MANIFESTED_JAR
    jar ufm $MANIFESTED_JAR manifest_general.txt
done

# Sign the JARs
echo Signing JARs..
for JAR in Neos.jar ${JAVA_ARCHIVES//"jar"/"jar.sig"}; do
    jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed $JAR jarkey
    mv $JAR ../bin
done

cd ..

echo Done.
