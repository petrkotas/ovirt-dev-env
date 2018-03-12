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

### VDSM helpers

The host machine has the vdsm helpers preinstalled. These helpers allow for
ease build, install, reinstall and unistall of the VDSM on the host.

These helpers are:
```

```
