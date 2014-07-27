#!/bin/sh

aclocal
autoconf
automake --force --copy --add-missing
