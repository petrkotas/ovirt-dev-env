# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/7"

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.ssh.insert_key = false
  config.ssh.private_key_path = ["provisioning/artifacts/keys/.vagrant_access", "~/.vagrant.d/insecure_private_key"]
  config.vm.provision "file", source: "provisioning/artifacts/keys/.vagrant_access", destination: "~/.ssh/id_rsa"
  config.vm.provision "file", source: "provisioning/artifacts/keys/.vagrant_access.pub", destination: "~/.ssh/authorized_keys"
  config.vm.network :private_network, type: "dhcp"

  config.vm.synced_folder ".", "/vagrant", disabled: true


  config.vm.define :host do |host|
    
    host.vm.hostname = "host.vagrant.test"

    host.vm.provider :libvirt do |libvirt|
      libvirt.nested = true
      libvirt.cpu_mode = "host-model"
      libvirt.cpus = 1
      libvirt.memory = 8096 
    end

    host.vm.synced_folder "source/vdsm/contrib", "/home/vagrant/contrib", type: "rsync"
    host.vm.synced_folder "source", "/vagrant/", type: "nfs", nfs_version: 4, nfs_udp: false

    host.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/host.yml"
    end 
  end

  config.vm.define :engine, primary: true do |engine|
    
    engine.vm.network :forwarded_port, guest: 8080, host: 8080
    engine.vm.hostname = "engine.vagrant.test"

    engine.vm.provider :libvirt do |libvirt|
      libvirt.cpu_mode = "host-model"
      libvirt.memory = 4096
      libvirt.cpus = 1
      libvirt.random :model => "random"
    end

    engine.vm.synced_folder "rpm", "/home/vagrant/rpms", type: "rsync"
    engine.vm.synced_folder "source", "/vagrant/source/", type: "nfs", nfs_version: 4, nfs_udp: false

    engine.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/engine.yml"
    end
  end

end
