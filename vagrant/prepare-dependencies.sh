#!/bin/sh

apt-get update
apt install -y \
    git \
    python3-pip \
    unzip

if which -a docker > /dev/null; then
    echo "docker is already installed"
else
    echo "installing docker"
    mkdir /mnt/data/docker
    ln -s /mnt/data/docker /var/lib/docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    sudo usermod -aG docker vagrant
fi

if which -a vault > /dev/null; then
    echo "vault is already installed"
else
    VAULT_VERSION=0.8.3
    VAULT_ZIP=vault_${VAULT_VERSION}_linux_amd64.zip
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ZIP}
    unzip ${VAULT_ZIP}
    rm ${VAULT_ZIP}
    mv vault /usr/bin
fi

if which -a duplicati > /dev/null; then
    echo "duplicati is already installed"
else
    DUPLICATI_DEB=duplicati_2.0.1.73-1_all.deb
    apt-get -q install gdebi cron -y
    if [ ! -f ${DUPLICATI_DEB} ]; then
        wget https://updates.duplicati.com/experimental/${DUPLICATI_DEB}
    fi
    dpkg -s duplicati 2>/dev/null >/dev/null || gdebi --non-interactive ${DUPLICATI_DEB}
    rm -f $DUPLICATI_DEB
fi


if fgrep support.montagu.dide.ic.ac.uk /etc/hosts > /dev/null; then
    echo "Hosts already set up"
else
    echo "Setting ourselves up as support.montagu.dide.ic.ac.uk"
    echo "127.0.0.1 support.montagu.dide.ic.ac.uk support" >> /etc/hosts
fi
