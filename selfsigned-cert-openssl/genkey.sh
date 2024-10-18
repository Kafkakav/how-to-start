#!/bin/sh
#
#export OPENSSL_CONF=<full path of openssl.cnf_file>
SUBJECT_CA="/C=TW/ST=Taipei/L=Taipei/O=NozomiLabs/OU=DevOps Dept./CN=NozomiLabs Root CA/emailAddress=nozomi@localhost"
SUBJECT_ITM="/C=TW/ST=Taipei/L=Taipei/O=NozomiLabs/OU=DevOps Dept./CN=NozomiLabs Intermediate CA/emailAddress=nozomi@localhost"
SUBJECT_CERT="/C=TW/ST=Taipei/L=Taipei/O=NozomiLabs/OU=R&D Dept./CN=NozomiLabs Intermediate CA/emailAddress=nozomi@localhost"

#Generate the Root CA(Root Certificate Authority) Private Key
if [ "$1" == "rootca" ] ; then
  openssl genrsa -aes256 -out rootCA.key 4096
  openssl req -new -x509 -days 3650 -key rootCA.key -out rootCA.crt -subj "${SUBJECT_CA}" -config openssl_ca.cnf
  openssl x509 -noout -text -in rootCA.crt
fi

# Generate the Intermediate CA Private Key and CSR
if [ "$1" == "intermediate" ] ; then
  openssl genrsa -aes256 -out intermediate.key 4096
  #remote key
  openssl rsa -in intermediate.key -out intermediate_nopw.key
  openssl req -sha384 -new -key intermediate.key -out intermediate.csr -subj "${SUBJECT_ITM}"
  openssl x509 -req -in intermediate.csr -CA rootCA.crt -CAkey rootCA.key \
              -CAserial rootCA.serial -CAcreateserial \
              -days 3650 \
              -extensions intermediate_ca -extfile openssl_ca.cnf \
              -out intermediate.crt
  openssl x509 -noout -text -in intermediate.crt
  cat intermediate.crt rootCA.crt > ca-bundle.pem
fi

# Generate the Intermediate CA Private Key and CSR
if [ "$1" == "newcert" ] ; then
  openssl genrsa -aes256 -passout pass:xyz978 -out newcert_pw.key 4096
  echo "password=xyz978"
  #remote key
  openssl rsa -in newcert_pw.key -out newcert.key 
  openssl req -sha384 -new -key newcert.key -out newcert.csr -config ./openssl.cnf
  openssl x509 -req -in newcert.csr \
              -CA intermediate.crt -CAkey intermediate_nopw.key \
              -CAserial intermediate.serial -CAcreateserial \
              -days 3650 \
              -extensions v3_req -extfile openssl.cnf \
              -out newcert.crt
  openssl x509 -noout -text -in newcert.crt
  #openssl verify -CAfile rootCA.crt -untrusted intermediate.crt newcert.crt
  openssl verify -CAfile ca-bundle.pem newcert.crt
fi
