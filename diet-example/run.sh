# Platform-independent, but uses Bash
EXAMPLE=org/neos/examples
EXAMPLE_SRC=src/$EXAMPLE

javac -Xlint:unchecked -classpath "./slib/xmlrpc-common-3.1.3.jar;./slib/xmlrpc-client-3.1.3.jar;" $EXAMPLE_SRC/SimplePanel.java $EXAMPLE_SRC/SimpleApplet.java

jar cvf SimplePanel.jar $EXAMPLE_SRC resources
jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed -signedjar SignedPanel.jar SimplePanel.jar jarkey
