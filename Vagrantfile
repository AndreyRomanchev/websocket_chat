# -*- mode: ruby -*-
# vi: set ft=ruby :

net_ip = '192.168.50'
master_ip = "#{net_ip}.10"
minion_ip = "#{net_ip}.11"
os = 'ubuntu/xenial64'


Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # A VM w/ Docker that works on old Macs that don't support Docker natively
  if ENV.include? 'USE_DEV_VM'
    config.vm.define :dev do |vm_config|
      vmname = "dev"

      vm_config.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 1
          vb.name = vmname
      end

      vm_config.vm.box = os
      vm_config.vm.hostname = vmname

      vm_config.vm.provision :shell, inline: <<-SHELL
      curl -fsSL get.docker.com | sh -
      SHELL
    end
  end

  # Prepare Salt keys
  ['master', 'minion'].each do |name|
    prefix = "salt/keys/#{name}"
    pem = "#{prefix}.pem"
    pub = "#{prefix}.pub"
    unless File.exist?(pem)
      system("openssl genrsa -out #{pem}")
      system("openssl rsa -pubout -in #{pem} -out #{pub}")
    end
  end

  # Tell minion where its master is
  unless File.exist?("salt/etc/minion")
    open("salt/etc/minion", "w").write("master: #{master_ip}\n")
  end

  config.vm.define :master do |vm_config|
    vmname = "master"

    vm_config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 1
      vb.name = vmname
    end

    vm_config.vm.box = os
    vm_config.vm.host_name = vmname
    vm_config.vm.network "private_network", ip: "#{master_ip}"
    vm_config.vm.synced_folder "salt/salt/", "/srv/salt"
    vm_config.vm.synced_folder "salt/pillar/", "/srv/pillar"
    vm_config.vm.synced_folder "salt/formulas", "/srv/formulas"

    vm_config.vm.provision :salt do |salt|
      salt.master_config = "salt/etc/master"
      salt.master_key = "salt/keys/#{vmname}.pem"
      salt.master_pub = "salt/keys/#{vmname}.pub"
      salt.minion_key = "salt/keys/#{vmname}.pem"
      salt.minion_pub = "salt/keys/#{vmname}.pub"
      salt.seed_master = {
        "minion" => "salt/keys/minion.pub"
      }
      salt.install_type = "git"
      # Include PR #43088
      salt.install_args = "2017.7"
      salt.install_master = true
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
    end
  end

  config.vm.define :minion, primary: true do |vm_config|
    vmname = "minion"

    vm_config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
        vb.name = vmname
    end

    vm_config.vm.box = os
    vm_config.vm.hostname = vmname
    vm_config.vm.network "private_network", ip: "#{minion_ip}"
    vm_config.vm.network "forwarded_port", guest: 8080, host: 8080

    vm_config.vm.provision :salt do |salt|
      salt.minion_config = "salt/etc/minion"
      salt.minion_key = "salt/keys/#{vmname}.pem"
      salt.minion_pub = "salt/keys/#{vmname}.pub"
      salt.install_type = "git"
      # Include PR #43088
      salt.install_args = "2017.7"
      salt.verbose = true
      salt.colorize = true
      salt.run_highstate = true
    end
  end
end
