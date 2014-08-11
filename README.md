# CoinStore

CoinStore is a lightweight eCommerce platform with cryptocurrency support. It allows you to deploy online store accepting bitcoin and altcoins in a minutes, free of charge.


**Table of Contents**
- [Running locally](#running-locally)
    - [Install Meteor and Meteorite](#install-meteor-and-meteorite)
    - [Install ImageMagick](#install-imagemagick)
    - [Clone project repository](#clone-project-repository)
    - [Edit website settings](#edit-website-settings)
    - [Launch website locally](#launch-website-locally)
- [Deploying to server](#deploying-to-server)
    - [Server requirements](#server-requirements)
    - [Preparing server for deployment](#preparing-server-for-deployment)
    - [Preparing website for deployment](#preparing-website-for-deployment)
    - [Deployment](#deployment)
    - [Grant privileges for writing](#grant-privileges-for-writing)
    - [Further deployments](#further-deployments)
- [Website configuration](#website-configuration)
- [Payment gateway configuration](#payment-gateway-configuration)
    - [C-CEX](#c-cex)
- [Donations](#donations)

## Running locally
This guide will allow you to run and test web store locally. Currently, following platforms are supported:
* Mac: OS X 10.6 and above
* Linux: x86 and x86_64 systems

If you have Windows operating system, consider installing Linux either on virtual machine or side by side with Windows. If you don't have experience in Linux distributions, I strongly recommend [Ubuntu](http://www.ubuntu.com/download/desktop) for easier installation.

### Install Meteor and Meteorite

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

###Clone project repository
``` sh
git clone https://github.com/danii1/coinstore
```
_Git is required for this step, refer to http://git-scm.com/book/en/Getting-Started-Installing-Git if it's not installed on your system_

###Edit website settings
Copy settings example into the new file and change what you need, refer to website configuration section
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
This guide focuses on minimal single server setup which is appropriate for small scale webstore, it's short, and takes about 10-15 minutes to deploy website. Scalability, replication, backups, load balancing are out of the scope of this article. Guide should work for any Debian/Ubuntu 12.04 or higher distributions.

### Server requirements
You will need at least 512MB RAM on server, other characteristics is less important, but having faster CPU will help if you planning to host large site, large disk space come in handy if you are selling digital items such as music, ebooks, games and hosting them on the same server. If you need recommendation on chosing VPS providers, I had good experience with [Linode](https://www.linode.com/?r=cb553d9cb7d8dd8f836c748b9f5c690c3f549bbe) and [Digital Ocean](https://www.digitalocean.com/?refcode=7679e1b32f02), both are great and have competitive pricing.

### Preparing server for deployment
Login to server and execute following commands:
``` sh
# install mongodb from 2.6.x branch, as 2.4.x contains bug that affects CoinStore
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
apt-get update -y
apt-get install mongodb-org

# install ImageMagick
apt-get install imagemagick
```

### Preparing website for deployment
Do the folowing on you local machine
####Clone project repository
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
This commands create directory and generate 2 files: settings.json - settings of your website(it's empty, you should copy contents of settings-example.json to this file, refer to website configuration section for details); mup.json - deployment parameters(you should set server, username, password or ssh key and some other params). Ensure that param setupMongo set to false(we installed newer mongo version previously and should skip this step in deployment script):
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
There few last steps need to be done on server: grant writing privileges for _meteoruser_, so you can upload images and other files to server.
``` sh
# your website will be located in /opt/appName(you set appName in mup.json)
cd /opt/coinstore
mkdir cfs
chown meteoruser:meteoruser cfs

# change owner for uploads folder(use your storageDir from settings.json)
chown -R meteoruser:meteoruser /opt/coinstore_uploads
```
That's all, after this you should be able to open your website and test it. In case of problems check `/var/log/upstart/appName.log` for errors.

### Further deployments
All further deployments(if you updating to the latest version, or customizing your website ) should require only running
`mup deploy` without any additional steps.

## Website configuration
There are few settings that allows you to change website appearance and some important options such as your merchant id or where files will be stored. Template for settings is located in `settings-example.json`, contents of this file should be copied to `settings.json` and edited there. Currently following params are avaiable, most of them are self explanatory:

- `storeName` - name of your store, this name will be displayed on the top and few other places
- `itemsInRow` - number of items in a row displayed on the frontpage, valid values are 2, 3, 4, 6. Optimal numbers are probably 3 and 4. You can set 2 if you have a few items to sell.
- `storageDir` - files uploaded from admin interface will be stored in this directory, user used to launch website should have write and read access to this directory
- `adminUser` - administrator email and password, this credentials will be used to create admin user for new installations. You should change this to your email and set a strong password, password can be changed later through interface.
- `merchantId` - set this param to your merchant id obtained from [C-CEX](https://c-cex.com/?rf=278C17E805357FAD).


## Payment gateway configuration
Currenly only one gateway for accepting cryptocurrencies is supported.
### C-CEX
You should be registered on [C-CEX](https://c-cex.com/?rf=278C17E805357FAD). Login to your profile and switch to MERCHANT API tab, you'll need to set 2 urls:
- Return url: `http://yourAddress/purchase`
- Secret url: `http://yourAddress/purchaseComplete`

where `yourAddress` is your website address. First url will be used to redirect user after purchase, second to transfer data about purchase.


## Donations

If you find the product useful, please consider making a donation

Bitcoin: [12XdXRLEMWHRfX76YnRTXwXVZmNA7qU5en](bitcoin:12XdXRLEMWHRfX76YnRTXwXVZmNA7qU5en)
