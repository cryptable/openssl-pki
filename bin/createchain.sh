#!/bin/bash

set -e

if [ $# -eq 0 ]; then
  echo "Usage:"
  echo "createchain <ID>"
  echo "This creates a chain from <ID>_cert.pem to <ID>_chain.pem and <ID>_chain.p7c file."
  exit -1
fi

echo "--------------------"
echo "Create PEM chain    "
echo "--------------------"
openssl x509 -in ./demoCA/certs/$1_cert.pem -inform PEM -out ./demoCA/certs/$1_chain.pem
cat ./demoCA/cachain.pem >> ./demoCA/certs/$1_chain.pem

echo "---------------------------"
echo "Create PKCS#7 Chain        "
echo "---------------------------"
openssl crl2pkcs7 -nocrl -certfile ./demoCA/certs/$1_chain.pem -out ./demoCA/certs/$1_chain.p7c -outform DER

exit 0