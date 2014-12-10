Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "https://vagrantcloud.com/ubuntu/trusty64"
    config.vm.network :private_network, ip: "192.168.56.104"


    config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", "headless-drupal-template"]
    end

    config.vm.synced_folder "./www", "/var/www", create: true
    config.vm.synced_folder "./sqldump", "/var/sqldump", create: true
    config.vm.synced_folder "./scripts", "/var/scripts", create: true
    config.vm.synced_folder "./custom_config_files", "/var/custom_config_files", create: true

    config.vm.provision :shell, :path => "scripts/bootstrap.sh"
    config.vm.provision :shell, run: "always", :path => "scripts/drupal7.sh"
    config.vm.provision :shell, run: "always", :path => "scripts/load.sh"
end
