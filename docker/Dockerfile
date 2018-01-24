FROM zultron/docker-dev:latest

# Install recent nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y \
        nodejs && \
    apt-get clean

# Install machinekit 
RUN apt-get update \
    && apt-get install -y \
        machinekit-posix \
	avahi-daemon \
	rsyslog \
    && apt-get clean

# Zeroconf, httpd, RRD, python YAML
RUN apt-get install -y \
	avahi-utils \
	python-yaml \
	python-rrdtool \
	apache2 \
    && apt-get clean

# For appimage
RUN apt-get install -y \
	fuse \
    && apt-get clean

# Download MachinekitClient
RUN bash -c ' \
        list_url=https://dl.bintray.com/machinekoder/MachinekitClient-Development && \
        package=$(wget -qO- ${list_url}/ | grep -e "-master-.*x64.AppImage" \
            | tail -n 1 | awk -F \" "{print \$4}") && \
        url=${list_url}/${package:1} && \
	echo "$url" && \
        wget -O /usr/bin/MachinekitClient $url && \
        chmod +x /usr/bin/MachinekitClient'

# Add MK INI file with remote enabled
ADD machinekit.ini /etc/linuxcnc/machinekit.ini

# Fix avahi execution https://github.com/lxc/lxc/issues/25
RUN sudo sed -i /etc/avahi/avahi-daemon.conf -e '/rlimit-nproc/ s/^/#/'

# Tell Goldibox this is a sim environment
ENV GOLDIBOX_SIM=true
