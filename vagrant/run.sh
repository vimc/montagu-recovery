sudo su
mkdir /mnt/data/montagu
ln -s /mnt/data/montagu /montagu

git clone https://github.com/vimc/montagu-backup /montagu/backup
git clone https://github.com/vimc/montagu-vault  /montagu/vault

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/

pip3 install --quiet -r /montagu/backup/requirements.txt

## At this point copy over a suitable /etc/montagu/backup/secrets.json file

/montagu/backup/restore.py
