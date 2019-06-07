FROM tripleomaster/centos-binary-keystone:current-tripleo

COPY dtu.py /usr/local/bin/dtu
COPY waitfordb.py /usr/local/bin/waitfordb
RUN rm -rf /etc/httpd /etc/keystone
RUN ln -s /data/httpd /etc/httpd
RUN ln -s /data/keystone /etc/keystone
COPY config /config

CMD ["/bin/sh", "/config/startup.sh"]
