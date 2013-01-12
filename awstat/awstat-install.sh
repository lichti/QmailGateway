#!/bin/bash

#wget http://prdownloads.sourceforge.net/awstats/awstats-6.7-1.noarch.rpm
#rpm -ivh --force awstats-6.7-1.noarch.rpm

rpm -Uhv http://prdownloads.sourceforge.net/awstats/awstats-6.7-1.noarch.rpm

cat <<EOF > /etc/httpd/conf/awstats.conf
Alias /classes "/usr/local/awstats/wwwroot/classes/"
Alias /css "/usr/local/awstats/wwwroot/css/"
Alias /icon "/usr/local/awstats/wwwroot/icon/"
ScriptAlias /awstats/ "/usr/local/awstats/wwwroot/cgi-bin/"

<Directory "/usr/local/awstats/wwwroot">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
EOF

cat <<EOF >>/etc/httpd/conf/httpd.conf
Include /etc/httpd/conf/awstats.conf
EOF

cat <<EOF > /etc/awstats/awstats.mail.conf 
LogFile="cat /var/log/qmail/send/current | tai64nlocal | /usr/local/awstats/tools/maillogconvert.pl standard |"
#LogFile="cat /var/log/qmail/send/*.s | tai64nlocal | /usr/local/awstats/tools/maillogconvert.pl standard |"
SiteDomain="$(hostname --fqdn)"
LogType=M 
LogFormat="%time2 %email %email_r %host %host_r %method %url %code %bytesd" 
LevelForBrowsersDetection=0 
LevelForOSDetection=0 
LevelForRefererAnalyze=0 
LevelForRobotsDetection=0 
LevelForWormsDetection=0 
LevelForSearchEnginesDetection=0 
LevelForFileTypesDetection=0 
ShowMenu=1 
ShowSummary=HB 
ShowMonthStats=HB 
ShowDaysOfMonthStats=HB 
ShowDaysOfWeekStats=HB 
ShowHoursStats=HB 
ShowDomainsStats=0 
ShowHostsStats=HBL 
ShowAuthenticatedUsers=0 
ShowRobotsStats=0 
ShowEMailSenders=HBML 
ShowEMailReceivers=HBML 
ShowSessionsStats=0 
ShowPagesStats=0 
ShowFileTypesStats=0 
ShowFileSizesStats=0 
ShowBrowsersStats=0 
ShowOSStats=0 
ShowOriginStats=0 
ShowKeyphrasesStats=0 
ShowKeywordsStats=0 
ShowMiscStats=0 
ShowHTTPErrorsStats=0 
ShowSMTPErrorsStats=1
EOF

cat <<EOF >>/etc/crontab
*/5 * * * * root /usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config=mail 2>&1 > /dev/null
EOF


service httpd restart

