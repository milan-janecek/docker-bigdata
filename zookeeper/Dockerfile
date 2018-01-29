# specify version of java to use - check tags defined in anapsix/alpine-java repository
ARG JAVA_TAG=8_jdk

FROM anapsix/alpine-java:$JAVA_TAG

ARG ZOOK_MIRROR=http://mirror.dkm.cz/apache/zookeeper
ARG ZOOK_VER=3.4.11
ARG ZOOK_CHECKSUM=9268b4aed71dccad3d7da5bfa5573b66d2c9b565

# download zookeeper and place it to /usr/local/zookeeper
RUN apk add --no-cache curl \
 && curl -o zookeeper-$ZOOK_VER.tar.gz $ZOOK_MIRROR/zookeeper-$ZOOK_VER/zookeeper-$ZOOK_VER.tar.gz \
 && echo "$ZOOK_CHECKSUM  zookeeper-$ZOOK_VER.tar.gz" | sha1sum -c - \
 && tar -zxf zookeeper-$ZOOK_VER.tar.gz \
 && mv zookeeper-$ZOOK_VER /usr/local/zookeeper \
 && rm -rf zookeeper-$ZOOK_VER.tar.gz \
 && apk del curl
 
ENV PATH="${PATH}:/usr/local/zookeeper/bin"