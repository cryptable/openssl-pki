@echo off
rem **********************
rem * parameter checking *
rem **********************

rem * UserId checking
if "%1"=="" goto USAGE
if exist .\demoCA\p12\%1.p12 goto USER_EXISTS
rem * Config file checking
if not "%2"=="" (
set USER_EXT=-extensions %2
) else (
set USER_EXT=
)

rem set VERBOSE=""
set VERBOSE="-verbose"


echo "--------------------"
echo "Generating user keys"
echo "--------------------"
openssl req %VERBOSE% -multivalue-rdn -config .\openssl.cnf -new -keyout .\demoCA\private\%1_key.pem -out .\demoCA\req\%1_req.pem

echo "---------------------------"
echo "Generating user certificate"
echo "---------------------------"
openssl ca %VERBOSE% -multivalue-rdn -config .\openssl.cnf -out .\demoCA\certs\%1_cert.pem -keyfile .\demoCA\private\cakey.pem %USER_EXT% -in .\demoCA\req\%1_req.pem
openssl x509 -in .\demoCA\certs\%1_cert.pem -inform PEM -out .\demoCA\certs\%1.crt -outform DER
call createchain.bat %1

echo "-------------------"
echo "Generating P12 file"
echo "-------------------"
openssl pkcs12 -export -inkey .\demoCA\private\%1_key.pem -in .\demoCA\certs\%1_cert.pem -chain -CAfile .\demoCA\cachain.pem -out .\demoCA\p12\%1.p12 -name %1

goto END

rem ***** show usage *****
:USAGE
echo "gencert <ID> [user extensions section (usr_cert)]"
echo "This creates a <ID>.p12 file."
goto END

rem ***** user exits *****
:USER_EXISTS
echo "P12 or certificate already exists"
goto END

:END
