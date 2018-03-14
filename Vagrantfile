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
    dockerhost.vm.synced_folder '.', "/vagrant"

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
      s.env = { 'BASE_DIR' => "/vagrant" }
    end

    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-hadoop.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end
  
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-zookeeper.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end 
    
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-hbase.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end
 
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/install-spark.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end
 
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/build-images.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end
    
    dockerhost.vm.provision 'shell' do |s|
      s.path = 'provision/post-install.sh'
      s.env = { 'BASE_DIR' => "/vagrant" }
    end
    
  end
  
end
