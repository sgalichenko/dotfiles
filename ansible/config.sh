#!/bin/sh

yes | pacman -Syu
yes | pacman -Sy git
yes | pacman -Sy ansible
git clone https://github.com/sgalichenko/dotfiles.git /tmp/dotfiles
ansible-playbook /tmp/dotfiles/ansible/configure.yml && rm -R /tmp/dotfiles
