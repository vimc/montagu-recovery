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

## 4. TeamCity
git clone https://github.com/vimc/montagu-ci /montagu/montagu-ci
mkdir -p /montagu/montagu-ci/shared/restore
TEAMCITY_LATEST=$(ls -1tr /montagu/teamcity | tail -n1)
cp $TEAMCITY_LATEST /montagu/montagu-ci/shared/restore/TeamCity_Backup.zip

## The last bit can't be done via a vagrant machine because it needs
## to run a vagrant instance and virtualbox does not support nested
## virtualisation.  So we test this bit elsewhere (via montagu-ci's
## montagu-ci-backup machine).  But outside of VM-land we'd just do
cd /montagu/montagu-ci
vagrant up montagu-ci-server
vagrant up montagu-ci-agent-01
vagrant up montagu-ci-agent-01
vagrant up montagu-ci-agent-01

cp $TEAMCITY_LATEST /vagrant/TeamCity_Backup.zip
