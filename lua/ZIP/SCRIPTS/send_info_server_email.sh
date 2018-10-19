#!/bin/bash

FROM=""
MAILTO="" # можно через запятую несколько
SUB="System information VPS servers of AC"

DF=$(df -hT)
FREE=$(free)
IOSTAT=$(iostat)
PS=$(ps ax | grep linux_64_server)

BODY="\nDF\n\n$DF\n\nFREE\n\n$FREE\n\nIOSTAT\n\n$IOSTAT\n\nAC\n\n$PS\n"

SMTPSERVER="smtp.gmail.com:25"
SMTPLOGIN=""
SMTPPASS=""

sendEmail -f $FROM -t $MAILTO -o message-charset=utf-8  -u $SUB  -q -m "$BODY" -s $SMTPSERVER -o tls=yes -xu $SMTPLOGIN -xp $SMTPPASS  > /dev/null
# > /dev/null &
