
## Generate Self-signed Certificates with Openssl
1. generate root CA
``` bash
genkey.sh rootca

```
2. generate intermediate CA
``` bash
genkey.sh intermediate

```

3. generate a host/server certificates with intermediate CA
``` bash
genkey.sh newcert

```
