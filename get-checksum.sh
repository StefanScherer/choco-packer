#!/bin/bash
echo 32bit
curl https://releases.hashicorp.com/packer/$1/packer_$1_windows_386.zip | shasum -a 1 -
echo 64bit
curl https://releases.hashicorp.com/packer/$1/otto_$1_windows_amd64.zip | shasum -a 1 -
