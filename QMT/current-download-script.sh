#!/bin/sh
#
# Download current qmailtoaster packages
# Query Server for current list

# Jake Vickers <jake@qmailtoaster.com>
# April 29, 2010
# Changed script around to download from mirrors instead of main site

# Arne Blankerts <arne@thephp.cc>
# April 17, 2010
# Added a check to avoid double downloads

# Jake Vickers <jake@qmailtoaster.com>
# Feb 3, 2009
# Edited the script to reflect different download paths now that I have taken project over.

#
# Erik A. Espinoza <espinoza@forcenetworks.com>
# July 22, 2005
# List queried from server
#

#QT_BRANCH=stable # No longer needed
QT_LIST="http://www.qmailtoaster.com/info/current.txt"
QT_PACKAGES=`wget -q -O - ${QT_LIST}`

# If list is unavailable, quit
if [ -z "${QT_PACKAGES}" ] ; then
   echo "Package List unavailable, please check your connection and try again"
   exit 1
fi

# If list is availalbe, start the download
for SRPMS in ${QT_PACKAGES} ; do
    if [ -f $SRPMS ]; then
      echo "${SRPMS} found - skipping"
    else
      echo "Downloading ${SRPMS}"
      wget http://mirrors.qmailtoaster.net/${SRPMS}
      echo ""
      sleep 4
    fi
done

exit 0

