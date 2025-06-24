#!/bin/sh -e
# This data is documented at <https://www.iana.org/dnssec/files>.

wget -O root-anchors.xml.NEW https://data.iana.org/root-anchors/root-anchors.xml

if diff -u root-anchors.xml root-anchors.xml.NEW; then
  echo "root-anchors.xml has NOT changed."
  rm root-anchors.xml.NEW
  exit
fi

echo "root-anchors.xml has changed."

wget -O root-anchors.p7s.NEW https://data.iana.org/root-anchors/root-anchors.p7s

openssl smime -verify -CAfile icannbundle.pem -inform DER -in root-anchors.p7s -content root-anchors.xml -out /dev/null

mv root-anchors.xml.NEW root-anchors.xml
mv root-anchors.p7s.NEW root-anchors.p7s

