javac -classpath "./slib/xmlrpc-common-3.1.3.jar;./slib/xmlrpc-client-3.1.3.jar;" src/org/neos/examples/SimplePanel.java src/org/neos/examples/SimpleApplet.java
mv src/org/neos/examples/SimplePanel.class SimplePanel.class
mv src/org/neos/examples/SimpleApplet.class SimpleApplet.class

jar cvf SimplePanel.jar SimpleApplet.class SimplePanel.class
jarsigner -keystore key/keystore -storepass qawsed -keypass qawsed -signedjar SignedDiet.jar SimplePanel.jar jarkey
