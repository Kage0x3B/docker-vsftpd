#!/bin/sh

# If no env var for FTP_USER has been specified, use 'admin':
if [ "$FTP_USER" = "**String**" ]; then
    export FTP_USER='admin'
fi

# If no env var has been specified, generate a random password for FTP_USER:
if [ "$FTP_PASS" = "**Random**" ]; then
    export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
fi

# Log to STDOUT by default:
if [ "$LOG_STDOUT" = "**Boolean**" ]; then
    export LOG_STDOUT='Yes.'
else
    export LOG_STDOUT='Yes.'
fi

# Create home dir and update vsftpd user db:
mkdir -p "/home/vsftpd/${FTP_USER}"
adduser -D -g ${FTP_USER} ${FTP_USER}
chown -R ${FTP_USER}:${FTP_USER} /home/vsftpd/${FTP_USER}
echo -e "$FTP_PASS\n$FTP_PASS" | passwd ${FTP_USER} >/dev/null 2>&1

# Set passive mode parameters:
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
    export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
fi

echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_enable=${PASV_ENABLE}" >> /etc/vsftpd/vsftpd.conf
echo "file_open_mode=${FILE_OPEN_MODE}" >> /etc/vsftpd/vsftpd.conf
echo "local_umask=${LOCAL_UMASK}" >> /etc/vsftpd/vsftpd.conf
echo "xferlog_std_format=${XFERLOG_STD_FORMAT}" >> /etc/vsftpd/vsftpd.conf
# echo "reverse_lookup_enable=${REVERSE_LOOKUP_ENABLE}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_promiscuous=${PASV_PROMISCUOUS}" >> /etc/vsftpd/vsftpd.conf
echo "port_promiscuous=${PORT_PROMISCUOUS}" >> /etc/vsftpd/vsftpd.conf

cat << EOB
	*************************************************
	*                                               *
	*    Docker image: kage0x3b/vsftpd              *
	*    https://github.com/kage0x3b/docker-vsftpd  *
	*                                               *
	*************************************************

	SERVER SETTINGS
	---------------
	· FTP User: $FTP_USER
	· FTP Password: $FTP_PASS
EOB

# Run vsftpd:
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
