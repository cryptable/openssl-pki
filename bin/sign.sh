#/bin/bash

openssl smime -sign -binary -signer certs/$1_cert.pem -inkey private/$1_key.pem -in plain/$1 -out cipher/$1.p7s -outform DER