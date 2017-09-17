@echo off
if "%1"=="" goto USAGE

echo "--------------------"
echo "Copy user csr       "
echo "--------------------"
type .\demoCA\cachain.pem > .\demoCA\certs\%1_chain.pem
type .\demoCA\certs\%1_cert.pem >> .\demoCA\certs\%1_chain.pem
echo "---------------------------"
echo "Create PKCS#7 Chain        "
echo "---------------------------"
openssl crl2pkcs7 -nocrl -certfile .\demoCA\certs\%1_chain.pem -out .\demoCA\certs\%1_chain.p7c -outform DER

goto END

:USAGE
echo "Usage:"
echo "createchain <ID>"
echo "This creates a chain from <ID>_cert.pem to <ID>_chain.pem and <ID>_chain.p7c file."
goto END


:END
