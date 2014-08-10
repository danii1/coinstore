# CoinStore

CoinStore is a lightweight eCommerce platform with cryptocurrency support. It allows you to deploy online store accepting bitcoin and altcoins in a minutes, free of charge.


**Table of Contents**
- [Running locally](#running-locally)
- [Deploying to server](#deploying-to-server)
- [Donations](#donations)

## Running locally
This guide will allow you to run and test web store locally. Currently, following platforms are supported:
* Mac: OS X 10.6 and above
* Linux: x86 and x86_64 systems

If you have Windows operating system, consider installing Linux either on virtual machine or side by side with Windows. If you don't have experience in Linux distributions, I strongly recommend [Ubuntu](http://www.ubuntu.com/download/desktop) for easier installation.

### Install [Meteor](http://docs.meteor.com/#quickstart) and [Meteorite](https://github.com/oortcloud/meteorite/#installing-meteorite) first:

``` sh
curl https://install.meteor.com | /bin/sh
npm install -g meteorite
```
###Install ImageMagick
Linux:
``` sh
apt-get install imagemagick
```

Mac OS X:
``` sh
brew install imagemagick
```

###Clone preject repository
``` sh
git clone https://github.com/danii1/coinstore
```
_Git is required for this step, refer to http://git-scm.com/book/en/Getting-Started-Installing-Git if it's not installed on your system_

###Edit website settings
Copy settings example into the new file and change what you need(store name, merchant id, etc)
``` sh
cd coinstore
cp settings-example.json settings.json 
```
###Launch website locally
Now launch meteor with your settings, website should become available on http://localhost:3000
``` sh
meteor --settings settings.json
```

## Deploying to server
This guide focuses on minimal single server setup which is appropriate to small scale webstore, it's short, and takes only 5-10 minutes deploy website. Scalability, replication, backups, load balancing are out of the scope of this article. Guide should work for any Debian/Ubuntu 12.04 or higher distributions.

### Server requirements
You will need at least 512MB RAM on server, other characteristics is less important, but having faster CPU will help if you planning to host large site, large disk space come in handy if you are selling digital items such as music, ebooks, games and hosting them on the same server. If you need recommendation on chosing VPS providers, I had good experience with [Linode](https://www.linode.com/?r=cb553d9cb7d8dd8f836c748b9f5c690c3f549bbe) and [Digital Ocean](https://www.digitalocean.com/?refcode=7679e1b32f02), both are great and have competitive pricing.

### Preparing server for deployment
Login to server and execute following commands:
``` sh
# install mongodb from 2.5.x branch, as 2.4.x contains bug that affects CoinStore
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
apt-get update -y
apt-get install mongodb-10gen-unstable

# install ImageMagick
apt-get install imagemagick
```

### Preparing website for deployment
Do the folowing on you local machine
####Clone preject repository
``` sh
git clone https://github.com/danii1/coinstore
```
#### Intall Meteor Up
``` sh
npm install -g mup
```
#### Create deployment project
``` sh
mkdir ~/coinstore-deployment
cd ~/coinstore-deployment
mup init
```
This commands create directory and generate 2 files: settings.json - settings of your website(it's empty, you should copy contents of settings-example.json to this file and edit as you need: set website name, merchantId, etc); mup.json - deployment parameters(you should set server, username, password or ssh key and some other params). You should ensure that param setupMongo set to false(we installed newer mongo version previously and should skip this step in deployment script):
``` json
"setupMongo": false
```
### Deployment
Being in deployment project directory, run
``` sh
# this will prepare server for deployment
mup setup

# actually deploy website
mup deploy
```
If you get any errors during deployment, you can check logs by running _mup logs_. Refer to [Meteor Up readme](https://github.com/arunoda/meteor-up) for full info.

### Grant privileges for writing
There few last steps need to be done, you'll need to grant writing privileges for _meteoruser_, so you can upload images and other files to server.
``` sh
# your website will be located in /opt/appName(you set appName in mup.json) 
cd /opt/coinstore
mkdir cfs
chown meteoruser:meteoruser cfs

# change owner for uploads folder(use your storageDir from settings.json)
chown -R meteoruser:meteoruser /opt/coinstore_uploads
```
That's all, after this you should be able to open your website and test it. In case of problems check `/var/logs/upstart/appName.log` for errors

## Donations

If you find the product useful, please consider making a donation

Bitcoin: 12XdXRLEMWHRfX76YnRTXwXVZmNA7qU5en
