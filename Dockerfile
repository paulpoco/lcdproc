# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get install -qy libftdi1 libftdipp-dev libftdi-dev libftdipp1 lcdproc nano wget

COPY LCDd.conf /etc/LCDd.conf
COPY lcdproc /etc/init.d/lcdproc
RUN chmod 755 /etc/init.d/LCDd
RUN chmod 755 /etc/init.d/lcdproc
RUN update-rc.d LCDd defaults
RUN update-rc.d lcdproc defaults

RUN bash -c 'export EDITOR=nano'
RUN bash -c 'export VISUAL=nano'
RUN bash -c 'export TERM=xterm'

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
