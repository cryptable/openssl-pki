#!/bin/bash

set -e

if [ $# -eq 0 ]; then
  echo "certp10 <ID> [user extensions section (usr_cert)]"
  echo "This creates a <ID>_cert.crt file."
  exit -1
fi

if [ -e ./demoCA/certs/$1.crt ]; then
  echo "Certificate already exists."
  exit -2
fi 

if [ $# -gt 1 ] && [ -n $2 ]; then
  USER_EXT="-extensions $2"
else
  USER_EXT=""  
fi

echo "--------------------"
echo "Convert P10 to PEM  "
echo "--------------------"
openssl req -in ./$1.p10 -inform DER -out ./$1.pem -outform PEM

echo "--------------------"
echo "Copy user csr       "
echo "--------------------"
cp $1.pem ./demoCA/req/$1_req.pem

echo "---------------------------"
echo "Generating user certificate"
echo "---------------------------"
openssl ca -config ./openssl.cnf -out ./demoCA/certs/$1_cert.pem -keyfile ./demoCA/private/cakey.pem $USER_EXT -in ./demoCA/req/$1_req.pem -batch
openssl x509 -in ./demoCA/certs/$1_cert.pem -inform PEM -out ./demoCA/certs/$1.crt -outform DER 
createchain.sh $1

exit 0