#!/bin/sh -e
# This data is documented at <https://www.iana.org/domains/root/files>.

wget -O root.hints.NEW https://www.internic.net/domain/named.root

# ignore the update date, which changes daily
if diff -u --ignore-matching-lines='^;[[:space:]]*\(last update\|related version of root zone\):' root.hints root.hints.NEW; then
  echo "root.hints has NOT changed."
  rm root.hints.NEW
  exit
fi

echo "root.hints has changed."

wget -O root.hints.sig.NEW https://www.internic.net/domain/named.root.sig

gpgv --keyring $(pwd)/registry-admin.key root.hints.sig.NEW root.hints.NEW

mv root.hints.NEW root.hints
mv root.hints.sig.NEW root.hints.sig

