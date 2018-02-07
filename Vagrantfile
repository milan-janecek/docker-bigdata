# configuration is done via environment variables with reasonable defaults
# change APACHE_MIRROR to a mirror close to you to shorten download times

def getConfig(name, default)
  return ENV[name].nil? ? default : ENV[name]
end

ORACLE_JDK_URL=getConfig('ORACLE_JDK_URL', 'http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz')

ORACLE_JDK_SHA256_CHECKSUM=getConfig('ORACLE_JDK_SHA256_CHECKSUM', '68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257')

APACHE_MIRROR = getConfig('APACHE_MIRROR', 'http://mirror.hosting90.cz/apache')

HADOOP_VER = getConfig('HADOOP_VER', '2.7.5')

HADOOP_SHA1_CHECKSUM = getConfig('HADOOP_SHA1_CHECKSUM', '0f90ef671530c2aa42cde6da111e8e47e9cd659e')

ZOOKEEPER_VER = getConfig('ZOOKEEPER_VER', '3.4.11')

ZOOKEEPER_SHA1_CHECKSUM = getConfig('ZOOKEEPER_SHA1_CHECKSUM', '9268b4aed71dccad3d7da5bfa5573b66d2c9b565')

HBASE_VER = getConfig('HBASE_VER', '1.2.6')

HBASE_SHA1_CHECKSUM = getConfig('HBASE_SHA1_CHECKSUM', '19fe7bc1443d54bbf1fa405dfde62e37b3ea6cf6')

SYNCED_FOLDER = getConfig('SYNCED_FOLDER', '/vagrant')
  
Vagrant.configure("2") do |config|
  
  config.hostmanager.enabled = true
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define 'dockerhost' do |dockerhost|
    dockerhost.vm.hostname = 'dockerhost'
    dockerhost.vm.box = 'ubuntu/xenial64'
    dockerhost.vm.network :private_network, ip: '192.168.42.43'
    dockerhost.vm.synced_folder '.', "#{SYNCED_FOLDER}"

    # 2 namenodes
    # 3 datanodes
    # 2 resourcemanagers
    # 3 nodemanagers (running on datanodes)
    # 3 zookeepers
    # 1 timelineserver
    # 1 mapredhistoryserver
    # 2 hmasters
    dockerhost.hostmanager.aliases = %w(
      nn1.cluster
      nn2.cluster
      dn1.cluster 
      dn2.cluster
      dn3.cluster
      rm1.cluster
      rm2.cluster
      zoo1.cluster
      zoo2.cluster
      zoo3.cluster
      ts.cluster
      mapredh.cluster
      hm1.cluster
      hm2.cluster
    )
     
    dockerhost.vm.provider 'virtualbox' do |vb|
      vb.memory = 20480
      vb.cpus = 10
    end

    dockerhost.vm.provision :shell, path: 'provision/install-docker.sh'

    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-java.sh'
      s.args = [
        "#{ORACLE_JDK_URL}",
        "#{ORACLE_JDK_SHA256_CHECKSUM}"
      ]
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end

    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-hadoop.sh'
      s.args = [
        "#{APACHE_MIRROR}/hadoop/common",
        "#{HADOOP_VER}",
        "#{HADOOP_SHA1_CHECKSUM}"
      ]
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end
  
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-zookeeper.sh'
      s.args = [
        "#{APACHE_MIRROR}/zookeeper",
        "#{ZOOKEEPER_VER}",
        "#{ZOOKEEPER_SHA1_CHECKSUM}"
      ]
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end 
    
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-hbase.sh'
      s.args = [
        "#{APACHE_MIRROR}/hbase",
        "#{HBASE_VER}",
        "#{HBASE_SHA1_CHECKSUM}",
        "#{HADOOP_VER}"
      ]
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end
   
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/build-images.sh'
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end
    
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/post-install.sh'
      s.env = { 'BASE_DIR' => "#{SYNCED_FOLDER}" }
    end
    
  end
  
end
