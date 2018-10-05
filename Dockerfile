FROM centos:7

ENV container docker

MAINTAINER Pigo Chu <pigochu@gmail.com>


# Install packages
RUN yum install -y epel-release && \
	yum upgrade -y && \
	yum install -y gettext python-setuptools && \
	yum clean all;\
	rm -rf /var/cache/yum && \
	rm -f /var/log/yum.log && \
	easy_install supervisor && \
	mkdir /etc/supervisord.d; \
	mkdir /var/log/supervisor; \
	mkdir /var/run/supervisor; \
	mkdir /docker-settings; \
	mkdir -p /opt/c7supervisor/bin; \
	mkdir -p /opt/c7supervisor/etc/init.d

# build-files
COPY --chown=root:root build-files /

# Permission
RUN	chmod 755 /etc;\
	chmod 700 -Rf /opt/c7supervisor;\
	chmod 600 /etc/supervisord.conf;\
	ln -s /opt/c7supervisor/bin/docker-replacefiles.sh /usr/local/bin/docker-replacefiles

# VOLUME
VOLUME ["/docker-settings"]

# entrypoint
ENTRYPOINT [ "/opt/c7supervisor/bin/entrypoint.sh" ]
CMD ["supervisord", "-n" , "-c" , "/etc/supervisord.conf"]