# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "sanoma"
  config.vm.hostname = "sanoma.local"

  # The image URL that was provided for the project.
  config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/snm-nl-hostingsupport-test/vagrant-centos-6-4.box"

  # Port forwarding so that you can access the site from your PC.
  config.vm.network "forwarded_port", guest: 8000, host: 8080

  # Not needed, but you might set up an http (apache) server too.
  config.vm.network "forwarded_port", guest: 80, host: 8090

  # In case you want to go directly to the boxe's IP, however not needed
  #config.vm.network "private_network", ip: "192.168.30.253"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # This wasn't working, but neither was it wanted or required
  #Vagrant.configure("2") do |config|
  #  config.vm.synced_folder "mezzanine/", "/home/vagrant/mezzanine"
  #end

  # Enable provisioning with Puppet stand alone.
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "deploy"
    puppet.manifest_file  = "site.pp"
    # There are no modules, yet. So this is for later.
    puppet.module_path = "deploy/modules"
  end
end
