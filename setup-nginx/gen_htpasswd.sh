#!/bin/sh
#
#./gen_htpasswd bill87
htpasswd -c /etc/nginx/.htpasswd $1
