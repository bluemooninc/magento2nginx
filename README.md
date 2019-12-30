# Magento2nginx

This project is build docker images for Magento2 that useing nginx and php-fpm.
Not only local enviroment but also build Multi-binary for Japan,Korea,China and Russia charactors.

Memo: Do NOT use 'docker for macintosh'. mac os file system and docker share holder is really slow.
I strongly recommend use VirtualBox and Vagrant launch linux(CentOS etc.) for Docker base.

# Required

* virtualbox
https://www.virtualbox.org/

* Vagrant
https://www.vagrantup.com/

## Setup Vagrant
```
$ vagrant box add centos/7

1) hyperv
2) libvirt
3) virtualbox
4) vmware_desktop

Enter your choice: 3

$ vagrant box list
$ mkdir -p  ~/vagrant
$ cd ~/vagrant
$ vagrant init centos/7

$ vi Vagrantfile
----
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # Up to memory 8G Byte
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 4
  end
  #
  # Make Docker available on the VM from the beginning
  #  
  config.vm.provision "docker"

  # Port forwarding to the host side so that you can browse the web screen and phpMyAdmin
  config.vm.network "private_network", ip: "172.12.8.150"
  config.vm.network "forwarded_port", host: 80, guest: 80 # Magento
  config.vm.network "forwarded_port", host: 8085, guest: 8085 # phpMyAdmin
  config.vm.network "forwarded_port", host: 1080, guest: 1080 # mailCatcher
  #
  # Share your project folder which has docker-compose.yml to vagrant home folder
  # Mac OSX is needs for permission to teminal soft at system > sequrity,privacy > Full disk access > add terminal soft.
  # ( Edit home dir for your enviroment. )
  #
  config.vm.synced_folder "/Users/sakai/dev/magento2nginx", "/home/vagrant/magento2nginx", type: "nfs"
end
---
##
## How to use
##
$ vagrant up
$ vagrant ssh

# download newest Docker Compose
# Change `1.17.1` for the version (Check https://github.com/docker/compose/releases)
$ sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# set permission for runnnig binary
$ sudo chmod +x /usr/local/bin/docker-compose

# Download magent2 docker setting files from github
git clone git@github.com:bluemooninc/magento2nginx.git
[vagrant@localhost ~]$ cd magento2docker
[vagrant@localhost ~]$ docker-compose up
```

## Setup Docker

### Environment

* Magento2.3

  Magento front http://localhost

  Magento admin http://localhost/admin/ ( depend your setup )
* PHP7.3
  
  Customise at ./data/phpfpm/php.ini ( Edit for your timezone )
  
  date.timezone = Asia/Tokyo
* MySql5.7
* phpMyAdmin4.9

  Database GUI http://localhost:8085
* mailCatcher

  mailCatcher is a internal use SMTP server witch has client GUI.

  You may check any sendmail from Magento service.

  mail Client GUI is http://localhost:1080
* Docker

  docker-compose.yml ( Edit for your timezone )

      environment:
        TZ: "Asia/Tokyo"

### How To Run

```bash
# Build and run your container
docker-compose up

# Open other ssh window
＃ List up your runnig container
docker ps

# ssh login to php container
docker exec -it phpfpm /bin/sh

# install composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#
# install magento ( you have to get account at magento.com )
#
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento
Username: [YOUR-PUBLIC-KEY]
Password: [YOUR-PRIVATE-KEY]

chmod -R 777 /var/www/html

```

# Create database

at phpMyAdmin ( http://localhost:8085 )
```
CREATE DATABASE magento DEFAULT CHARACTER SET utf8mb4;
```

host: mysql
ID: root
PW: password


# install cron
php bin/magento cron:install
# make sure
crontab -e

# reindex
php bin/magento indexer:reindex

# cache clear
php bin/magento cache:flush

# download sample data
php bin/magento sampledata:deploy
# Setup sample data
php bin/magento setup:upgrade


docker-compose down
vagrant halt
bye!!!

# License

MIT License.
See [LICENSE](LICENSE).

