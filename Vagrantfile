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
	
    # 3 workers
	  # 2 name nodes
	  # 1 resource manager
	  # 1 web application proxy
	  # 1 mapreduce job history server
	  dockerhost.hostmanager.aliases = %w(w1 w2 w3 nn1 nn2 rm wap mrjhs)
	   
    dockerhost.vm.provider "virtualbox" do |vb|
	  vb.memory = 20480
	  vb.cpus = 10
    end
    
    dockerhost.vm.provision :shell, path: "provision.sh"
  end
  
end
