#!/usr/bin/env bash

#Based on article here: https://www.sitepoint.com/introduction-git-hooks/
#Create a hooks directory and a simple installer install-hooks.sh that links them (rather than copying):
#Anyone who clones your project can simply run bash install-hooks.sh after cloning.
#This is currently not working. Unable to find correct directory

for i in hooks/*; do ln -s "${i}" ".git/${i}"; done