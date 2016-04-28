FROM gliderlabs/alpine:3.3
MAINTAINER paulpoco

# additional files
##################

RUN apk --update add libftdi1 libftdipp-dev libftdi-dev libftdipp1 wget tar bash nano
RUN apk --update add --virtual build-dependencies lcdproc \
  && wget http://sourceforge.net/projects/lcdproc/files/lcdproc/0.5.7lcdproc-0.5.7.tar.gz \
  && tar xvfz lcdproc-0.5.7.tar.gz \
  && cd lcdproc-0.5.7 \
  && ./configure --enable-drivers=all \
  && make \
  && cd shared \
  && make \
  && cd ../server \
  && make \
  && sudo make install \
  && cd ../clients \
  && make \
  && sudo make install
  && cd ~/ \
  && apk del build-dependencies
