# Debian

## Wheezy

Add the source to your `/etc/sources.list` or `/etc/sources.list.d/`:

    deb http://apt.rbel.co/debian/clearskies/wheezy/ ./

Import my GPG key:

   sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com F345BE74

Install it:

    apt-get update && apt-get install clearskies


Start it:

    clearskies start
