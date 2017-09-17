#!/bin/bash
set -e

if [ $# -eq 1 ]; then
  if  [ -e ./demoCA/certs/$1_cert.pem ]; then
    openssl ca -config ./openssl.cnf -revoke ./demoCA/certs/$1_cert.pem -keyfile ./demoCA/private/cakey.pem -cert ./demoCA/cacert.pem
  else
    echo "Unknown certificate ID"
    echo "Usage: gencrl [<ID>]"
    exit -1
  fi
fi

openssl ca -config ./openssl.cnf -gencrl -keyfile ./demoCA/private/cakey.pem -cert ./demoCA/cacert.pem  -out ./demoCA/crl/current_crl.pem
openssl crl -in ./demoCA/crl/current_crl.pem -outform DER -out ./demoCA/crl/current.crl

exit 0