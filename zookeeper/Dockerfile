# specify version of java to use - check tags defined in anapsix/alpine-java repository
ARG JAVA_TAG=8

FROM anapsix/alpine-java:${JAVA_TAG}_jdk

# add zookeeper archive to the image
COPY zookeeper.tar.gz /

# install zookeeper to /usr/local/zookeeper and remove archive afterwards
RUN tar -zxf zookeeper.tar.gz -C /usr/local \
 && mv /usr/local/zookeeper-* /usr/local/zookeeper \
 && rm -rf zookeeper.tar.gz

ENV PATH="${PATH}:/usr/local/zookeeper/bin"