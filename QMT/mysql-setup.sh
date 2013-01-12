#!/bin/sh
# 
# Setup mysql for qmailtoaster
#
# Nick Hemmesch <nick@ndhsoft.com>
# September 26, 2005
#

# Set mysql password
MYSQLPW=QMTPASS
 

# Setup mysql for vpopmail
##########################

# Setup root account - if you have already set your root password
# comment this section

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
