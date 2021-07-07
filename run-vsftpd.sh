#!/bin/bash
#if [[ ! -z "$FTP_USER" ]]; then
#  FTP_USER="$FTP_USER"
#else
#  FTP_USER="root"
#fi
#
#if [[ ! -z "$FTP_PASS" ]]; then
#  FTP_PASS="$FTP_PASS"
#else
#  FTP_PASS="123"
#fi
if [[ "$FTP_GROUP" = "**String**" ]]; then
    FTP_GROUP="admin"
fi

if [[ "$FTP_USER" = "**String**" ]]; then
    FTP_USER="admin"
fi

if [[ "$FTP_PASS" = "**String**" ]]; then
    FTP_PASS="admin"
fi

FTP_FOLDER="/home/vsftpd/${FTP_USER}"

if ! id -u $FTP_USER >/dev/null 2>&1; then
  addgroup -g 1000 $FTP_GROUP
  adduser -u 1000 -G $FTP_GROUP -h $FTP_FOLDER -D $FTP_USER
  echo "user was created"
fi

#if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
#    export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
#fi
#
#if [[ "$LOG_STDOUT" = "**Boolean**" ]]; then
#    export LOG_STDOUT=''
#else
#    export LOG_STDOUT='Yes.'
#fi

mkdir -p "/home/vsftpd/${FTP_USER}"
chown -R $FTP_USER:$FTP_GROUP /home/vsftpd/

#echo -e "${FTP_USER}\n${FTP_PASS}" > /etc/vsftpd/virtual_users.txt
#/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

# Set passive mode parameters:
#if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
#    export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
#fi

echo "listen=${LISTEN}" >> /etc/vsftpd/vsftpd.conf

# Get log file path
#export LOG_FILE=`grep xferlog_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`

# stdout server info:
#if [ ! $LOG_STDOUT ]; then
cat << EOB
*************************************************
*                                               *
*                                               *
*************************************************
SERVER SETTINGS
---------------
· FTP User: $FTP_USER
· FTP Password: $FTP_PASS
· Log file: $LOG_FILE
· Redirect vsftpd log to STDOUT: No.
EOB
#else
#    /bin/ln -sf /dev/stdout $LOG_FILE
#fi

# Run vsftpd:
if [ -z $1 ]; then
  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
  echo 'running'
else
  $@
fi
