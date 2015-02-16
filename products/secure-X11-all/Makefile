
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


#######
####### Board Support Packages
#######

ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
REQUIRES  = hal/drivers/omap543x/wl18xx_fw/8.8.10
REQUIRES += boot/u-boot/omap543x/2013.04-20140216
endif

ifeq ($(HARDWARE),$(HARDWARE_CB1X))
REQUIRES += boot/u-boot/A10/20140713
endif

ifeq ($(HARDWARE),$(HARDWARE_CB2X))
REQUIRES += boot/u-boot/A20/20140713
endif

#######
####### The System
#######

REQUIRES += libs/eglibc/2.19.1-zoneinfo
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/eglibc/2.19.1-x86_32
endif
REQUIRES += dev/binutils/2.24
REQUIRES += dev/gcc/4.9.1
REQUIRES += dev/libtool/2.4.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/libtool/2.4.2-x86_32
endif

#######
####### Module Init Tools and Core libs:
#######
REQUIRES += app/kmod/16
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kmod/16-x86_32
endif
REQUIRES += libs/libffi/3.0.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libffi/3.0.13-x86_32
endif
REQUIRES += libs/libelf/0.8.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libelf/0.8.13-x86_32
endif
REQUIRES += libs/libtasn1/3.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtasn1/3.4-x86_32
endif
REQUIRES += libs/libidn/1.28
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libidn/1.28-x86_32
endif
REQUIRES += libs/libunistring/0.9.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libunistring/0.9.3-x86_32
endif
REQUIRES += libs/lzo/2.08
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/lzo/2.08-x86_32
endif
REQUIRES += libs/keyutils/1.5.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/keyutils/1.5.9-x86_32
endif
REQUIRES += libs/gc/7.2d
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gc/7.2d-x86_32
endif
REQUIRES += app/gzip/1.6
REQUIRES += app/ncompress/4.2.4.4
REQUIRES += libs/libtermcap/1.2.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtermcap/1.2.3-x86_32
endif
REQUIRES += libs/readline/6.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/readline/6.3-x86_32
endif
REQUIRES += libs/expat/2.1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/expat/2.1.0-x86_32
endif
REQUIRES += app/gettext/0.18.3.2
REQUIRES += libs/pcre/8.34
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/pcre/8.34-x86_32
endif

REQUIRES += app/utempter/1.1.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/utempter/1.1.6-x86_32
endif

REQUIRES += libs/mpc/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/mpc/1.0.2-x86_32
endif
REQUIRES += dev/flex/2.5.39
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/flex/2.5.39-x86_32
endif
REQUIRES += dev/bison/2.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/bison/2.7-x86_32
endif
REQUIRES += dev/lua/5.2.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/lua/5.2.3-x86_32
endif
REQUIRES += net/openssl/1.0.1g
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/openssl/1.0.1g-x86_32
endif
REQUIRES += libs/libevent/2.0.21
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libevent/2.0.21-x86_32
endif
REQUIRES += dev/python2/2.7.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/python2/2.7.6-x86_32
endif
REQUIRES += app/db/6.1.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/db/6.1.19-x86_32
endif
REQUIRES += libs/gdbm/1.11
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gdbm/1.11-x86_32
endif
REQUIRES += dev/perl/5.18.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/perl/5.18.2-x86_32
endif

REQUIRES += app/bsd-games/2.17

REQUIRES += libs/aspell/0.60.6.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aspell/0.60.6.1-x86_32
endif
REQUIRES += libs/dict/aspell6-ca/2.1.5-1
REQUIRES += libs/dict/aspell6-de/2.1
REQUIRES += libs/dict/aspell6-en/7.1-0
REQUIRES += libs/dict/aspell6-es/1.11-2
REQUIRES += libs/dict/aspell6-fi/0.7-0
REQUIRES += libs/dict/aspell6-fr/0.50-3
REQUIRES += libs/dict/aspell6-it/2.2
REQUIRES += libs/dict/aspell6-ru/0.99f7-1

REQUIRES += dev/check/0.9.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/check/0.9.13-x86_32
endif
REQUIRES += app/kbd/2.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kbd/2.0.2-x86_32
endif

REQUIRES += app/ctags/5.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/ctags/5.8-x86_32
endif

REQUIRES += app/dialog/1.2-20140112
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/dialog/1.2-20140112-x86_32
endif


#######
####### Secure:
#######
REQUIRES += secure/cracklib/2.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/cracklib/2.9.1-x86_32
endif
REQUIRES += secure/pam/1.1.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/pam/1.1.8-x86_32
endif
REQUIRES += secure/pam_unix2/2.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/pam_unix2/2.9.1-x86_32
endif


#######
####### Dictionaries for /usr/share/dict (see FHS):
#######
REQUIRES += share/dict/scowl/7.1
REQUIRES += share/dict/words-ca/2.1.5-1
REQUIRES += share/dict/words-de/2.1
REQUIRES += share/dict/words-en_CA/7.1
REQUIRES += share/dict/words-en_CA-huge/7.1
REQUIRES += share/dict/words-en_CA-insane/7.1
REQUIRES += share/dict/words-en_CA-large/7.1
REQUIRES += share/dict/words-en_CA-small/7.1
REQUIRES += share/dict/words-en_GB/7.1
REQUIRES += share/dict/words-en_GB-huge/7.1
REQUIRES += share/dict/words-en_GB-insane/7.1
REQUIRES += share/dict/words-en_GB-large/7.1
REQUIRES += share/dict/words-en_GB-small/7.1
REQUIRES += share/dict/words-en_US/7.1
REQUIRES += share/dict/words-en_US-huge/7.1
REQUIRES += share/dict/words-en_US-insane/7.1
REQUIRES += share/dict/words-en_US-large/7.1
REQUIRES += share/dict/words-en_US-small/7.1
REQUIRES += share/dict/words-es/1.11-2
REQUIRES += share/dict/words-fi/0.7-0
REQUIRES += share/dict/words-fr/0.50-3
REQUIRES += share/dict/words-it/2.2
REQUIRES += share/dict/words-ru/0.99f7-1


#######
####### Core Utilites and SysVInit:
#######
REQUIRES += app/bash/4.3
REQUIRES += app/coreutils/8.22
REQUIRES += app/diffutils/3.3
REQUIRES += app/findutils/4.4.2
REQUIRES += app/sed/4.2.2
REQUIRES += app/grep/2.18
REQUIRES += app/texinfo/5.2
REQUIRES += dev/gperf/3.0.4
REQUIRES += app/sysvinit/2.88
REQUIRES += app/sysvinit-functions/8.54
REQUIRES += app/util-linux/2.24.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/util-linux/2.24.1-x86_32
endif
REQUIRES += app/acl/2.2.52
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/acl/2.2.52-x86_32
endif
REQUIRES += secure/libcap/2.24
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcap/2.24-x86_32
endif

#######
####### File Systems support:
#######
REQUIRES += app/xfsprogs/3.1.11
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/xfsprogs/3.1.11-x86_32
endif
REQUIRES += app/xfsdump/3.1.3
REQUIRES += app/e2fsprogs/1.42.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/e2fsprogs/1.42.9-x86_32
endif
REQUIRES += app/reiserfsprogs/3.6.24
REQUIRES += app/dosfstools/3.0.26
REQUIRES += app/jfsutils/1.1.15
REQUIRES += app/sysfsutils/2.1.0

#######
####### Shadow, system log, procps:
#######
REQUIRES += secure/shadow/4.2.1
REQUIRES += app/sysklogd/1.5
REQUIRES += app/procps/3.2.8

#######
####### Packages:
#######
REQUIRES += libs/libgamin/0.1.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libgamin/0.1.10-x86_32
endif
REQUIRES += libs/glib2/2.40.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/glib2/2.40.0-x86_32
endif
REQUIRES += app/gamin/0.1.10
REQUIRES += libs/libusb/1.0.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libusb/1.0.19-x86_32
endif
REQUIRES += libs/libusb-compat/0.1.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libusb-compat/0.1.5-x86_32
endif
REQUIRES += app/usbutils/007
REQUIRES += app/pciutils/3.2.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/pciutils/3.2.1-x86_32
endif

###
### NOTE: app/udev - is built without introspection (because
###                  gobject-introspection cannot be cross compiled)
###

## REQUIRES += app/udev/182
## ifeq ($(HARDWARE),$(HARDWARE_PC64))
## REQUIRES += app/udev/182-x86_32
## endif
## ifneq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
## REQUIRES += app/udev/182
## endif

REQUIRES += libs/eudev/1.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/eudev/1.9-x86_32
endif
REQUIRES += app/eudev/1.9


REQUIRES += app/tar/1.27.1
REQUIRES += app/cpio/2.11
REQUIRES += app/ed/1.9
REQUIRES += app/file/5.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/file/5.19-x86_32
endif
REQUIRES += app/gawk/4.1.1
REQUIRES += app/getty-ps/2.1.0b
REQUIRES += app/hdparm/9.43
REQUIRES += app/less/451
REQUIRES += app/lha/114i

REQUIRES += app/dcron/4.5
REQUIRES += app/logrotate/3.8.7

REQUIRES += secure/libcgroup/0.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcgroup/0.41-x86_32
endif

#######
####### SCSI:
#######
REQUIRES += libs/sg3_utils/1.39
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/sg3_utils/1.39-x86_32
endif
REQUIRES += app/sdparm/1.08


#######
####### Networking:
#######
REQUIRES += net/tcp_wrappers/7.6
REQUIRES += net/icmpinfo/1.11
REQUIRES += net/net-tools/1.60
REQUIRES += net/netdate/4
REQUIRES += net/biff+comsat/0.17
REQUIRES += net/bsd-finger/0.17
REQUIRES += net/netkit-bootparamd/0.17
REQUIRES += net/netkit-ftp/0.17
REQUIRES += net/netkit-ntalk/0.17
REQUIRES += net/netkit-routed/0.17
REQUIRES += net/netkit-rsh/0.17
REQUIRES += net/netkit-rusers/0.17
REQUIRES += net/netkit-rwall/0.17
REQUIRES += net/netkit-rwho/0.17
REQUIRES += net/netkit-telnet/0.17
REQUIRES += net/netkit-timed/0.17
REQUIRES += net/netwrite/0.17
REQUIRES += net/tftp-hpa/5.2

REQUIRES += net/dhcpcd/6.4.2

REQUIRES += net/p11-kit/0.20.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/p11-kit/0.20.2-x86_32
endif
REQUIRES += net/nettle/2.7.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/nettle/2.7.1-x86_32
endif
REQUIRES += dev/guile/2.0.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/guile/2.0.9-x86_32
endif
REQUIRES += net/gnutls/3.1.22
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/gnutls/3.1.22-x86_32
endif

REQUIRES += net/iputils/s20121221
REQUIRES += net/ethtool/3.12
REQUIRES += net/inetd/1.79
REQUIRES += net/openssh/6.6p1

REQUIRES += net/libgpg-error/1.16
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libgpg-error/1.16-x86_32
endif
REQUIRES += net/libassuan/2.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libassuan/2.1.2-x86_32
endif
REQUIRES += net/libksba/1.3.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libksba/1.3.1-x86_32
endif
REQUIRES += libs/pth/2.0.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/pth/2.0.7-x86_32
endif
REQUIRES += net/libgcrypt/1.6.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libgcrypt/1.6.2-x86_32
endif
REQUIRES += net/ca-certificates/32.0
REQUIRES += net/cyrus-sasl/2.1.26
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/cyrus-sasl/2.1.26-x86_32
endif
REQUIRES += net/openldap-client/2.4.39
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/openldap-client/2.4.39-x86_32
endif
REQUIRES += net/curl/7.38.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/curl/7.38.0-x86_32
endif
REQUIRES += net/libnl/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnl/1.1.4-x86_32
endif
REQUIRES += net/libnl3/3.2.25
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnl3/3.2.25-x86_32
endif
REQUIRES += net/libpcap/1.6.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libpcap/1.6.2-x86_32
endif
REQUIRES += net/tcpdump/4.6.2
REQUIRES += net/libnfnetlink/1.0.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnfnetlink/1.0.1-x86_32
endif
REQUIRES += net/libmnl/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libmnl/1.0.3-x86_32
endif
REQUIRES += net/libmbim/1.10.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libmbim/1.10.0-x86_32
endif
REQUIRES += net/libqmi/1.10.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libqmi/1.10.4-x86_32
endif
REQUIRES += net/ipset/6.21
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/ipset/6.21-x86_32
endif
REQUIRES += net/libnetfilter_conntrack/1.0.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_conntrack/1.0.4-x86_32
endif
REQUIRES += net/libnetfilter_acct/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_acct/1.0.2-x86_32
endif
REQUIRES += net/libnetfilter_cthelper/1.0.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_cthelper/1.0.0-x86_32
endif
REQUIRES += net/libnetfilter_cttimeout/1.0.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_cttimeout/1.0.0-x86_32
endif
REQUIRES += net/libnetfilter_log/1.0.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_log/1.0.1-x86_32
endif
REQUIRES += net/libnetfilter_queue/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_queue/1.0.2-x86_32
endif
REQUIRES += net/conntrack-tools/1.4.2
REQUIRES += net/nfacct/1.0.1
REQUIRES += net/iptables/1.4.21
REQUIRES += net/iproute2/3.16.0
REQUIRES += net/dhcp/4.3.1
REQUIRES += net/dirmngr/1.1.1
REQUIRES += net/pinentry/0.8.4

REQUIRES += net/gnupg/1.4.18
REQUIRES += net/gnupg2/2.0.26
REQUIRES += net/gpgme/1.5.1


REQUIRES += libs/libxml2/2.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libxml2/2.9.1-x86_32
endif
REQUIRES += libs/libxslt/1.1.28
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libxslt/1.1.28-x86_32
endif
REQUIRES += libs/libarchive/3.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libarchive/3.1.2-x86_32
endif
REQUIRES += libs/json-c/0.12
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/json-c/0.12-x86_32
endif
REQUIRES += net/idnkit/1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/idnkit/1.0-x86_32
endif

REQUIRES += net/bind/9.10.1
REQUIRES += net/wget/1.16
REQUIRES += net/whois/5.2.1
REQUIRES += net/rfkill/0.5
REQUIRES += net/bridge-utils/1.5
REQUIRES += net/iw/3.17
REQUIRES += net/crda/3.13
REQUIRES += net/wireless-tools/29

REQUIRES += app/dbus/1.8.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/dbus/1.8.10-x86_32
endif
REQUIRES += libs/dbus-glib/0.102
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/dbus-glib/0.102-x86_32
endif
REQUIRES += libs/dbus-python/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/dbus-python/1.2.0-x86_32
endif

REQUIRES += net/wpa_supplicant/2.3
REQUIRES += net/dnsmasq/2.72
REQUIRES += net/ebtables/2.0.10-4
REQUIRES += net/iftop/1.0pre4
REQUIRES += net/iptraf-ng/1.1.4


REQUIRES += libs/shared-mime-info/1.3
REQUIRES += dev/cmake/2.8.12.2


REQUIRES += app/vim/7.4-373

REQUIRES += libs/libpng/libpng14/1.4.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpng/libpng14/1.4.13-x86_32
endif
REQUIRES += libs/libjpeg-turbo/1.3.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libjpeg-turbo/1.3.1-x86_32
endif
REQUIRES += libs/libtiff/4.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtiff/4.0.3-x86_32
endif
REQUIRES += libs/icu4c/54.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/icu4c/54.1-x86_32
endif

REQUIRES += libs/freetype/2.5.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/freetype/2.5.3-x86_32
endif
REQUIRES += app/jbigkit/2.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/jbigkit/2.1-x86_32
endif
REQUIRES += libs/libpipeline/1.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpipeline/1.4.0-x86_32
endif

REQUIRES += libs/slang/2.2.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/slang/2.2.4-x86_32
endif


REQUIRES += app/mc/4.8.12
REQUIRES += app/tmux/1.9a


#######
####### Media packages:
#######

REQUIRES += libs/alsa-lib/1.0.28
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/alsa-lib/1.0.28-x86_32
endif
REQUIRES += libs/alsa-oss/1.0.28
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/alsa-oss/1.0.28-x86_32
endif
REQUIRES += libs/libogg/1.3.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libogg/1.3.2-x86_32
endif
REQUIRES += libs/libvorbis/1.3.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libvorbis/1.3.4-x86_32
endif
REQUIRES += app/flac/1.3.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/flac/1.3.0-x86_32
endif
REQUIRES += libs/libsndfile/1.0.25
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libsndfile/1.0.25-x86_32
endif
REQUIRES += libs/libsamplerate/0.1.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libsamplerate/0.1.8-x86_32
endif

REQUIRES += app/alsa-utils/1.0.28

REQUIRES += libs/audiofile/0.3.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/audiofile/0.3.6-x86_32
endif
REQUIRES += app/esound/0.2.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/esound/0.2.41-x86_32
endif
REQUIRES += libs/libao/1.1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libao/1.1.0-x86_32
endif

REQUIRES += app/mpg123/1.20.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/mpg123/1.20.1-x86_32
endif

REQUIRES += libs/libmad/0.15.1b
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libmad/0.15.1b-x86_32
endif
REQUIRES += libs/libid3tag/0.15.1b
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libid3tag/0.15.1b-x86_32
endif
REQUIRES += libs/wavpack/4.70.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/wavpack/4.70.0-x86_32
endif
REQUIRES += libs/opencore-amr/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/opencore-amr/0.1.3-x86_32
endif
REQUIRES += libs/fdk-aac/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/fdk-aac/0.1.3-x86_32
endif
REQUIRES += libs/vo-aacenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-aacenc/0.1.3-x86_32
endif
REQUIRES += libs/vo-amrwbenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-amrwbenc/0.1.3-x86_32
endif
REQUIRES += libs/gsm/1.0.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gsm/1.0.13-x86_32
endif
REQUIRES += libs/opus/1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/opus/1.1-x86_32
endif
REQUIRES += libs/lame/3.99.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/lame/3.99.5-x86_32
endif
REQUIRES += libs/portaudio/19-20140130
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/portaudio/19-20140130-x86_32
endif

REQUIRES += app/vorbis-tools/1.4.0

REQUIRES += app/sox/14.4.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sox/14.4.1-x86_32
endif


REQUIRES += app/patch/2.7
REQUIRES += dev/make/4.0
REQUIRES += dev/m4/1.4.17
REQUIRES += dev/autoconf/2.69
REQUIRES += dev/automake/1.14
REQUIRES += dev/autoconf-archive/2014.02.28
REQUIRES += app/which/2.20

REQUIRES += app/bin/4.4


#
# It would be better to build 'btrfs' after gd, png, jpeg, freetype (when its will be ready)
#
REQUIRES += app/btrfs-progs/3.16


#######
####### llvm, clang:
#######
REQUIRES += dev/llvm/3.5.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/llvm/3.5.0-x86_32
endif


#######
####### DocBook & Linux DOC packages:
#######
# REQUIRES += share/sgml-common/0.6.3
# REQUIRES += share/docbook-xml/4.5
# REQUIRES += share/docbook-xsl/1.78.1
REQUIRES += app/xmlto/0.0.26




#######
####### X11 X.org packages:
#######


#######
####### X.org doc (first):
#######
REQUIRES += X11/X.org/doc/xorg-sgml-doctools/1.11


REQUIRES += X11/X.org/proto-headers
REQUIRES += X11/X.org/util/makedepend/1.0.5
REQUIRES += X11/X.org/util/gccmakedep/1.0.3

#
# X.org data:
#
REQUIRES += X11/X.org/data/xbitmaps/1.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/data/xbitmaps/1.1.1-x86_32
endif
REQUIRES += X11/X.org/data/xcursor-themes/1.0.4
REQUIRES += X11/X.org/data/xkeyboard-config/2.13

#
# X.org lib:
#
REQUIRES += X11/X.org/lib/libXau/1.0.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXau/1.0.8-x86_32
endif
REQUIRES += X11/X.org/lib/libXdmcp/1.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXdmcp/1.1.1-x86_32
endif

#
# X.org xcb:
#
#REQUIRES += X11/X.org/xcb/xcb-proto/1.11
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-proto/1.11-x86_32
#endif
#REQUIRES += X11/X.org/xcb/libxcb/1.11
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/libxcb/1.11-x86_32
#endif
#REQUIRES += X11/X.org/xcb/xcb-util/0.4.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util/0.4.0-x86_32
#endif
REQUIRES += X11/X.org/xcb/xcb-util-cursor/0.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/xcb-util-cursor/0.1.1-x86_32
endif
#REQUIRES += X11/X.org/xcb/xcb-util-image/0.4.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util-image/0.4.0-x86_32
#endif
REQUIRES += X11/X.org/xcb/xcb-util-keysyms/0.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/xcb-util-keysyms/0.4.0-x86_32
endif
#REQUIRES += X11/X.org/xcb/xcb-util-renderutil/0.3.9
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util-renderutil/0.3.9-x86_32
#endif
REQUIRES += X11/X.org/xcb/xcb-util-wm/0.4.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/xcb-util-wm/0.4.1-x86_32
endif
REQUIRES += X11/X.org/xcb/xpyb/1.3.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/xpyb/1.3.1-x86_32
endif

REQUIRES += X11/X.org/xcb/libpthread-stubs/0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/libpthread-stubs/0.3-x86_32
endif

#
# X.org lib:
#
REQUIRES += X11/X.org/lib/xtrans/1.3.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/xtrans/1.3.5-x86_32
endif

REQUIRES += X11/X.org/lib/libX11/1.6.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libX11/1.6.2-x86_32
endif
REQUIRES += X11/X.org/lib/pixman/0.32.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/pixman/0.32.6-x86_32
endif
REQUIRES += X11/X.org/lib/libXext/1.3.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXext/1.3.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXrender/0.9.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXrender/0.9.8-x86_32
endif

REQUIRES += X11/X.org/lib/libfontenc/1.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libfontenc/1.1.2-x86_32
endif
REQUIRES += X11/X.org/lib/libFS/1.0.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libFS/1.0.6-x86_32
endif
REQUIRES += X11/X.org/lib/libICE/1.0.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libICE/1.0.9-x86_32
endif
REQUIRES += X11/X.org/lib/libSM/1.2.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libSM/1.2.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXScrnSaver/1.2.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXScrnSaver/1.2.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXt/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXt/1.1.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXpm/3.5.11
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXpm/3.5.11-x86_32
endif
REQUIRES += X11/X.org/lib/libXmu/1.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXmu/1.1.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXaw/1.0.12
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXaw/1.0.12-x86_32
endif
REQUIRES += X11/X.org/lib/libXaw3d/1.6.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXaw3d/1.6.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXfixes/5.0.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXfixes/5.0.1-x86_32
endif
REQUIRES += X11/X.org/lib/libXcm/0.5.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXcm/0.5.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXcomposite/0.4.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXcomposite/0.4.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXcursor/1.1.14
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXcursor/1.1.14-x86_32
endif
REQUIRES += X11/X.org/lib/libXdamage/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXdamage/1.1.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXevie/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXevie/1.0.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXfontcache/1.0.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXfontcache/1.0.5-x86_32
endif
REQUIRES += X11/X.org/lib/libXi/1.7.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXi/1.7.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXinerama/1.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXinerama/1.1.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXp/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXp/1.0.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXrandr/1.4.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXrandr/1.4.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXres/1.0.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXres/1.0.7-x86_32
endif
REQUIRES += X11/X.org/lib/libXtst/1.2.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXtst/1.2.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXv/1.0.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXv/1.0.10-x86_32
endif
REQUIRES += X11/X.org/lib/libXvMC/1.0.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXvMC/1.0.8-x86_32
endif
REQUIRES += X11/X.org/lib/libXxf86dga/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXxf86dga/1.1.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXxf86misc/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXxf86misc/1.0.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXxf86vm/1.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXxf86vm/1.1.3-x86_32
endif
REQUIRES += X11/X.org/lib/libdmx/1.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libdmx/1.1.3-x86_32
endif
REQUIRES += X11/X.org/lib/libpciaccess/0.13.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libpciaccess/0.13.2-x86_32
endif
REQUIRES += X11/X.org/lib/libxkbfile/1.0.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libxkbfile/1.0.8-x86_32
endif
REQUIRES += X11/X.org/lib/libxshmfence/1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libxshmfence/1.1-x86_32
endif


REQUIRES += X11/libs/libdrm/2.4.58
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/libdrm/2.4.58-x86_32
endif

REQUIRES += Wayland/wayland/1.6.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += Wayland/wayland/1.6.0-x86_32
endif

REQUIRES += X11/libs/mesa/10.3.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/mesa/10.3.4-x86_32
endif

REQUIRES += X11/libs/fontconfig/2.11.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/fontconfig/2.11.1-x86_32
endif
REQUIRES += libs/cairo/1.14.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/cairo/1.14.0-x86_32
endif
REQUIRES += libs/harfbuzz/0.9.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/harfbuzz/0.9.36-x86_32
endif
REQUIRES += libs/freetype/2.5.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/freetype/2.5.3-x86_32
endif
REQUIRES += X11/libs/netpbm/10.68.01
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/netpbm/10.68.01-x86_32
endif
REQUIRES += X11/app/dbus-x11-launch/1.8.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/app/dbus-x11-launch/1.8.10-x86_32
endif


REQUIRES += X11/X.org/lib/libXft/2.3.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXft/2.3.2-x86_32
endif

REQUIRES += X11/X.org/lib/libXfont/1.5.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXfont/1.5.0-x86_32
endif


#######
####### X.org applications:
#######
REQUIRES += X11/X.org/app-collection

REQUIRES += X11/X.org/app/xdm/1.1.11


#######
####### X.org fonts:
#######
REQUIRES += X11/X.org/font-collection

REQUIRES += X11/X.org/font/font-util/1.3.0


#######
####### Xwayland support:
#######
REQUIRES += X11/libs/libepoxy/1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/libepoxy/1.2-x86_32
endif

#######
####### weston support:
#######
REQUIRES += X11/libs/libinput/0.7.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/libinput/0.7.0-x86_32
endif


#######
####### X.org server:
#######
REQUIRES += X11/X.org/xserver/xorg-server/1.16.2


REQUIRES += X11/libs/libevdev/1.3.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/libevdev/1.3.2-x86_32
endif
REQUIRES += X11/libs/mtdev/1.1.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/mtdev/1.1.5-x86_32
endif


#######
####### X.org drivers:
#######
REQUIRES += X11/X.org/driver-input
REQUIRES += X11/X.org/driver-video



#######
####### X.org doc (last):
#######
REQUIRES += X11/X.org/doc/xorg-docs/1.7


#######
####### X applications:
#######
REQUIRES += X11/app/xterm/313

#######
####### X fonts:
#######
REQUIRES += X11/font/dejavu-fonts-ttf/2.34
REQUIRES += X11/font/thaixfonts/1.2.6

#######
####### X applications:
#######
REQUIRES += libs/giflib/5.1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/giflib/5.1.0-x86_32
endif
REQUIRES += X11/app/WindowMaker/0.95.6



#######
####### GTK+ libs & Desktop environment:
#######
REQUIRES += libs/atk/2.15.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/atk/2.15.1-x86_32
endif
REQUIRES += libs/libthai/0.1.20
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libthai/0.1.20-x86_32
endif
REQUIRES += libs/pango/1.36.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/pango/1.36.8-x86_32
endif
REQUIRES += app/cups/2.0.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/cups/2.0.1-x86_32
endif
REQUIRES += libs/lcms2/2.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/lcms2/2.6-x86_32
endif
REQUIRES += app/ghostscript/9.15
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/ghostscript/9.15-x86_32
endif
REQUIRES += app/qpdf/5.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/qpdf/5.1.2-x86_32
endif
REQUIRES += X11/libs/gdk-pixbuf2/2.31.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/gdk-pixbuf2/2.31.1-x86_32
endif
REQUIRES += libs/libcroco/0.6.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libcroco/0.6.8-x86_32
endif
REQUIRES += dev/vala/0.26.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/vala/0.26.1-x86_32
endif
REQUIRES += X11/libs/librsvg/2.40.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/librsvg/2.40.5-x86_32
endif
REQUIRES += X11/libs/cairo/1.14.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/cairo/1.14.0-x86_32
endif
REQUIRES += X11/libs/harfbuzz/0.9.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/harfbuzz/0.9.36-x86_32
endif

REQUIRES += app/sqlite/3.8.7.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sqlite/3.8.7.1-x86_32
endif
REQUIRES += libs/gstreamer0/0.10.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gstreamer0/0.10.36-x86_32
endif
REQUIRES += libs/libmng/2.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libmng/2.0.2-x86_32
endif

REQUIRES += X11/app/desktop-file-utils/0.22
REQUIRES += X11/libs/hicolor-icon-theme/0.14
REQUIRES += X11/app/xdg-utils/1.1.0
REQUIRES += X11/app/xdg-user-dirs/0.15

REQUIRES += libs/libtheora/1.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtheora/1.1.1-x86_32
endif
REQUIRES += app/cdparanoia/10.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/cdparanoia/10.2-x86_32
endif
REQUIRES += libs/libvisual/0.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libvisual/0.4.0-x86_32
endif

REQUIRES += libs/gst-plugins-base0/0.10.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gst-plugins-base0/0.10.36-x86_32
endif

REQUIRES += libs/gstreamer/1.4.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gstreamer/1.4.5-x86_32
endif
REQUIRES += libs/gst-plugins-base/1.4.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gst-plugins-base/1.4.5-x86_32
endif

REQUIRES += libs/boost/1.57.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/boost/1.57.0-x86_32
endif

#REQUIRES += libs/libaio/0.3.110
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libaio/0.3.110-x86_32
#endif
REQUIRES += app/mariadb/5.5.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/mariadb/5.5.41-x86_32
endif

REQUIRES += libs/libiodbc/3.52.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libiodbc/3.52.9-x86_32
endif


REQUIRES += X11/libs/qt4/4.8.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/qt4/4.8.6-x86_32
endif
REQUIRES += X11/libs/qt5/5.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/qt5/5.4.0-x86_32
endif

REQUIRES += libs/poppler/0.29.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/poppler/0.29.0-x86_32
endif

REQUIRES += X11/libs/gtk+2/2.24.25
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/gtk+2/2.24.25-x86_32
endif


REQUIRES += libs/taglib/1.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/taglib/1.9.1-x86_32
endif
REQUIRES += libs/log4cplus/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/log4cplus/1.2.0-x86_32
endif

REQUIRES += libs/zeromq/4.0.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/zeromq/4.0.5-x86_32
endif


REQUIRES += X11/libs/glew/1.12.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/glew/1.12.0-x86_32
endif
REQUIRES += X11/libs/freeglut/2.8.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/freeglut/2.8.1-x86_32
endif
REQUIRES += X11/libs/startup-notification/0.12
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/startup-notification/0.12-x86_32
endif

#######
####### Video streaming packages:
#######
REQUIRES += libs/aalib/1.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aalib/1.4.0-x86_32
endif

#REQUIRES += libs/libraw1394/2.1.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libraw1394/2.1.0-x86_32
#endif
REQUIRES += libs/libiec61883/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libiec61883/1.2.0-x86_32
endif
REQUIRES += libs/libavc1394/0.5.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libavc1394/0.5.4-x86_32
endif



#######
####### Additional DEV packages:
#######

#######
####### additional libs for bootstrap GCC:
#######
# REQUIRES += app/cloog/0.18.2
# REQUIRES += libs/ppl/1.1


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
