FROM anapsix/alpine-java:8u162b12_jdk

# version of hbase to use - archive must be already downloaded
ARG VER

# version of hadoop to use - archive must be already downloaded
ARG HADOOP_VER

# add hbase archive to the image
COPY ./software/hbase/hbase-$VER-bin.tar.gz /

# add hadoop archive to the image
COPY ./software/hadoop/hadoop-$HADOOP_VER.tar.gz /

# add helper script to replace hadoop jars
COPY ./provision/hbase-replace-hadoop-jars.sh /

RUN tar -zxf hadoop-$HADOOP_VER.tar.gz -C /usr/local \
 && mv /usr/local/hadoop-* /usr/local/hadoop \
 && rm -rf hadoop-$HADOOP_VER.tar.gz \
 && tar -zxf hbase-$VER-bin.tar.gz -C /usr/local \
 && mv /usr/local/hbase-* /usr/local/hbase \
 && rm -rf hbase-$VER-bin.tar.gz \
 && sh hbase-replace-hadoop-jars.sh /usr/local/hbase /usr/local/hadoop \
 && rm -rf hbase-replace-hadoop-jars.sh \
 && rm -rf /usr/local/hadoop
