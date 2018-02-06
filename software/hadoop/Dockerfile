FROM anapsix/alpine-java:8u162b12_jdk

# version of hadoop to use - archive must be already downloaded
ARG VER

ADD hadoop-$VER.tar.gz /usr/local

# configure mapping of root and vagrant to HDFS supergroup 
RUN addgroup supergroup \
 && adduser root supergroup \
 && adduser -D vagrant \
 && adduser vagrant supergroup
 
ENV HADOOP_HOME="/usr/local/hadoop-$VER" PATH="${PATH}:/usr/local/hadoop-$VER/bin"