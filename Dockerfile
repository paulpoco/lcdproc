# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get install -qy libftdi1 libftdipp-dev libftdi-dev libftdipp1 nano wget
RUN apt-get -qy build-dep lcdproc

RUN cd /home \
  mkdir nobody \
  cd nobody \
  wget http://sourceforge.net/projects/lcdproc/files/lcdproc/0.5.7/lcdproc-0.5.7.tar.gz \
  tar xvfz lcdproc-0.5.7.tar.gz \
  cd lcdproc-0.5.7 \
  ./configure --enable-drivers=all \
  make \
  cd shared \
  cd ../server \
  make \
  make install \
  cd ../clients \
  make \
  make install \
  cd /home/nobody \
  cp lcdproc-0.5.7/LCDd.conf /usr/local/etc/LCDd.conf \
  cp lcdproc-0.5.7/clients/lcdproc/lcdproc.conf /usr/local/etc/lcdproc.conf \
  cd lcdproc-0.5.7 \
  cp scripts/init-LCDd.debian /etc/init.d/LCDd \
  cp scripts/init-lcdproc.debian /etc/init.d/lcdproc \
  chmod 755 /etc/init.d/LCDd \
  chmod 755 /etc/init.d/lcdproc \
  update-rc.d LCDd defaults \
  update-rc.d lcdproc defaults \
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
