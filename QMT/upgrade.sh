#!/bin/sh
# This script is Updated By Devendra Meena (devendra@akshbroadband.com)
#
# Jake Vickers <jake@qmailtoaster.com> April 30, 2010
# Changed script to use http://mirrors.qmailtoaster.net to download packages from
# and removed the "stabl"e dir modifier
#
# Last modified: May 26, 2006
#
# *******************USE AT YOUR OWN RISK************************
#
# The Orignal Script was written by Jake Vickers (jake@v2gnu.com).
# This script uses Erik Espinoza's current-download-script to obtain
# the newest packages and parts of the current-install-script written
# by Nick Hemmesch. It will backup your old control files, as well as
# your old spamassassin config files and also domainkeys and restore
# them after the upgrade. 
#
# I am not sure which files get replaced by the new installation,
# so I just backed up all that I thought were relevant
#
#    DISTRO
#
# Mandrake 10.0 Linux		mdk100
# Mandrake 10.1 Linux		mdk101
# Mandriva 2005 Linux		mdk102
# Mandriva 2006 Linux		mdk103
# Mandriva 2006 x86_64  	mdk10364
# Red Hat 9 Linux		rht90
# Fedora Core 1 Linux		fdr10
# Fedora Core 2 Linux		fdr20
# Fedora Core 3 Linux		fdr30
# Fedora Core 4 Linux		fdr40
# Fedora Core 4 x86_64 Linux	fdr4064
# Fedora Core 5 Linux		fdr50
# Fedora Core 5 x86_64 Linux	fdr5064
# CentOS 4.x Linux		cnt40
# CentOS 4.x x86_64 Linux	cnt4064
# openSuSE 10.0 Linux		sus100
# openSuSE 10.0 x86_64 Linux	sus10064
# openSuSE 10.1 Linux		sus101
# openSuSE 10.1 x86_64 Linux	sus10164
# Trustix 2.0 Linux		trx20

# Change The DISTRO variable with your Distro

DISTRO=cnt40
ARCH=i386
BDIR=redhat

##
# Make sure we're root
if [ "$UID" != "0" ]; then
    echo "Error: You must be root"
    exit 1
fi

mkdir /usr/src/qtms-upgrade
cd /usr/src/qtms-upgrade

echo "Getting newest packages....(This will take a while)"
## The next portion of the script is taken from Erik Espinoza's current-download-script.
QT_BRANCH=stable
QT_LIST="http://www.qmailtoaster.com/info/current.txt"
QT_PACKAGES=`wget -q -O - ${QT_LIST}`

# If list is unavailable, quit
if [ -z "${QT_PACKAGES}" ] ; then
   echo "Package List unavailable, please check your connection and try again"
   exit 1
fi

# If list is availalbe, start the download
for SRPMS in ${QT_PACKAGES} ; do
    echo "Downloading ${SRPMS}"
    wget http://mirrors.qmailtoaster.net/${SRPMS}
    echo ""
    sleep 4
done

## End Erik's script

echo
echo "Backing up control files and spamassassin configs...."
mkdir /usr/src/qtms-upgrade/backup-control
mkdir /usr/src/qtms-upgrade/backup-spam
mkdir /usr/src/qtms-upgrade/backup-squirrelmail
mkdir /usr/src/qtms-upgrade/backup-attach
mkdir /usr/src/qtms-upgrade/backup-other
cp -pR /var/qmail/control/* /usr/src/qtms-upgrade/backup-control/
cp -pR /etc/mail/spamassassin/* /usr/src/qtms-upgrade/backup-spam/
cp -pR /var/lib/squirrelmail/* /usr/src/qtms-upgrade/backup-squirrelmail/
cp -pR /var/spool/squirrelmail/* /usr/src/qtms-upgrade/backup-attach/
cp /etc/tcprules.d/tcp.smtp /usr/src/qtms-upgrade/backup-other/
echo
echo "Moving old install files left over from previous install...."
mkdir -p /usr/src/qtms-install/old
mv /usr/src/$BDIR/RPMS/$ARCH/*-toaster*.rpm /usr/src/qtms-install/old/
mv /usr/src/$BDIR/RPMS/noarch/*-toaster*.rpm /usr/src/qtms-install/old/
echo
echo "Stopping QMail and starting upgrade...."
qmailctl stop
qmailctl stat
sleep 5
rpm -q libdomainkeys > /dev/null && rpm -e --nodeps libdomainkeys && echo "REMOVED libdomainkeys"
rpm -q control-panel-toaster > /dev/null && rpm -e --nodeps control-panel-toaster && echo "REMOVED control-panel-toaster"
#rpm -q courier-imap-toaster > /dev/null && rpm -e --nodeps courier-imap-toaster && echo "REMOVED courier-imap-toaster"
rpm -q spamassassin-toaster > /dev/null && rpm -e --nodeps spamassassin-toaster && echo "REMOVED spamassassin-toaster"
#rpm -q clamav-toaster > /dev/null && rpm -e --nodeps clamav-toaster && echo "REMOVED calmav-toaster"
#rpm -q simscan-toaster > /dev/null && rpm -e --nodeps simscan-toaster && echo "REMOVED simscan-toaster"

# New Script Start From Here

VQAD=vqadmin-toaster-*.src.rpm
VPOP=vpopmail-toaster-*.src.rpm
UCSP=ucspi-tcp-toaster-*.src.rpm
SQML=squirrelmail-toaster-*.src.rpm
SPAM=spamassassin-toaster-*.src.rpm
SIMS=simscan-toaster-*.src.rpm
MRTG=qmailmrtg-toaster-*.src.rpm
MDRP=maildrop-toaster-*.src.rpm
ADMN=qmailadmin-toaster-*.src.rpm
QMLT=qmail-toaster-*.src.rpm
ISOQ=isoqlog-toaster-*.src.rpm
EZML=ezmlm-toaster-*.src.rpm
DAEM=daemontools-toaster-*.src.rpm
IMAP=courier-imap-toaster-*.src.rpm
AUTH=courier-authlib-toaster-*.src.rpm
CPNL=control-panel-toaster-*.src.rpm
CLAM=clamav-toaster-*.src.rpm
AUTO=autorespond-toaster-*.src.rpm
ZLIB=zlib-*.src.rpm
DKEY=libdomainkeys-toaster-*.src.rpm
RIPM=ripmime-toaster-*.src.rpm

##
# Ask to proceed or exit
inquire(){
    PROCEED="exit";
    echo -n "Shall we continue? (yes, skip, quit) [y]/s/q: "
    read REPLY
    if [ -z $REPLY ]; then REPLY="y"; fi
    if [ $REPLY = "y" ]; then
        PROCEED=y
    fi
    if [ $REPLY = "s" ]; then
        PROCEED=n
    fi
    if [ $PROCEED = "exit" ]; then
        echo "Exiting."
        exit 0
    fi
}

clear
echo ""
echo "Installing zlib . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild $ZLIB
  rpm -Uvh --replacefiles --replacepkgs /usr/src/$BDIR/RPMS/$ARCH/zlib*.rpm
fi

echo ""
echo "Installing daemontools-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $DAEM
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/daemontools-toaster*.rpm
fi

echo ""
echo "Installing ucspi-tcp-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $UCSP
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/ucspi-tcp-toaster*.rpm
fi

echo ""
echo "Installing vpopmail-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $VPOP
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/vpopmail-toaster*.rpm
fi
echo ""
echo "Installing libdomainkeys-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $DKEY
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/libdomainkeys-toaster*.rpm
fi

echo ""
echo "Installing qmail-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $QMLT
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/qmail-toaster*.rpm
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/qmail-pop3d*.rpm
fi

echo ""
echo "Installing courier-authlib-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $AUTH
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/courier-authlib-toaster*.rpm
fi

echo ""
echo "Installing courier-imap-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $IMAP
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/courier-imap-toaster*.rpm
fi

echo ""
echo "Installing autorespond-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $AUTO
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/autorespond-toaster*.rpm
fi

echo ""
echo "Installing control-panel-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $CPNL
  rpm -Uvh /usr/src/$BDIR/RPMS/noarch/control-panel-toaster*.rpm
fi

echo ""
echo "Installing ezmlm-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $EZML
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/ezmlm*.rpm
fi

echo ""
echo "Installing qmailadmin-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $ADMN
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/qmailadmin-toaster*.rpm
fi

echo ""
echo "Installing qmailmrtg-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $MRTG
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/qmailmrtg-toaster*.rpm
fi

echo ""
echo "Installing maildrop-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $MDRP
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/maildrop-toaster*.rpm
fi

echo ""
echo "Installing isoqlog-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $ISOQ
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/isoqlog-toaster*.rpm
fi

echo ""
echo "Installing vqadmin-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $VQAD
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/vqadmin-toaster*.rpm
fi

echo ""
echo "Installing squirrelmail-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $SQML
  rpm -Uvh /usr/src/$BDIR/RPMS/noarch/squirrelmail-toaster*.rpm
fi

echo ""
echo "Installing spamassassin-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $SPAM
  rpm -Uvh --nodeps /usr/src/$BDIR/RPMS/$ARCH/spamassassin-toaster*.rpm
fi

echo ""
echo "Installing clamav-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $CLAM
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/clamav-toaster*.rpm
fi

echo ""
echo "Installing ripmime-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $RIPM
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/ripmime-toaster*.rpm
fi

echo ""
echo "Installing simscan-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $SIMS
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/simscan-toaster*.rpm
fi

echo ""
echo "Do you want to clean /usr/src/$BDIR/RPMS/* ?"
inquire

if [ $PROCEED = "y" ]; then
  rm -f /usr/src/$BDIR/RPMS/$ARCH/*
  rm -f /usr/src/$BDIR/RPMS/noarch/*
fi

echo "Finished . . ."
echo
echo "Restoring old config files...."
cp -Rf /usr/src/qtms-upgrade/backup-control/* /var/qmail/control/
cp -Rf /usr/src/qtms-upgrade/backup-spam/* /etc/mail/spamassassin/
cp -f /usr/src/qtms-upgrade/backup-other/tcp.smtp /etc/tcprules.d/tcp.smtp.backup
cp -Rf /usr/src/qtms-upgrade/backup-squirrelmail/* /var/lib/squirrelmail/
cp -Rf /usr/src/qtms-upgrade/backup-attach/* /var/spool/squirrelmail/
echo
echo "Restarting QMail"
qmailctl stop
sleep 3
qmailctl cdb
qmailctl start
qmailctl reload
spamassassin -D --lint 2>&1 > /dev/null
echo "All Done :) "
