# CoinStore

CoinStore is a lightweight eCommerce platform with cryptocurrency support. It allows you to deploy online store accepting bitcoin and altcoins in a minutes, free of charge.

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


## Donations

If you find the product useful, please consider making a donation

Bitcoin: 12XdXRLEMWHRfX76YnRTXwXVZmNA7qU5en
