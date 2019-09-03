#!/bin/bash
export JAVA_HOME="/opt/app/jdk"
export JRE_HOME="/opt/app/jdk/jre"
export JAVA_OPTS="$JAVA_OPTS -server -Xmx4096m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -Dsun.net.client.defaultReadTimeout=60000 -Dsun.net.client.defaultConnectTimeout=10000 -Dcom.sun.management.jmxremote"
export CATALINA_OPTS="-server -Xmx2g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m"
export CATALINA_OPTS="$CATALINA_OPTS -Xms4096m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx4096m"
export CATALINA_PID="$CATALINA_BASE/bin/catalina.pid"
export CATALINA_OUT="/opt/app/logs/tomcat/catalina.out"
