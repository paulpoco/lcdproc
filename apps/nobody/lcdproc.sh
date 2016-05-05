#!/bin/bash

# if config file doesnt exist then copy stock config file
if [[ ! -f /config/LCDd.conf ]]; then
	cp /home/nobody/lcdproc/LCDd.conf /config/
fi

# if config file doesnt exist then copy stock config file
if [[ ! -f /config/lcdexec.conf ]]; then
	cp /home/nobody/lcdproc/lcdexec.conf /config/
fi

# if config file doesnt exist then copy stock config file
if [[ ! -f /config/lcdproc.conf ]]; then
	cp /home/nobody/lcdproc/lcdproc.conf /config/
fi

# if config file doesnt exist then copy stock config file
if [[ ! -f /config/lcdvc.conf ]]; then
	cp /home/nobody/lcdproc/lcdvc.conf /config/
fi

