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
case1 \
case2 \
case3 \
case4 "

pushd `dirname $0` >& /dev/null

if [ -e Neos.jar ]; then
    echo "Unsigned JARs already created." # Skip to the signature, which must have failed.
else

# Create manifests

# Add new permissions to manifest for other JARs

    date
    # Any command line args, we deploy
    if [ "$#" -eq 0 ] 
    then 
	echo 'For development. ' 
	echo 'Permissions: all-permissions
Codebase: file://O:/applet  https://mywebspace.wisc.edu neos-dev-1.neos-server.org
Trusted-Library: true' >& manifest_general.txt
	cp manifest_general.txt manifest_eclipse.txt

	echo 'Manifest-Version: 1.0
Main-Class: NeosClient.Neos
Created-By: Michael Sartin-Tarm
Class-Path: ' $JAVA_ARCHIVES >> manifest_eclipse.txt

    else
	echo 'For deployment.'
	echo 'Permissions: all-permissions
Codebase: neos-dev-1.neos-server.org
Trusted-Library: true' >& manifest_general.txt
	cp manifest_general.txt manifest_eclipse.txt

	echo 'Manifest-Version: 1.0
Main-Class: NeosClient.Neos
Created-By: Michael Sartin-Tarm
Class-Path: ' ${JAVA_ARCHIVES//".jar"/"-a.jar"} >> manifest_eclipse.txt

	../gen-html.sh
    fi

for JAR in $JAVA_ARCHIVES; do
    cp jars/$JAR $JAR
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
#    jarsigner -verify -keystore key/keystore -certs $JAR
    mv $JAR ../bin
done

echo "Done. Jars are in bin/ folder."

popd >& /dev/null
