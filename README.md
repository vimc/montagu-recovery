# montagu recovery

Further documentation and scripts for testing the montagu recovery process (work in progress).

[Main disaster recovery documenation](https://github.com/vimc/montagu/blob/master/docs/DisasterRecovery.md) lives in the [montagu repository](https://github.com/vimc/montagu)

This takes a *lot* of space.  Vagrant will set up a virtual disk that is >100GB large.  This is needed because of all the docker containers and the sheer size of the backups.  Make sure you run this in a place with a lot of spare disk.  Once we trim down the registry this will become a bit smaller.  A good choice is the annex's `/mnt/data`

```
git clone https://github.com/vimc/montagu-recovery.git
cd montagu-recovery
sudo ./provision.sh
sudo pip3 install -r vault/requirements.txt
./get_secrets
cd vagrant
vagrant up
```

Then work through the [`vagrant/run.sh`](vagrant/run.sh) script - this requires user intervention for getting the vault up and on some interaction with the vault.

At the end of that script everything is done except for TeamCity.  That can't be tested within the virtual machine, so come *back out* and run, from within the `montagu-recovery` directory (i.e., here)

```
git clone https://github.com/vimc/montagu-ci.git montagu-ci
mkdir -p montagu-ci/shared/restore
cp vagrant/shared/TeamCity_Backup.zip montagu-ci/shared/restore
cd montagu-ci
vagrant up montagu-ci-server
vagrant up montagu-ci-agent-01 montagu-ci-agent-02 montagu-ci-agent-03
```

To destroy the machine (e.g., to do it again) you will have to remove the disk explicitly

```
vagrant destroy
vboxmanage closemedium disk data_disk.vdi --delete
```

(don't just delete the `.vdi` file manually or VirtualBox will complain next time we use the machine).
