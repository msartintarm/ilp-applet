# Platform-independent, but uses Bash

THE_CLASS_PATH="\
./diet-example/slib/xmlrpc-common-3.1.3.jar;\
./diet-example/slib/xmlrpc-client-3.1.3.jar;\
./diet-example/slib/ws-commons-util-1.0.2.jar;"

THE_FILES="\
XmlRpcException.java \
Neos.java"

THE_CLASSES=${THE_FILES%.$java}.$class

javac -classpath $THE_CLASS_PATH $THE_FILES &&
jar cvfm Neos.jar manifest.txt $THE_CLASSES &&
java -classpath $THE_CLASS_PATH Neos >& out.txt

