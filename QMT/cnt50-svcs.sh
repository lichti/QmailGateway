#!/bin/sh
# CentOS 5 services
#
# Stops unnecessary services and starts necessary services
# Configures php.ini and inittab
# Makes symlink for krb5 com_err.h
#
# Nick Hemmesch <nick@ndhsoft.com>
# April 14, 2007
#

# Set mysql password
MYSQLPW=QMTPASS
 
chkconfig httpd on
service httpd start

chkconfig mysqld on
service mysqld start

chkconfig ntpd on
service ntpd start


# Setup mysql for vpopmail
##########################

# Setup root account

mysqladmin -uroot password $MYSQLPW
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh

# Create vpopmaildatabase with correct permissions

mysqladmin create vpopmail -uroot -p$MYSQLPW
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh

echo "GRANT ALL PRIVILEGES ON vpopmail.* TO vpopmail@localhost IDENTIFIED BY 'SsEeCcRrEeTt'" | mysql -uroot -p$MYSQLPW
mysqladmin -uroot -p$MYSQLPW reload
mysqladmin -uroot -p$MYSQLPW refresh


# Set to boot to runlevel 3

cp -u /etc/inittab /etc/inittab.bak
cat /etc/inittab | sed -e 's/^id:5:initdefault:/id:3:initdefault:/' > /etc/inittab.new
mv -f /etc/inittab.new /etc/inittab


# Make krb5 symlink

ln -s /usr/include/et/com_err.h /usr/include/com_err.h


# Setup for firewall

#sh firewall.sh
