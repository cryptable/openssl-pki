#!/bin/bash
set -e

if [ $# -eq 0 ]; then
  echo "gencert <ID> [user extensions section (usr_cert)"
  echo "This creates a <ID>.p12 file."
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

VERBOSE="-verbose"

echo "--------------------"
echo "Generating user keys"
echo "--------------------"
openssl req $verbose -multivalue-rdn -config ./openssl.cnf -new -keyout ./demoCA/private/$1_key.pem -out ./demoCA/req/$1_req.pem

echo "---------------------------"
echo "Generating user certificate"
echo "---------------------------"
openssl ca $VERBOSE -multivalue-rdn -config ./openssl.cnf -out ./demoCA/certs/$1_cert.pem -keyfile ./demoCA/private/cakey.pem $USER_EXT -in ./demoCA/req/$1_req.pem
openssl x509 -in ./demoCA/certs/$1_cert.pem -inform PEM -out ./demoCA/certs/$1.crt -outform DER
createchain.sh $1

echo "-------------------"
echo "Generating P12 file"
echo "-------------------"
openssl pkcs12 -export -inkey ./demoCA/private/$1_key.pem -in ./demoCA/certs/$1_cert.pem -chain -CAfile ./demoCA/cachain.pem -out ./demoCA/p12/$1.p12 -name $1

exit 0