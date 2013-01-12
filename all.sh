#!/bin/bash

#referencia: http://www.howtoforge.com/how-to-install-qmailtoaster-centos-5.3
#referencia: http://www.google.com/support/a/bin/answer.py?answer=60730
#referencia: http://www.qmailwiki.org/index.php/Simscan/README

# Make sure we're root
if [ "$UID" != "0" ]; then
    echo "Error: You must be root"
    exit 1
fi

echo "Update system"
yum check-update
yum update -y

echo "Install name server cache"
yum -y install caching-nameserver
service named start
chkconfig named on
service named status

echo "nameserver 127.0.0.1" > /etc/resolv.conf

#ToDo
#echo "Desabilitando o SELINUX"

echo "The first script we want to grab is going to be the script that fills the dependencies."
sh QMT/cnt50-deps.sh

echo " we need to fill some perl dependencies for Spamassassin"
sh QMT/cnt50-perl.sh

echo "The script will turn some services on and off for you, as well as set up the database needed for Vpopmail"
#ToDo -> Change MySQL password
sh QMT/cnt50-svcs.sh

echo "Download the Qmailtoaster packages"
sh QMT/current-download-script.sh

echo "Install Qmailtoaster"
rpmbuild --rebuild --with cnt50 daemontools-toaster-*
rpm -Uvh /usr/src/redhat/RPMS/i386/daemontools-toaster-*

echo "Install Qmailtoaster"
sh QMT/cnt50-install-script.sh

echo "Compilando Simscam"
cd simscan-1.4.0
./configure --enable-spam=y --enable-user=clamav --enable-attach=y --enable-spam-passthru=n --enable-custom-smtp-reject=y
make
make install

echo "Desabilitando o imap"
#touch /var/qmail/supervise/imap4-ssl/down 
#touch /var/qmail/supervise/imap4/down 

echo "Desabilitando o pop3"
#touch /var/qmail/supervise/pop3/down 
#touch /var/qmail/supervise/pop3-ssl/down 


#echo '127.:allow,RELAYCLIENT="",DKSIGN="/var/qmail/control/domainkeys/%/private",QMAILQUEUE="/var/qmail/bin/simscan"' > /etc/tcprules.d/tcp.smtp

#echo ':allow,BADMIMETYPE="",BADLOADERTYPE="M",CHKUSER_RCPTLIMIT="15",CHKUSER_WRONGRCPTLIMIT="3",DKVERIFY="DEGIJKfh",QMAILQUEUE="/var/qmail/bin/simscan",DKQUEUE="/var/qmail/bin/qmail-queue.orig",DKSIGN="/var/qmail/control/domainkeys/%/private"' >> /etc/tcprules.d/tcp.smtp

service qmail stop
qmailctl cdb

PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Mail::SpamAssassin'
sa-update --nogpg
service qmail start

cp -rf bin/qmHandle /bin/

sh awstat/awstat-install.sh



