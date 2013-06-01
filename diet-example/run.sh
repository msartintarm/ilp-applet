# Platform-independent, but uses Bash
EXAMPLE=org/neos/examples
EXAMPLE_SRC=src/$EXAMPLE
EXAMPLE_JAVA="$EXAMPLE_SRC/SimplePanel.java $EXAMPLE_SRC/SimpleApplet.java"
EXAMPLE_CLASS="$EXAMPLE_SRC/SimplePanel.class $EXAMPLE_SRC/SimpleApplet.class"

rm -f $EXAMPLE_SRC/*.class
javac -Xlint:unchecked -classpath "./slib/xmlrpc-common-3.1.3.jar;./slib/xmlrpc-client-3.1.3.jar;" $EXAMPLE_JAVA

jar cvf SimplePanel.jar $EXAMPLE_JAVA $EXAMPLE_CLASS resources
jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed -signedjar SignedPanel.jar SimplePanel.jar jarkey
