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
    dockerhost.hostmanager.aliases = %w(nn1 nn2 dn1 dn2 dn3 rm1 rm2 zoo1 zoo2 zoo3)
     
    dockerhost.vm.provider "virtualbox" do |vb|
      vb.memory = 20480
      vb.cpus = 10
    end
    
    dockerhost.vm.provision :shell, path: "provision.sh"
  end
  
end
