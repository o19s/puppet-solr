# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  ["tomcat6", "jetty"].each do |puppet_base|
    [
      {
         name: "puphpet/debian75-x64",
         url: "puphpet/debian75-x64",
         port: 8983
      },
      {
         name: "puphpet/ubuntu1404-x64",
         url: "puphpet/ubuntu1404-x64",
         port: 8983
      },
      {
        name: "puphpet/centos65-x64",
        url: "puphpet/centos65-x64",
        port: 8983
      },
    ].each do |vm_info|
    # Need to replace '/' with '-' because in Vagrant 1.6.5 it throws an error, like: "The sub-VM name 'puphpet/debian75-x64-jetty' is invalid. Please don't use special characters."
      config.vm.define "#{vm_info[:name]}-#{puppet_base}".tr('/', '-') do |custom|
        custom.vm.network :forwarded_port, guest: 8983, host: vm_info[:port]
        custom.vm.box = vm_info[:name]
        custom.vm.box_url = vm_info[:url]
        custom.vm.provision :puppet do |puppet|
          puppet.manifests_path  = "."
          puppet.manifest_file  = "#{puppet_base}.pp"
          puppet.options = ['--verbose']
        end
      end

    end
  end

  config.vm.synced_folder ".", "/etc/puppet/modules/solr"

end
