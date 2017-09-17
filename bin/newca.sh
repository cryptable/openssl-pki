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

cp $OPENSSL_DIR/openssl.cnf ./openssl.cnf

echo $CHANGE_CNF
if [ $CHANGE_CNF = "true" ]; then
 vi ./openssl.cnf
fi

touch ./demoCA/index.txt
echo 01 > ./demoCA/crlnumber
openssl req -config ./openssl.cnf -new -keyout ./demoCA/private/cakey.pem -out ./demoCA/careq.pem
openssl ca -config ./openssl.cnf -create_serial -out ./demoCA/cacert.pem -keyfile ./demoCA/private/cakey.pem -selfsign -extensions v3_ca -in ./demoCA/careq.pem
openssl x509 -in ./demoCA/cacert.pem -inform PEM -out ./demoCA/cacert.crt -outform DER
openssl x509 -in ./demoCA/cacert.pem -inform PEM -out ./demoCA/cachain.pem

exit 0