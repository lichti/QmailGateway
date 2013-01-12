#!/bin/sh
#
# Install common perl modules used by
# spamassassin-toaster
#
# Nick Hemmesch <nick@ndhsoft.com>
# <http://www.qmailtoaster.com>
# April 14, 2007

#
perl -MCPAN -e 'install'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install MIME::Base64'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install DB_File'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Net::DNS'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Net::SMTP'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Mail::SPF::Query'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Time::HiRes'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Mail::DomainKeys'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install IO::Zlib'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Archive::Tar'

PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install NetAddr::IP' 
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Mail::DKIM' 
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install IP::Country'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Net::Ident'
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install IO::Socket::SSL'

