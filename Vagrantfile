Vagrant.configure("2") do |config|
  
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "dockerhost" do |dockerhost|
    dockerhost.vm.hostname = "dockerhost"
    dockerhost.vm.box = "ubuntu/xenial64"
    dockerhost.vm.network :private_network, ip: '192.168.42.43'
    dockerhost.vm.synced_folder ".", "/vagrant"

    # 2 namenodes
    # 3 datanodes
    # 2 resourcemanagers
    # 3 nodemanagers (running on datanodes)
    # 3 zookeepers
    # 1 timelineserver
    # 1 mapredhistoryserver
    dockerhost.hostmanager.aliases = %w(nn1 nn2 dn1 dn2 dn3 rm1 rm2 zoo1 zoo2 zoo3 ts mapredh)
     
    dockerhost.vm.provider "virtualbox" do |vb|
      vb.memory = 20480
      vb.cpus = 10
    end
    
    dockerhost.vm.provision :shell, path: "provision/install-docker.sh"

    dockerhost.vm.provision "shell" do |s|
      s.path = "provision/install-java.sh"
      s.args = [ "8" ]                                  # version of openjdk 
    end	
    
    dockerhost.vm.provision "shell" do |s|
      s.path = "provision/install-hadoop.sh"
      s.args = [ 
        "http://mirror.dkm.cz/apache/hadoop/common",    # mirror
        "3.0.0",                                        # hadoop version
        "2d974865fb2156f67d115ad6dccd5884e1755c6e"      # file checksum
      ]
    end
    
    dockerhost.vm.provision "shell" do |s|
      s.path = "provision/install-zookeeper.sh"
      s.args = [
        "http://mirror.dkm.cz/apache/zookeeper",        # mirror
        "3.4.11",                                       # hadoop version
        "9268b4aed71dccad3d7da5bfa5573b66d2c9b565"      # file checksum
      ]
    end
    
    dockerhost.vm.provision :shell, path: "provision/build-images.sh"
    
    dockerhost.vm.provision :shell, path: "provision/post-install.sh"
  end
  
end
