if "%1"=="" goto USAGE
if exist .\demoCA\certs\%1_cert.pem goto USER_EXISTS
rem * Config file checking
if not "%2"=="" (
set USER_EXT="-extensions %2" 
) else (
set USER_EXT=
)

echo "--------------------"
echo "Convert P10 to PEM  "
echo "--------------------"
openssl req -in .\%1.p10 -inform DER -out .\%1.pem -outform PEM 2>&1

echo "--------------------"
echo "Copy user csr       "
echo "--------------------"
copy %1.pem .\demoCA\req\%1_req.pem

echo "---------------------------"
echo "Generating user certificate"
echo "---------------------------"
openssl ca -config .\openssl.cnf -out .\demoCA\certs\%1_cert.pem -keyfile .\demoCA\private\cakey.pem %USER_EXT% -in .\demoCA\req\%1_req.pem -batch 2>&1
openssl x509 -in .\demoCA\certs\%1_cert.pem -inform PEM -out .\demoCA\certs\%1.crt -outform DER 2>&1
call createchain.bat %1

goto END

:USAGE
echo "Usage:"
echo "certp10 <ID> [user extensions section (usr_cert)]"
echo "This creates a <ID>_cert.crt file."
goto END

:USER_EXISTS
echo "Certificate already exists"
goto END

:USAGE

:END
