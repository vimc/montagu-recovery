sudo su
mkdir /mnt/data/montagu
ln -s /mnt/data/montagu /montagu

## 1. Prepare the backup
git clone https://github.com/vimc/montagu-backup /montagu/backup

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/
cp /vagrant/secrets.json /etc/montagu/backup/secrets.json

pip3 install --quiet -r /montagu/backup/requirements.txt

/montagu/backup/restore.py

## 2. Get the vault up
git clone https://github.com/vimc/montagu-vault  /montagu/vault
git -C /montagu/vault checkout i959
(cd /montagu/vault && ./run-no-ssl.sh)

## This goes twice
/montagu/vault/unseal-loopback.sh
/montagu/vault/unseal-loopback.sh

## Restart vault
(cd /montagu/vault && ./restart-with-ssl.sh)

## Unlock a second time
export VAULT_ADDR=https://support.montagu.dide.ic.ac.uk:8200
vault unseal
vault unseal

## 3. Registry
git clone https://github.com/vimc/montagu-registry  /montagu/registry
pip3 install --user -r /montagu/registry/requirements.txt
(cd /montagu/registry && ./montagu-registry start)
