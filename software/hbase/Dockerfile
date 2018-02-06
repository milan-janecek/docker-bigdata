FROM anapsix/alpine-java:8u162b12_jdk

# version of hbase to use - archive must be already downloaded
ARG VER

# version of hadoop to use - hadoop jars must exist
ARG HADOOP_VER

ADD hbase-$VER-bin.tar.gz /usr/local

COPY replace-hadoop-jars.sh /

COPY ./hadoop-jars/$HADOOP_VER /tmp/hadoop-jars

# replace hadoop jars
RUN sh replace-hadoop-jars.sh \
  && rm -rf replace-hadoop-jars.sh \
  && rm -rf /tmp/hadoop-jars

ENV HBASE_HOME="/usr/local/hbase-$VER" PATH="${PATH}:/usr/local/hbase-$VER/bin"
