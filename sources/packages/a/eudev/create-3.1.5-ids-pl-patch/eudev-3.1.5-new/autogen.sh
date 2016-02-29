#!/bin/sh

export WANT_AUTOMAKE=1.11
autoreconf -f -i

cd man
./make.sh
