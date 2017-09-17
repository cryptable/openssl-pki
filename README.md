OpenSSL PKI
===========
This is a small openssl based PKI. It uses convention of ID and filename based system. As base configuration it will copy the openssl.cnf file from your Windows or Linux distribution during the creation of a (sub) Certification authority.
All dynamic files are located in the demoCA directory. The openssl.cnf file will be in the current directory of your CA.
Each certificate will have following files based on the <ID> of certification generation of request:
  - demoCA/certs/<ID>.crt : binary certificate
  - demoCA/certs/<ID>_cert.pem : PEM encoded certificate
  - demoCA/certs/<ID>_chain.p7c : binary certificate chain
  - demoCA/certs/<ID>_chain.pem : PEM enconded certificate chain
  - demoCA/p12/<ID>.p12 : PKCS12 with private key, certificate and certificate chain
  - demoCA/private/<ID>_key.pem : PEM encoded private key
  - demoCA/req/<ID>_req.pem: PEM encoded certificate request

Run the setenv.(bat|sh) to add the bin directory to your path or copy the script to a directory accessible by your PATH.
On Linux:
. setenv.sh<ENTER>
On Windows:
setenv.bat<ENTER>

If you want to backup the Certification Authority. You backup the demoCA directory with the openssl.cnf file.

Create a new Certification Authority
====================================
Command:
newca [config]

Parameters:
config (optional): When config is added, notepad is started and you can edit the openssl.cfg file to configure your new CA. Important settings to change are default_days(validity of your CA), default_md(hash algorithm should today be sha256), default_bits (for CAs 4096). After the CA generation, you can edit these values for your certificates, because these will be used as defaults in the scripts. Normally it advisable to change the req_distinguished_name section to some easy reuseable values. (see References)

Description:
Creates a new Certification Authority.

References:
http://www.openssl.org/docs/apps/config.html
http://www.openssl.org/docs/apps/req.html
http://www.openssl.org/docs/apps/x509v3_config.html

Create a certificate
====================
Command:
gencert <ID> [user extensions section (usr_cert)]

Parameters:
ID: This is the identifier of the certificate. It should be unique for each certificate. Also each certificate DN should be unique.
user extensions section (usr_cert): This points to the extension section of the openssl.cnf file in the current directory

Description:
Creates a certificate using the current Certification Authority defined in the demoCA directory.

References:
http://www.openssl.org/docs/apps/config.html
http://www.openssl.org/docs/apps/req.html
http://www.openssl.org/docs/apps/x509v3_config.html
http://www.openssl.org/docs/apps/ca.html

Note:
If you want to reuse a DN, you'll have to remove the old one from the index.txt. This won't allow you to revoke the old certificate anymore. So only do this when the old certificate was never used.

Create a certificate from request
=================================
Command:
certcsr <ID> [user extensions section (usr_cert)]
certss <ID> [user extensions section (usr_cert)]
certp10 <ID> [user extensions section (usr_cert)]

Parameters:
ID: This is the identifier of the certificate and should be the filename without extension. It should be unique for each certificate. Also each certificate DN should be unique for this CA
user extensions section (usr_cert): This points to the extension section of the openssl.cnf file in the current directory

Description:
Creates a certificate from the request using the current Certification Authority defined in the demoCA directory.
certcsr is a PEM version of a Certificate Signing Request
certp10 is a PKCS10 version of a Certificate Signing Request
certss is a self-signed certificate used as a Certificate Signing Request

References:
http://www.openssl.org/docs/apps/config.html
http://www.openssl.org/docs/apps/req.html
http://www.openssl.org/docs/apps/x509v3_config.html
http://www.openssl.org/docs/apps/ca.html

Revoke a certificate
====================
Command:
gencrl [<ID>]

Parameters:
ID (optional): This is the identifier of the certificate, which should be revoked.

Description:
Revokes a certificate when the ID is given. It always generates a new CRL with the revoked certificate.

References:
http://www.openssl.org/docs/apps/config.html
http://www.openssl.org/docs/apps/req.html
http://www.openssl.org/docs/apps/x509v3_config.html
http://www.openssl.org/docs/apps/ca.html

Create a new Subordinate Certification Authority
================================================
Command:
newsubca [config]

Parameters:
config (optional): When config is added, notepad is started and you can edit the openssl.cfg file to configure your new CA.

Description:
Creates a new Subordinate Certification Authority request. This has to be signed by the CA who will be the issuer of this CA.
Process:
1) newsubca [config]
Goto the Issuer CA
2) certsubca <filename without extension> <Config section of the openssl.cnf>
3) copy the certificate (pem and crt file) and chain to the subCA and copy them as cacert.crt, cacert.pem and chain into the demoCA directory

References:
http://www.openssl.org/docs/apps/config.html
http://www.openssl.org/docs/apps/req.html
http://www.openssl.org/docs/apps/x509v3_config.html


TODO
====

- Linux shell scripts (docker support) support for ENV variable to choose the extension policy. Can be done in openssl.cnf or as argument
- Linux shell scripts (docker support) support for ENV variable to pass password for input/output. Can be done in openssl.cnf ENV::
