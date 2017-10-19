sudo su
mkdir /montagu
git clone https://github.com/vimc/montagu-backup /montagu/backup
git clone https://github.com/vimc/montagu-vault  /montagu/vault

cd /montagu/backup

mkdir -p /etc/montagu/backup
cp /montagu/backup/configs/support.montagu/* /etc/montagu/backup/

# This step here fails because it's doing too much
## /montagu/backup/setup.sh

file_name=duplicati_2.0.1.73-1_all.deb

apt-get -q install gdebi cron -y
if [ ! -f ${file_name} ]; then
    wget https://updates.duplicati.com/experimental/${file_name}
fi
dpkg -s duplicati 2>/dev/null >/dev/null || gdebi --non-interactive ${file_name}

apt-get install python3-pip -y
pip3 install --quiet -r ${BASH_SOURCE%/*}/requirements.txt
