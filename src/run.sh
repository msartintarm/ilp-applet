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

if [ -e Neos.jar ]; then
    echo "JAR already created." # Skip to the signature, which must have failed.
else

# Create manifests

# Add new permissions to manifest for other JARs

    echo 'Trusted-Library: true
Codebase: *
Permissions: all-permissions' >& manifest_general.txt

    echo 'Manifest-Version: 1.0
Trusted-Library: true
Main-Class: NeosClient.Neos
Created-By: Michael Sartin-Tarm
Codebase: *
Permissions: all-permissions
Class-Path: ' >& manifest_eclipse.txt

    for JAR in $JAVA_ARCHIVES; do
	OLD_JAR="jars/$JAR"
	cp $OLD_JAR $JAR
	jar ufm $JAR manifest_general.txt
    done

# Create Java classes
    javac -classpath ${JAVA_ARCHIVES//" "/";"} $JAVA_FILES
# Zip classes, manifest, and GAMS files into one JAR
    jar cfm Neos.jar manifest_eclipse.txt ${JAVA_FILES//"java"/"class"} $OTHER_FILES

fi

# Sign the JARs
echo Signing JARs..
for JAR in Neos.jar $JAVA_ARCHIVES; do
    jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed $JAR jarkey
    mv $JAR ../bin
done

echo Done.
