@echo off
if "%1"=="config" (
set CHANGE_CNF="true"
) else (
set CHANGE_CNF="false"
)

if exist .\demoCA\cacert.pem goto CLEAN
goto CREATECA

:CLEAN
del /F /S /Q .\demoCA\*
rmdir /S /Q .\demoCA

:CREATECA
mkdir .\demoCA
mkdir .\demoCA\private
mkdir .\demoCA\certs
mkdir .\demoCA\newcerts
mkdir .\demoCA\crl
mkdir .\demoCA\req
mkdir .\demoCA\p12
mkdir .\demoCA\plain
mkdir .\demoCA\cipher
mkdir .\demoCA\temp
mkdir .\demoCA\verify
copy %OPENSSL_CONF% .\openssl.cnf

echo %CHANGE_CNF%
if %CHANGE_CNF%=="true" (
notepad .\openssl.cnf
)

type nul > .\demoCA\index.txt
echo 01 > .\demoCA\crlnumber
openssl req -config .\openssl.cnf -new -keyout .\demoCA\private\cakey.pem -out .\demoCA\careq.pem

goto END

:USAGE
echo "newca [confile file]"

:END