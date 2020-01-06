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
If you don't have Virtualbox and Vagrant set up like this.
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
```
Edit Vagrant file for vagrant up.
Attention: "config.vm.synced_folder" is super important to customise for your share folder. 
```
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
  # MacOSX(Mojave) needs permission at system > sequrity,privacy > Full disk access > add your terminal soft.
  # MacOSX(Catalina) needs add prefix "/System/Volumes/Data" for your local folder.
  # (Edit your enviroment. OS and username and working directory.)
  #
  # config.vm.synced_folder "/Users/sakai/dev/magento2nginx", "/home/vagrant/magento2nginx", type: "nfs"
  config.vm.synced_folder "/System/Volumes/Data/Users/sakai/dev/magento2nginx", "/home/vagrant/magento2nginx", type: "nfs"
  
end
---
```

## Into vagrant using ssh and built a docker environment
```
$ vagrant up
$ vagrant ssh
```

### download newest Docker Compose
```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

### set permission for runnnig binary
```bash
$ sudo chmod +x /usr/local/bin/docker-compose
```
## Clone or Download magent2docker container build files from github
```bash
git clone git@github.com:bluemooninc/magento2nginx.git
[vagrant@localhost ~]$ cd magento2docker
[vagrant@localhost ~]$ vi docker-compose.yaml
```

## Customise and build a docker container

### Container Description

* Magento2.3.3

  Magento front http://localhost
  Magento admin http://localhost/admin/ ( depend your setup )

* PHP7.2 and BlackFire-agent
  
  Customise at ./data/phpfpm/php.ini ( Edit for your timezone )
  date.timezone = Asia/Tokyo
  
  As you can see blaclfire status.
```bash
  php -i | grep blackfire
```
  
* MySql5.7
* phpMyAdmin4.9

  Database GUI http://localhost:8085
  ID:root
  PW:password
  
* mailCatcher

  mailCatcher is a internal use SMTP server witch has client GUI.

  You may check any sendmail from Magento service.

  mail Client GUI is http://localhost:1080
* Edit for your docker-compose.yaml
  those parameter is blackfire.io and date/time-zone.
  Get your account at https://blackfire.io and change YOUR_SOMETHING_ID,TOKEN.
  And also you need to install Chrome or firefox browser extension about blackfire client.
```yaml
  # Exposes the host BLACKFIRE_SERVER_ID and TOKEN environment variables.
  BLACKFIRE_SERVER_ID : YOUR_SERVER_ID
  BLACKFIRE_SERVER_TOKEN : YOUR_SERVER_TOKEN
  BLACKFIRE_CLIENT_ID : YOUR_CLIENT_ID
  BLACKFIRE_CLIENT_TOKEN : YOUR_CLIENT_TOKEN
  TZ: "Asia/Tokyo"
```

# Into Docker by ssh and setup your magento
At vagrant ssh, You can build docker environment using docker-compose.
```bash
# Build and run your container
docker-compose up

# Open other ssh window
＃ List up your runnig container
docker ps

# ssh login to php container
docker exec -it phpfpm /bin/sh

#
# install magento ( you have to get account at magento.com )
#
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento
Username: [YOUR-PUBLIC-KEY]
Password: [YOUR-PRIVATE-KEY]

chmod -R 777 /var/www/html

### Error Tips: When you've got an error below.
[Exception] Warning: SessionHandler::read():
Please add the below code in app/etc/env.php and it will works fine.
array (
'save' => 'files',
'save_path' => '/tmp',
),
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

# Exit all and rest your time
docker-compose down
vagrant halt
bye!!!

# License

MIT License.
See [LICENSE](LICENSE).

