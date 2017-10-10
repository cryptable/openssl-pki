#!/bin/bash

set -e

# Retrieve the openss configuration directory
OPENSSL_DIR=$(openssl version -d | sed "s/OPENSSLDIR: //" | sed  "s/\"//g")

#PARAMETER parsing
if [ "$1" = "config" ]; then
  CHANGE_CNF="true"
else
  CHANGE_CNF="false"
fi

if [ "$1" = "customconfig" ]; then
  CUSTOM_CNF="true"
else
  CUSTOM_CNF="false"
fi

if [ -d ./demoCA ]; then
  rm -rf ./demoCA
fi 

mkdir -p ./demoCA/private
mkdir -p ./demoCA/certs
mkdir -p ./demoCA/newcerts
mkdir -p ./demoCA/crl
mkdir -p ./demoCA/req
mkdir -p ./demoCA/p12
mkdir -p ./demoCA/plain
mkdir -p ./demoCA/cipher
mkdir -p ./demoCA/verify
mkdir -p ./demoCA/temp

if [ $CHANGE_CNF = "false" ]; then
  cp $OPENSSL_DIR/openssl.cnf ./openssl.cnf
fi

if [ $CHANGE_CNF = "true" ]; then
  vi ./openssl.cnf
fi

touch ./demoCA/index.txt
echo 01 > ./demoCA/crlnumber
echo 00000001 > ./demoCA/serial
openssl req -config ./openssl.cnf -new -keyout ./demoCA/private/cakey.pem -out ./demoCA/careq.pem

exit 0