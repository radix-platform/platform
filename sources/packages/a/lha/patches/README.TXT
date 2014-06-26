
/* begin *

   lha-114i.patch - patch prepared using Debian patches from Debian package: lha (1.14i-10.3).
                    Original patch procedure is that (but patches from Debian not fully correct):

                       CWD=`pwd`
                       tar xzvf $CWD/lha-114i.tar.gz
                       cd lha-114i
                       zcat $CWD/lha_1.14i-10.3.diff.gz | patch -p1 --verbose || exit 1
                       patch -p0 < debian/patch.paul
                       patch -p0 < debian/patch.multibyte
                       patch -p0 < debian/patch.CAN-2004-0234_0235
                       patch -p0 < debian/patch.header-overflow
                       patch -p1 < debian/patch.redhat-sec2
                       patch -p1 < debian/patch.CVE-2006-4335-CVE-2006-4337-CVE-2006-4338

 * end */
