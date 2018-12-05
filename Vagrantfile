# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
echo Provisioning…
sudo apt-get update
sudo apt-get install default-jdk protobuf-compiler python-protobuf python npm -y
sudo apt-get install php7.0-cli
sudo apt-get install php-dom
sudo apt-get install composer
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
sudo apt-get install phpunit
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: $script

  config.vm.box = "apnunes/xenial-python"
  config.vm.box_version = "1.0.0"

  config.ssh.forward_agent = true

  config.vm.boot_timeout = 900

  config.vm.network "forwarded_port", guest:  22, host: 2229
  config.vm.network "forwarded_port", guest:  80, host: 8081, auto_correct:config

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
end
