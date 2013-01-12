#!/bin/sh
#
# Install QmailToaster packages on CentOS 5
#
# *** USE AT YOUR OWN RISK ***
#
# do: rpm -qa | grep toaster | sort to be sure that all
# the packages installed correctly . . .
#
# Nick Hemmesch <nick@ndhsoft.com>
# May 5, 2005
#
# Updated wildcards by Erik Espinoza
# July 28, 2005
#
# Updated for new toaster packages by Nick Hemmesch
# April 14, 2007
#

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
SRS2=libsrs2-toaster-*.src.rpm
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
#    PROCEED="exit";
#    echo -n "Shall we continue? (yes, skip, quit) [y]/s/q: "
#    read REPLY
#    if [ -z $REPLY ]; then REPLY="y"; fi
#    if [ $REPLY = "y" ]; then
	PROCEED=y
#    fi
#    if [ $REPLY = "s" ]; then
#	PROCEED=n
#    fi
#    if [ $PROCEED = "exit" ]; then
#	echo "Exiting."
#	exit 0
#    fi
}

##
# Make sure we're root
if [ "$UID" != "0" ]; then
    echo "Error: You must be root"
    exit 1
fi

DISTRO=cnt50
ARCH=i386
BDIR=redhat


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
echo "Installing libsrs2-toaster . . ."
inquire
clear

if [ $PROCEED = "y" ]; then
  rpmbuild --rebuild --with $DISTRO $SRS2
  rpm -Uvh /usr/src/$BDIR/RPMS/$ARCH/libsrs2-toaster*.rpm
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

exit 0
