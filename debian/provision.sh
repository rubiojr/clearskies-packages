#!/usr/bin/env bash
# vim: shiftwidth=2 tabstop=2 expandtab

[ "`whoami`" = "root" ] || {
  exec sudo -u root "$0" "$@"
}

# Install minimal requirements
sudo apt-get update
sudo apt-get install -y dpkg-dev lsb-release

VERSION=0.0.0
TMPDIR=`mktemp -d`
PKG_NAME=clearskies
TARGET_DIR=$TMPDIR/opt/$PKG_NAME
DEBIAN_REVISION=git`date +%Y%m%d`
CODENAME=`lsb_release -c|awk '{print $2}'`
PKG_ARCH=`dpkg-architecture -qDEB_BUILD_ARCH`

export DEBIAN_FRONTEND=noninteractive 

# Install requirements
apt-get install -y git ruby1.9.1-dev libxml2-dev libxslt1-dev

[ -d $TARGET_DIR ] && {
  rm -rf $TARGET_DIR
}

git clone https://github.com/jewel/clearskies $TARGET_DIR
rm -rf $TARGET_DIR/.git

mkdir -p $TMPDIR/usr/bin
cp /vagrant/clearskies.bin $TMPDIR/usr/bin/clearskies
chmod +x $TMPDIR/usr/bin/clearskies

#
# Package it using fpm: https://github.com/jordansissel/fpm
# Creates a fat binary package
#
sudo gem install --no-ri --no-rdoc fpm
fpm --after-install /vagrant/post-install.sh --iteration $DEBIAN_REVISION \
    -d ruby1.9.1 \
    -d ruby-rb-inotify \
    -d ruby-ffi \
    -s dir -t deb -n $PKG_NAME -a all \
    -C $TMPDIR \
    --version $VERSION .
cp *.deb /vagrant/$PKG_NAME/wheezy/
rm *.deb
