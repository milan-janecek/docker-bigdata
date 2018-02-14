# helper methods to detect number of host cpus and vcpus for guest

def host_cpus
  case RbConfig::CONFIG['host_os']
  when /darwin/
    Integer(`sysctl -n hw.ncpu`)
  when /linux/
    Integer(`cat /proc/cpuinfo | grep processor | wc -l`)
  else
    Integer(`wmic cpu get NumberOfLogicalProcessors`.split("\n")[2].to_i)
  end
end

# defaults to half of what is on host - if host_cpus is unable to determine
# host cpus => then defaults to 4
def guest_cpus
  begin
    host_cpus / 2
  rescue
    4
  end
end

# helper methods to detect number of total memory of host and memory for guest

def host_memory
  case RbConfig::CONFIG['host_os']
  when /darwin/
    Integer(`sysctl -n hw.memsize`.to_i / 1024 / 1024)
  when /linux/
    Integer(`grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024)
  else
    Integer(`wmic ComputerSystem get TotalPhysicalMemory`.split("\n")[2].to_i / 1024 / 1024)
  end
end

# defaults to half of what is on host - if host_memory is unable to determine
# host memory => then defaults to 8 GB
def guest_memory
  begin
    host_memory / 2
  rescue
    8192
  end
end

# configuration is done via environment variables with reasonable defaults
# change APACHE_MIRROR to a mirror close to you to shorten download times

def get_config(name, default)
  return ENV[name].nil? ? default : ENV[name]
end

ORACLE_JDK_URL=get_config('ORACLE_JDK_URL', 'http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz')

ORACLE_JDK_SHA256_CHECKSUM=get_config('ORACLE_JDK_SHA256_CHECKSUM', '68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257')

APACHE_MIRROR = get_config('APACHE_MIRROR', 'http://mirror.hosting90.cz/apache')

HADOOP_VER = get_config('HADOOP_VER', '2.7.5')

HADOOP_SHA1_CHECKSUM = get_config('HADOOP_SHA1_CHECKSUM', '0f90ef671530c2aa42cde6da111e8e47e9cd659e')

ZOOKEEPER_VER = get_config('ZOOKEEPER_VER', '3.4.11')

ZOOKEEPER_SHA1_CHECKSUM = get_config('ZOOKEEPER_SHA1_CHECKSUM', '9268b4aed71dccad3d7da5bfa5573b66d2c9b565')

HBASE_VER = get_config('HBASE_VER', '1.2.6')

HBASE_SHA1_CHECKSUM = get_config('HBASE_SHA1_CHECKSUM', '19fe7bc1443d54bbf1fa405dfde62e37b3ea6cf6')

SPARK_VER = get_config('SPARK_VER', '2.2.1')

SPARK_SHA512_CHECKSUM = get_config('SPARK_SHA512_CHECKSUM', '25a0fa4af441ab6c39408d5e555c74e99d7b1b6eaea7ec61168d081812a6c71c760d8b0394a1fa1930fe80067033f5f682aa4dd4b6d1d8b55427b027857b2424')

SYNCED_FOLDER = get_config('SYNCED_FOLDER', '/vagrant')
  
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

    dockerhost.hostmanager.aliases = %w(
      namenode1.cluster
      namenode2.cluster
      datanode1.cluster 
      datanode2.cluster
      datanode3.cluster
      resourcemanager1.cluster
      resourcemanager2.cluster
      zookeeper1.cluster
      zookeeper2.cluster
      zookeeper3.cluster
      timelineserver.cluster
      mapredhistoryserver.cluster
      hmaster1.cluster
      hmaster2.cluster
      hregionserver1.cluster
      hregionserver2.cluster
      hregionserver3.cluster
      sparkhistoryserver.cluster
    )
     
    dockerhost.vm.provider 'virtualbox' do |vb|
      vb.memory = guest_memory
      vb.cpus = guest_cpus
    end

    dockerhost.vm.provision :shell, path: 'provision/install-docker-ubuntu.sh'

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
      s.path = 'provision/install-spark.sh'
      s.args = [
        "#{APACHE_MIRROR}/spark",
        "#{SPARK_VER}",
        "#{SPARK_SHA512_CHECKSUM}"
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
