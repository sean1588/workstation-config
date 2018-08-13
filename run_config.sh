#!/bin/bash

echo "install homebrew and  ansible"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew upgrade python || brew install python
brew unlink python && brew link python --overwrite
/usr/local/bin/pip3 install --upgrade pip setuptools wheel
/usr/local/bin/pip3 install --upgrade --install-option="--prefix=/usr/local" ansible


ansible-playbook -i localhost.ini -K workstation_config.yaml
