FROM anapsix/alpine-java:8u162b12_jdk

# version of zookeeper to use - archive must be already downloaded
ARG VER

ADD zookeeper-$VER.tar.gz /usr/local

ENV PATH="${PATH}:/usr/local/zookeeper-$VER/bin"