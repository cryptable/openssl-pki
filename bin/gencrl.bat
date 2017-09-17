@echo off
if "%1" == "" goto CREATE_CRL
if exist .\demoCA\certs\%1_cert.pem goto REVOKE_CERT

:REVOKE_CERT
openssl ca -revoke .\demoCA\certs\%1_cert.pem -keyfile .\demoCA\private\cakey.pem -cert .\demoCA\cacert.pem

:CREATE_CRL
openssl ca -gencrl -keyfile .\demoCA\private\cakey.pem -cert .\demoCA\cacert.pem  -out .\demoCA\crl\current_crl.pem
openssl crl -in .\demoCA\crl\current_crl.pem -outform DER -out .\demoCA\crl\current.crl
goto END

:END
