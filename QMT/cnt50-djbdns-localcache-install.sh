#!/bin/sh
#
# This is just a test djbdns-localcache install script
# for CentOS 4 x86_64 Linux with QmailToaster installed
#
# Nick Hemmesch <nick@ndhsoft.com>
# Jun 9, 2006
#

DISTRO=cnt50
ARCH=i386
BDIR=usr/src/redhat

defaultHostname=`hostname -f | perl -ne "s/.*\.([a-z0-9-]+\.[a-z]+)$/\1/i;" -e "print lc"`

echo ""
echo "**** Removing bind, bind-chroot and caching-nameserver ****"
echo ""
rpm -q bind > /dev/null && rpm -e --nodeps bind && echo "**** REMOVED - bind ****"
rpm -q bind-chroot > /dev/null && rpm -e --nodeps bind-chroot && echo "**** REMOVED - bind-chroot ****"
rpm -q caching-nameserver > /dev/null && rpm -e --nodeps caching-nameserver && echo "**** REMOVED - caching-nameserver ****"
echo ""
sleep 3
echo "**** Building djbdns packages ****"
echo ""
rpmbuild --rebuild --with $DISTRO djbdns*.src.rpm && echo "build djbdns packages - Done . . ."
echo ""
sleep 3
echo "**** Installing djbdns-localcache ****"
rpm -Uvh /$BDIR/RPMS/$ARCH/djbdns-local*.rpm && echo "install djbdns-localcache - Done . . ."
echo ""
sleep 3
echo "**** Making a backup of resolv.conf ****"
mv -f /etc/resolv.conf /etc/resolv.conf.orig && echo "backup /etc/resolv.conf - Done . . ."
echo ""
sleep 3
echo "**** Configuring a new resolv.conf ****"
echo "search $defaultHostname" > /etc/resolv.conf && echo "new resolv.conf - search $defaultHostname Done . . ."
echo "nameserver 127.0.0.1" >> /etc/resolv.conf && echo "new resolv.conf - nameserver 127.0.0.1 Done . . ."
echo ""
echo "**** Starting djbdns local caching nameserver ****"
service djbdns start && echo "Done . . ."
sleep 3
echo "**** Finished ****"
echo ""
