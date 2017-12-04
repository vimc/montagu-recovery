# montagu recovery

Further documentation and scripts for testing the montagu recovery process (work in progress).

[Main disaster recovery documenation](https://github.com/vimc/montagu/blob/master/docs/DisasterRecovery.md) lives in the [montagu repository](https://github.com/vimc/montagu)

The biggest faff here is getting the AWS secrets into the test environment.  Copy (or create) the file `secrets.json` (it has the keys `aws_secret_access_key`, `passphrase` and `aws_access_key_id`).

This also takes a *lot* of space.  Vagrant will set up a virtual disk that is >100GB large.  This is needed because of all the docker containers and the sheer size of the backups.  Make sure you run this in a place with a lot of spare disk.  Once we trim down the registry this will become a bit smaller.  A good choice is the annex's `/mnt/data`

```
git clone https://github.com/vimc/montagu-recovery.git
git -C montagu-recovery checkout i423
sudo ./montagu-recovery/provision.sh
cd montagu-recovery/vagrant
cp path/to/secrets.json shared/secrets.json
chmod 600 shared/secrets.json
vagrant up
```

Then work through the `run.sh` script - this requires user intervention for getting the vault up and on some interaction with the vault.

At the end of that script everything is done except for TeamCity.  That can't be tested within the virtual machine, so come *back out* and run, from within `montagu-recovery`

```
git clone https://github.com/vimc/montagu-ci.git montagu-ci
cp vagrant/shared/TeamCity_Backup.zip montagu-ci/shared/restore
cd montagu-ci
vagrant up montagu-ci-server
```
