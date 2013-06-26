# Platform-independent, but uses Bash

THE_CLASS_PATH="./diet-example/slib/xmlrpc-common-3.1.3.jar;./diet-example/slib/xmlrpc-client-3.1.3.jar;./diet-example/slib/ws-commons-util-1.0.2.jar;"

rm Neos.class
javac -classpath $THE_CLASS_PATH Neos.java

java -classpath $THE_CLASS_PATH Neos

