FROM anapsix/alpine-java:8u162b12_jdk

# version of zookeeper to use - archive must be already downloaded
ARG VER

# add zookeeper archive to the image
COPY zookeeper-$VER.tar.gz /

# install zookeeper to /usr/local/zookeeper and remove archive afterwards
RUN tar -zxf zookeeper-$VER.tar.gz -C /usr/local \
 && mv /usr/local/zookeeper-* /usr/local/zookeeper \
 && rm -rf zookeeper.tar.gz

ENV PATH="${PATH}:/usr/local/zookeeper/bin"