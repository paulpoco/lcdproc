# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get install -qy libftdi1 libftdipp-dev libftdi-dev libftdipp1 nano wget usbutils
RUN apt-get -qy build-dep lcdproc

# map /home/nobody
VOLUME /home/nobody

COPY lcdproc-0.5.7.tar.gz /home/nobody
WORKDIR /home/nobody
RUN tar xvfz lcdproc-0.5.7.tar.gz
WORKDIR /home/nobody/lcdproc-0.5.7
RUN ./configure --enable-drivers=all \
  make
WORKDIR /home/nobody/lcdproc-0.5.7/shared
RUN make
WORKDIR /home/nobody/lcdproc-0.5.7/server
RUN make \
  make install
WORKDIR /home/nobody/lcdproc-0.5.7/clients
RUN make \
  make install
WORKDIR /home/nobody
RUN cp lcdproc-0.5.7/LCDd.conf /usr/local/etc/LCDd.conf \
  cp lcdproc-0.5.7/clients/lcdproc/lcdproc.conf /usr/local/etc/lcdproc.conf
WORKDIR /home/nobody/lcdproc-0.5.7
RUN cp scripts/init-LCDd.debian /etc/init.d/LCDd \
  cp scripts/init-lcdproc.debian /etc/init.d/lcdproc \
  chmod 755 /etc/init.d/LCDd \
  chmod 755 /etc/init.d/lcdproc \
  update-rc.d LCDd defaults \
  update-rc.d lcdproc defaults \

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
