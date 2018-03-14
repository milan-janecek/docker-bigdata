doc# version of hadoop to use - image is based on specific version of hadoop
ARG HADOOP_VER

FROM hadoop:$HADOOP_VER

# version of spark to use - archive must be already downloaded
ARG VER

ADD spark-$VER-bin-without-hadoop.tgz /usr/local

RUN apk --no-cache add procps \
 && mv /usr/local/spark-$VER* /usr/local/spark-$VER \
 && mv /usr/local/spark-$VER/conf/spark-env.sh.template /usr/local/spark-$VER/conf/spark-env.sh \
 && mv /usr/local/spark-$VER/conf/spark-defaults.conf.template /usr/local/spark-$VER/conf/spark-defaults.conf \
 && echo export SPARK_DIST_CLASSPATH=$(hadoop classpath) >> /usr/local/spark-$VER/conf/spark-env.sh \
 && echo export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop >> /usr/local/spark-$VER/conf/spark-env.sh \
 && echo export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop >> /usr/local/spark-$VER/conf/spark-env.sh \
 && echo export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native >> /usr/local/spark-$VER/conf/spark-env.sh
 
ENV SPARK_HOME="/usr/local/spark-$VER" PATH="${PATH}:/usr/local/spark-$VER/bin:/usr/local/spark-$VER/sbin"