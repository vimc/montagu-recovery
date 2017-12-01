#!/usr/bin/env bash
if which -a virtualbox > /dev/null; then
    echo "VirtualBox is already installed"
else
    echo "Installing VirtualBox"
    curl -fsSl https://www.virtualbox.org/download/oracle_vbox_2016.asc |
        apt-key add -
    curl -fsSl https://www.virtualbox.org/download/oracle_vbox.asc |
        apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian \
   $(lsb_release -cs) \
   contrib"
    sudo apt-get update
    sudo apt-get install -y virtualbox-5.2
fi

if which -a vagrant > /dev/null; then
    echo "Vagrant is already installed"
else
    VAGRANT_VERSION=2.0.1
    VAGRANT_DEB=vagrant_${VAGRANT_VERSION}_x86_64.deb
    VAGRANT_URL=https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/${VAGRANT_DEB}
    wget $VAGRANT_URL
    dpkg --install $VAGRANT_DEB
    rm -f $VAGRANT_DEB
fi
