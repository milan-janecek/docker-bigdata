# specify version of java to use - check tags defined in anapsix/alpine-java repository
ARG JAVA_TAG=8_jdk

FROM anapsix/alpine-java:$JAVA_TAG

ARG HADOOP_MIRROR=http://mirror.dkm.cz/apache/hadoop/common
ARG HADOOP_VER=3.0.0
ARG HADOOP_CHECKSUM=2d974865fb2156f67d115ad6dccd5884e1755c6e

# download hadoop and place it to /usr/local/hadoop
RUN apk add --no-cache curl \
 && curl -o hadoop-$HADOOP_VER.tar.gz $HADOOP_MIRROR/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz \
 && echo "$HADOOP_CHECKSUM  hadoop-$HADOOP_VER.tar.gz" | sha1sum -c - \
 && tar -zxf hadoop-$HADOOP_VER.tar.gz \
 && mv hadoop-$HADOOP_VER /usr/local/hadoop \
 && rm -rf hadoop-$HADOOP_VER.tar.gz \
 && apk del curl
 
ENV HADOOP_HOME="/usr/local/hadoop" PATH="${PATH}:/usr/local/hadoop/bin"