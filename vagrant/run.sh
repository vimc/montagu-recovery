## NOTE: this is not meant to be run noninteractively.  Run through
## this section by section by copying and pasting it into the terminal
## in the virtual machine (or real machine if you're doing a rebuild
## of support.montagu).  For further documentation see
## vimc/montagu:docs/DisasterRecovery.md

## 0. Basic prep.  We're going to go through stacks of data here so
## get everything working on the VM's large disk.  We also need to be
## root for much of this.
sudo su
mkdir /mnt/data/montagu
ln -s /mnt/data/montagu /montagu

## 1. Prepare and restore the backup
##
## WARNING: this takes *ages* - like 6 hours or so.  It will also
## download >100GB of data off S3 (which has a small cost)
git clone https://github.com/vimc/montagu-backup /montagu/backup

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/
cp /vagrant/secrets.json /etc/montagu/backup/secrets.json

pip3 install --quiet -r /montagu/backup/requirements.txt

/montagu/backup/restore.py

## 2. Get the vault up
##
## NOTE: This requires quite a bit of manual intervention
git clone https://github.com/vimc/montagu-vault  /montagu/vault
/montagu/vault/run.sh

## Unlock the vault; these commands can be (and probably should be)
## run remotely, though if you're doing this on a test restore machine
## and spoofing the domain name via /etc/hosts then you'll need to do
## it on the restore VM.
##
## Two people must execute this.
export VAULT_ADDR=https://support.montagu.dide.ic.ac.uk:8200
vault unseal
vault unseal

## 3. Registry
git clone https://github.com/vimc/montagu-registry  /montagu/registry
pip3 install --user -r /montagu/registry/requirements.txt
(cd /montagu/registry && ./montagu-registry start)

## 4. TeamCity
## Restoring TeamCity can't be done via a vagrant machine because it
## needs to run a vagrant instance and virtualbox does not support
## nested virtualisation.  So we test this bit elsewhere (via
## montagu-ci's montagu-ci-backup machine).
##
## But it can still be tested as part of this process.  We just have
## to copy the most recently restored teamcity backup out of this VM
## and into the host, then resore on the host.
TEAMCITY_LATEST=$(ls -1tr /montagu/teamcity | tail -n1)
$TEAMCITY_LATEST /vagrant/TeamCity_Backup.zip

## Then, outside of VM-land, within the directory *above* the vagrant
## directory, run:
git clone https://github.com/vimc/montagu-ci.git montagu-ci
mkdir -p montagu-ci/shared/restore
cp vagrant/shared/TeamCity_Backup.zip montagu-ci/shared/restore
cd montagu-ci
vagrant up montagu-ci-server
vagrant up montagu-ci-agent-01 montagu-ci-agent-02 montagu-ci-agent-03
