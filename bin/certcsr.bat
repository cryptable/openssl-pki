@echo off
if "%1"=="" goto USAGE
if exist .\demoCA\certs\%1_cert.pem goto USER_EXISTS
rem * Config file checking
if not "%2"=="" (
set USER_EXT="-extensions %2" 
) else (
set USER_EXT=
)

echo "--------------------"
echo "Copy user csr       "
echo "--------------------"
copy %1.pem .\demoCA\req\%1_req.pem
echo "---------------------------"
echo "Generating user certificate"
echo "---------------------------"
openssl ca -config .\openssl.cnf -out .\demoCA\certs\%1_cert.pem -keyfile .\demoCA\private\cakey.pem %USER_EXT% -in .\demoCA\req\%1_req.pem -batch
openssl x509 -in .\demoCA\certs\%1_cert.pem -inform PEM -out .\demoCA\certs\%1.crt -outform DER
call createchain.bat %1

goto END

:USAGE
echo "Usage:"
echo "certcsr <ID> [user extensions section (usr_cert)]"
echo "This creates a <ID>_cert.crt file."
goto END

:USER_EXISTS
echo "Certificate already exists"
goto END

:USAGE

:END
