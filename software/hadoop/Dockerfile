FROM anapsix/alpine-java:8u162b12_jdk

# version of hadoop to use - archive must be already downloaded
ARG VER

# add hadoop archive to the image
COPY hadoop-$VER.tar.gz /

# install hadoop to /usr/local/hadoop and remove archive afterwards
RUN tar -zxf hadoop-$VER.tar.gz -C /usr/local \
 && mv /usr/local/hadoop-* /usr/local/hadoop \
 && rm -rf hadoop-$VER.tar.gz
 
# configure mapping of root and vagrant to HDFS supergroup 
RUN addgroup supergroup \
 && adduser root supergroup \
 && adduser -D vagrant \
 && adduser vagrant supergroup
 
ENV HADOOP_HOME="/usr/local/hadoop" PATH="${PATH}:/usr/local/hadoop/bin"