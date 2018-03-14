FROM anapsix/alpine-java:8u162b12_jdk

# version of hadoop to use - archive must be already downloaded
ARG VER

# user in supergroup - usually pass result of whoami to this parameter
ARG SUPER_GROUP_USER

ADD hadoop-$VER.tar.gz /usr/local

# configure mapping of root and vagrant to HDFS supergroup 
RUN addgroup supergroup \
 && adduser root supergroup \
 && adduser -D vagrant \
 && adduser vagrant supergroup \
 && id -u $SUPER_GROUP_USER &>/dev/null \
 || (adduser -D $SUPER_GROUP_USER && adduser $SUPER_GROUP_USER supergroup)
 
ENV HADOOP_HOME="/usr/local/hadoop-$VER" PATH="${PATH}:/usr/local/hadoop-$VER/bin"