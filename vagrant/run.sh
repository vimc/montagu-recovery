sudo su
mkdir /mnt/data/montagu
ln -s /mnt/data/montagu /montagu

git clone https://github.com/vimc/montagu-backup /montagu/backup
git clone https://github.com/vimc/montagu-vault  /montagu/vault

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/
cp /vagrant/secrets.json /etc/montagu/backup/secrets.json

pip3 install --quiet -r /montagu/backup/requirements.txt

/montagu/backup/restore.py

## Get the vault up
git -C /montagu/vault checkout i959
(cd /montagu/vault && ./run-no-ssl.sh)

/montagu/vault/unseal-loopback.sh
/montagu/vault/unseal-loopback.sh

(cd /montagu/vault && ./restart-with-ssl.sh)

export VAULT_ADDR=https://support.montagu.dide.ic.ac.uk:8200
vault unseal
vault unseal
