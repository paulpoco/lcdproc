#!/bin/bash

# exit script if return code != 0
set -e

# define pacman packages
pacman_packages="libftdi-compat perl"

pacman-mirrors -g && pacman -Syyuu && pacman -Suu

# install pre-reqs
pacman -S --needed $pacman_packages --noconfirm

# call aor script (arch official repo)
source /root/aor.sh

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /tmp/*
