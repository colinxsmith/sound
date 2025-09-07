#!/usr/bin/bash
 openssl req -newkey rsa:2048 -x509 -keyout bita-dev-key.pem -out bita-dev-cert.pem -days 3650
 openssl pkcs12 -export -inkey bita-dev-key.pem -in bita-dev-cert.pem -out bita-dev.pkcs12 -name 'Big Test'
