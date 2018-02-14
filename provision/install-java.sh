if [ $# -ne 2vagran ]; then
  echo "ERROR: Exactly 2 arguments are needed: oracle_jdk_url, sha256_checksum."
  exit 1
fi

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}

oracle_jdk_url=$1
sha256_checksum=$2

echo "*** SCRIPT ARGUMENTS ***"
echo "oracle_jdk_url: $1"
echo "sha256_checksum: $2"

filename=$(basename $oracle_jdk_url)
ver=$(echo $filename | sed -r 's/(\w+)-([0-9a-ZA-Z]+)-(.+)/\1-\2/')

echo "*** INSTALLING JAVA $ver ***"

if [ ! -d /usr/local/$ver ]; then

  if [ ! -f $BASE_DIR/software/java/$filename ]; then
    echo "DOWNLOADING JAVA" 
    curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
      -o $BASE_DIR/software/java/$filename $oracle_jdk_url
  
    echo "VALIDATING CHECKSUM"
    echo "$sha256_checksum $BASE_DIR/software/java/$filename" | sha256sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/java/$filename
      echo "CHECKSUM VALIDATION FAILED - JAVA $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING JAVA ARCHIVE"
  sudo mkdir -p /usr/local/$ver
  sudo tar -zxf $BASE_DIR/software/java/$filename -C /usr/local/$ver
  sudo mv /usr/local/$ver/*/* /usr/local/$ver
  
  echo "JAVA $ver HAS BEEN SUCCESSFULLY INSTALLED"
else
  echo "JAVA $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE JAVA $ver ***"
echo "SETTING JAVA_HOME"
sudo sh -c \
  "echo export JAVA_HOME=/usr/local/$ver > /etc/profile.d/java-home.sh"
  
echo "ADDING JAVA BIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/'$ver'/bin > /etc/profile.d/java-bin.sh'