# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get install -qy \
  libftdi1 \
  libftdipp-dev \
  libftdi-dev \
  libftdipp1 \
  nano \
  wget \
  build-dep lcdproc \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir /home/nobody
RUN cd /home/nobody
RUN wget http://sourceforge.net/projects/lcdproc/files/lcdproc/0.5.7/lcdproc-0.5.7.tar.gz
RUN tar xvfz lcdproc-0.5.7.tar.gz
RUN cd lcdproc-0.5.7
RUN ./configure --enable-drivers=all
RUN make
RUN cd shared
RUN cd ../server
RUN make
RUN make install
RUN cd ../clients
RUN make
RUN make install
RUN cd /home/nobody

RUN cp lcdproc-0.5.7/LCDd.conf /usr/local/etc/LCDd.conf
RUN cp lcdproc-0.5.7/clients/lcdproc/lcdproc.conf /usr/local/etc/lcdproc.conf

#Then edit the LCDd.conf file:
#nano /usr/local/etc/LCDd.conf
#In the LCDd.conf change driver location from generic to:
# Where can we find the driver modules ?
# IMPORTANT: Make sure to change this setting to reflect your
# specific setup! Otherwise LCDd won't be able to find
# the driver modules and will thus not be able to
# function properly.
# NOTE: Always place a slash as last character !
#DriverPath=/usr/local/lib/lcdproc/

#In the LCDd.conf change the following from curses to lis. If you have a different type of LCD you probably could just change to your LCD type listed below.
# The following drivers are supported:
# bayrad, CFontz, CFontz633, CFontzPacket, curses, CwLnx, ea65,
# EyeboxOne, g15, glcdlib, glk, hd44780, icp_a106, imon, imonlcd, IOWarrior,
# irman, joy, lb216, lcdm001, lcterm, lirc, lis, MD8800, ms6931, mtc_s16209x,
# MtxOrb, mx5000, NoritakeVFD, picolcd, pyramid, sed1330, sed1520, serialPOS,
# serialVFD, shuttleVFD, sli, stv5730, svga, t6963, text, tyan, ula200,
# xosd
# Driver=lis

#Now we are going to make LCDd and lcdproc start at boot:
RUN cd lcdproc-0.5.7
RUN cp scripts/init-LCDd.debian /etc/init.d/LCDd
RUN cp scripts/init-lcdproc.debian /etc/init.d/lcdproc
RUN chmod 755 /etc/init.d/LCDd
RUN chmod 755 /etc/init.d/lcdproc
RUN update-rc.d LCDd defaults
RUN update-rc.d lcdproc defaults

RUN bash -c 'export EDITOR=nano'
RUN bash -c 'export VISUAL=nano'
RUN bash -c 'export TERM=xterm'

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
