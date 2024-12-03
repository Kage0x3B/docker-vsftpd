FROM alpine:3.14

LABEL Maintainer="Moritz Hein <moritz.hein@live.de>"
LABEL Description="vsftpd Docker image based on Alpine Linux 3.14. Supports passive mode." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd fauria/vsftpd" \
	Version="1.0"

RUN apk add --no-cache vsftpd

ENV LIBPAM_PWDFILE_VERSION=1.0

ENV FTP_USER=**String**
ENV FTP_PASS=**Random**
ENV PASV_ADDRESS=**IPv4**
ENV PASV_ADDR_RESOLVE=NO
ENV PASV_ENABLE=YES
ENV PASV_MIN_PORT=21100
ENV PASV_MAX_PORT=21110
ENV XFERLOG_STD_FORMAT=YES
ENV LOG_STDOUT=**Boolean**
ENV FILE_OPEN_MODE=0666
ENV LOCAL_UMASK=077
ENV REVERSE_LOOKUP_ENABLE=YES
ENV PASV_PROMISCUOUS=NO
ENV PORT_PROMISCUOUS=NO

COPY vsftpd.conf /etc/vsftpd/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/vsftpd

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
