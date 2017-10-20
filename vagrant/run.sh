sudo su
mkdir /montagu
git clone https://github.com/vimc/montagu-backup /montagu/backup
git clone https://github.com/vimc/montagu-vault  /montagu/vault

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/

pip3 install --quiet -r /montagu/backup/requirements.txt

/montagu/backup/restore.py
