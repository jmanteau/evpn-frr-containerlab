# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian10"
  config.vm.provider :libvirt do |domain|
    domain.memory = 8096
    domain.cpus = 2
    domain.nested = true
  end
  config.vm.synced_folder ".", "/vagrant"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1
    apt-get update
    apt-get install apt-transport-https ca-certificates curl gnupg lsb-release ntp -y
    apt-get install tmux tcpdump tshark python3-pip -y
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io -y
    apt-get install docker-ce=5:20.10.6~3-0~debian-buster docker-ce-cli=5:20.10.6~3-0~debian-buster containerd.io=1.4.4-1 -y
    bash -c "$(curl -sL https://get-clab.srlinux.dev)" 
    modprobe 8021q
    pip3 install ansible ansible-lint -U
    #ntpd -gq
  SHELL
end
