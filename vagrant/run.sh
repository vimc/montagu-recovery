sudo su
mkdir /montagu
git clone https://github.com/vimc/montagu-backup /montagu/backup
git clone https://github.com/vimc/montagu-vault  /montagu/vault

cd /montagu/backup

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/

# This step here fails because it's doing too much - I've moved the
# bulk of this into the main provisioning script but we still need to
# access secrets to get at the aws key.  For now I am working around
# this by manually setting up the /etc/montagu/secrets.json file and
# *not* running setup.sh

/montagu/backup/restore.py
