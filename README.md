# oVirt development environment

All developers knows the pain of setting up local development environment.
There are many small challenges that has to be setup.

This small repository aims to simplify oVirt development by providing
easy to start environment with one engine running and one host
setup with oVirt hypervisor and nested virtualization enabled.

## Requirements

* KVM enabled machine
* QEMU
* vagrant-libvirt
* vagrant
* vagrant-hostmanager
* NFS enabled

## How to use

```
Default username: admin
Default password: admin
```

Setup the NFS. On the Ubuntu install nfs by following:

```bash
apt-get install nfs-kernel-server
```

The Vagrant will setup the rest.

### NFS setup

To make the storage domain work, the NFS server have to be setup on the host machine.
The simplest way is to install the NFS server from the distribution repositories.

Ubuntu:

```bash
sudo apt install nfs-kernel-server rpcbind
```

Fedora:

```bash
sudo yum install nfs-utils system-config-nfs
```

Configure the nfs:

On Fedora it is important to set the folder permissions to user `vdsm:36` and group `kvm:36`.
On Ubuntu use the workaround to override the uid and guid and force them to `36:36`
In `/etc/exports` set:

```bash
"/export/domains" *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
```

Important part is the all_squash na anonuid and anonguid. This rewrite all
uid an guid to be `36:36`.

Without this setup, the NFS storage domain will not work.

### VDSM helpers

The host machine has the vdsm helpers preinstalled. These helpers allow for
ease build, install, reinstall and unistall of the VDSM on the host.

These helpers are:
```

```
