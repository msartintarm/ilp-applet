# Platform-independent, but uses Bash

THE_CLASS_PATH="\
./diet-example/slib/xmlrpc-common-3.1.3.jar;\
./diet-example/slib/xmlrpc-client-3.1.3.jar;\
./diet-example/slib/ws-commons-util-1.0.2.jar;"

JAVA_FILES="\
NeosClient/*.java \
org/neos/client/*.java "

THE_CLASSES=${THE_FILES%.$java}.$class

javac -classpath $THE_CLASS_PATH $THE_FILES &&
jar cvfm Neos.jar manifest.txt $THE_CLASSES &&
java -classpath $THE_CLASS_PATH Neos >& out.txt

MANIFEST_FILE='Manifest-Version: 1.0\nTrusted-Library: true\nMain-Class: NeosClient.Neos\nCreated-By: Michael Sartin-Tarm\nCodebase: "*"\nPermissions: all-permissions\nClass-Path: '$THE_JARS'\n'

MANIFEST_GENERAL='
Trusted-Library: true\nCodebase: "*"\nPermissions: all-permissions\n'

pushd eclipse >> /dev/null

# Create manifests
echo -e $MANIFEST_FILE >& manifest_eclipse.txt
echo -e $MANIFEST_GENERAL >& manifest_general.txt
# Add entries to manifest for other files
for JAR in $THE_JARS; do
    cp ${JAR/slib/slib-old} $JAR
    jar ufm $JAR manifest_general.txt
done

# Create Java classes
javac -classpath $JAVA_CLASS_PATH $JAVA_FILES
# Zip classes, manifest, and external jars into one file
jar cfm Neos.jar manifest_eclipse.txt $JAVA_CLASSES $OTHER_FILES

# Sign the JARs
pushd ..
for JAR in $THE_JARS Neos.jar; do
    echo $JAR
    jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed eclipse/$JAR jarkey
done
popd



popd >> /dev/null
