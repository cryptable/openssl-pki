@echo off
openssl ca -config .\openssl.cnf -create_serial -out .\demoCA\cacert.pem -keyfile .\demoCA\private\cakey.pem -selfsign -extensions v3_ca -in .\demoCA\careq.pem
openssl x509 -in .\demoCA\cacert.pem -inform PEM -out .\demoCA\cacert.crt -outform DER