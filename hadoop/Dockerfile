ARG JAVA_TAG=8 

FROM anapsix/alpine-java:${JAVA_TAG}_jdk

# add hadoop archive to the image
COPY hadoop.tar.gz /

# install hadoop to /usr/local/hadoop and remove archive afterwards
RUN tar -zxf hadoop.tar.gz -C /usr/local \
 && mv /usr/local/hadoop-* /usr/local/hadoop \
 && rm -rf hadoop.tar.gz
 
# configure mapping of root and vagrant to HDFS supergroup 
RUN addgroup supergroup \
 && adduser root supergroup \
 && adduser -D vagrant \
 && adduser vagrant supergroup
 
ENV HADOOP_HOME="/usr/local/hadoop" PATH="${PATH}:/usr/local/hadoop/bin"