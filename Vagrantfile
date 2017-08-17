# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/7"

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.ssh.insert_key = false
  config.ssh.private_key_path = ["provisioning/artifacts/keys/.vagrant_access", "~/.vagrant.d/insecure_private_key"]

  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.define :build, autostart: false do |build|
    build.vm.box = BOX_IMAGE

    build.vm.network :private_network, type: "dhcp"
    build.vm.hostname = "build.vagrant.test"

    build.vm.provider :libvirt do |libvirt|
      libvirt.cpu_mode = "host-model"
      libvirt.memory = 2048
    end

    build.vm.synced_folder "source", "/vagrant/", type: "nfs", nfs_version: 4, nfs_udp: false

    build.vm.provision "file", source: "provisioning/artifacts/keys/.vagrant_access.pub", destination: "~/.ssh/authorized_keys"
    build.vm.provision :shell, :inline => "sudo yum install -y epel-release && sudo yum install -y ansible"
    build.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/build.yml"
    end

  end

  config.vm.define :host do |host|
    # build machine, builds the vdsm source, creates rpms and exposes repository
    host.vm.box = BOX_IMAGE
    
    host.vm.network :private_network, type: "dhcp"
    host.vm.hostname = "host.vagrant.test"

    host.vm.provider :libvirt do |libvirt|
      libvirt.cpu_mode = "host-model"
      libvirt.memory = 4096 
    end

    host.vm.synced_folder "source/vdsm/contrib", "/home/vagrant/contrib", type: "rsync"
    host.vm.synced_folder "source", "/vagrant/", type: "nfs", nfs_version: 4, nfs_udp: false

    host.vm.provision "file", source: "provisioning/artifacts/keys/.vagrant_access.pub", destination: "~/.ssh/authorized_keys"
    host.vm.provision :shell, :inline => "sudo yum install -y epel-release && sudo yum install -y ansible"
    host.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/host.yml"
    end 
  end

  config.vm.define :engine, primary: true do |engine|
    engine.vm.box = BOX_IMAGE 
    
    engine.vm.network :private_network, type: "dhcp"
    engine.vm.network :forwarded_port, guest: 8080, host: 8080
    engine.vm.hostname = "engine.vagrant.test"

    engine.vm.provider :libvirt do |libvirt|
      libvirt.cpu_mode = "host-model"
      libvirt.memory = 2048
      libvirt.cpus = 2
      libvirt.random :model => "random"
    end

    engine.vm.synced_folder "rpm", "/home/vagrant/rpms", type: "rsync"

    engine.vm.provision "file", source: "provisioning/artifacts/keys/.vagrant_access.pub", destination: "~/.ssh/authorized_keys"
    engine.vm.provision :shell, :inline => "sudo yum install -y epel-release && sudo yum install -y ansible"
    engine.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/engine.yml"
    end
  end

end
