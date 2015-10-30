
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/util-linux
SOURCE_REQUIRES   += sources/packages/a/adjtimex
SOURCE_REQUIRES   += sources/packages/a/bsdstrings
SOURCE_REQUIRES   += sources/packages/n/net-tools
SOURCE_REQUIRES   += sources/packages/a/setserial
SOURCE_REQUIRES   += sources/packages/a/ziptool


REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version             = 2.24.1
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/util-linux/util-linux-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/util-linux-$(version)
src_dir_name        = util-linux-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done

adjtimex_version    = 1.29
adjtimex_archive    = $(SRC_PACKAGE_PATH)/packages/a/adjtimex/adjtimex-$(adjtimex_version).tar.gz
ADJTIMEX_SRC_DIR    = $(TARGET_BUILD_DIR)/adjtimex-$(adjtimex_version)
adjtimex_src_done   = $(TARGET_BUILD_DIR)/.adjtimex-source-done

bsdstrings_archive  = $(SRC_PACKAGE_PATH)/packages/a/bsdstrings/bsdstrings.tar.gz
BSDSTRINGS_SRC_DIR  = $(TARGET_BUILD_DIR)/bsdstrings
bsdstrings_src_done = $(TARGET_BUILD_DIR)/.bsdstrings-source-done

nettools_version    = 1.60-20140218
nettools_archive    = $(SRC_PACKAGE_PATH)/packages/n/net-tools/net-tools-$(nettools_version).tar.bz2
NETTOOLS_SRC_DIR    = $(TARGET_BUILD_DIR)/net-tools-$(nettools_version)
nettools_src_done   = $(TARGET_BUILD_DIR)/.nettools-source-done

setserial_version   = 2.17
setserial_archive   = $(SRC_PACKAGE_PATH)/packages/a/setserial/setserial-$(setserial_version).tar.gz
SETSERIAL_SRC_DIR   = $(TARGET_BUILD_DIR)/setserial-$(setserial_version)
setserial_src_done  = $(TARGET_BUILD_DIR)/.setserial-source-done

ziptool_version     = 1.4.0
ziptool_archive     = $(SRC_PACKAGE_PATH)/packages/a/ziptool/ziptool-$(ziptool_version).tar.xz
ZIPTOOL_SRC_DIR     = $(TARGET_BUILD_DIR)/ziptool-$(ziptool_version)
ziptool_src_done    = $(TARGET_BUILD_DIR)/.ziptool-source-done


PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UTILLINUX_PKG_NAME                = util-linux
UTILLINUX_PKG_VERSION             = 2.24.1
UTILLINUX_PKG_ARCH                = $(TOOLCHAIN)
UTILLINUX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UTILLINUX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UTILLINUX_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UTILLINUX_PKG_SHORT_DESCRIPTION   = huge collection of essential utilities
UTILLINUX_PKG_URL                 = $(BUG_URL)
UTILLINUX_PKG_LICENSE             = GPLv2
UTILLINUX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UTILLINUX_PKG_NAME)-pkg-description
UTILLINUX_PKG_DESCRIPTION_FILE_IN = $(UTILLINUX_PKG_NAME)-pkg-description.in
UTILLINUX_PKG_INSTALL_SCRIPT      = $(UTILLINUX_PKG_NAME)-pkg-install.sh

UTILLINUX_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UTILLINUX_PKG_NAME)-package

pkg_basename     = $(UTILLINUX_PKG_NAME)-$(UTILLINUX_PKG_VERSION)-$(UTILLINUX_PKG_ARCH)-$(UTILLINUX_PKG_DISTRO_NAME)-$(UTILLINUX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(UTILLINUX_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-ncurses
extra_configure_switches += --enable-agetty
extra_configure_switches += --enable-cramfs
extra_configure_switches += --enable-fdformat
extra_configure_switches += --enable-kill
extra_configure_switches += --disable-last
extra_configure_switches += --enable-line
extra_configure_switches += --enable-mesg
extra_configure_switches += --enable-partx
extra_configure_switches += --enable-raw
extra_configure_switches += --enable-rename
extra_configure_switches += --enable-reset
extra_configure_switches += --enable-tunelp

extra_configure_switches += --disable-login
extra_configure_switches += --disable-nologin
extra_configure_switches += --disable-sulogin
extra_configure_switches += --disable-su

extra_configure_switches += --enable-schedutils

extra_configure_switches += --enable-wall
extra_configure_switches += --enable-write
extra_configure_switches += --enable-use-tty-group
extra_configure_switches += --enable-makeinstall-chown=no

extra_configure_switches += --enable-libblkid
extra_configure_switches += --enable-libmount
extra_configure_switches += --enable-libuuid
extra_configure_switches += --disable-uuidd

ziptool_environment = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS) -Wall"
bsdstrings_environment = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS)"
nettools_environment = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS) -Wall"


####### Dependencies

$(adjtimex_src_done): $(adjtimex_archive)
	@echo "Expanding $(adjtimex_archive)"
	@tar xzf $(adjtimex_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(bsdstrings_src_done): $(bsdstrings_archive)
	@echo "Expanding $(bsdstrings_archive)"
	@tar xzf $(bsdstrings_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(nettools_src_done): $(nettools_archive)
	@echo "Expanding $(nettools_archive)"
	@tar xjf $(nettools_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(setserial_src_done): $(setserial_archive)
	@echo "Expanding $(setserial_archive)"
	@tar xzf $(setserial_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(ziptool_src_done): $(ziptool_archive)
	@echo "Expanding $(ziptool_archive)"
	@tar xJf $(ziptool_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(adjtimex_src_done) $(bsdstrings_src_done) $(nettools_src_done) $(setserial_src_done) $(ziptool_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(ZIPTOOL_SRC_DIR) && $(BUILD_ENVIRONMENT) $(ziptool_environment) $(MAKE)
	@cd $(BSDSTRINGS_SRC_DIR) && $(BUILD_ENVIRONMENT) $(bsdstrings_environment) $(MAKE)
	@cd $(NETTOOLS_SRC_DIR) && $(BUILD_ENVIRONMENT) $(nettools_environment) $(MAKE) hostname
	@cd $(ADJTIMEX_SRC_DIR) && \
	    $(BUILD_ENVIRONMENT) ./configure --prefix=/usr --build=$(BUILD) --host=$(TARGET)
	@cd $(ADJTIMEX_SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SETSERIAL_SRC_DIR) && \
	    $(BUILD_ENVIRONMENT) ./configure --prefix=/usr --build=$(BUILD) --host=$(TARGET)
	@cd $(SETSERIAL_SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UTILLINUX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(UTILLINUX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.1.* . ; \
	   ln -sf libblkid.so.1.* libblkid.so.1 ; \
	   ln -sf libmount.so.1.* libmount.so.1 ; \
	   ln -sf libuuid.so.1.*  libuuid.so.1  ; \
	   rm -f lib*.so ; \
	   ln -sf libblkid.so.1 libblkid.so ; \
	   ln -sf libmount.so.1 libmount.so ; \
	   ln -sf libuuid.so.1  libuuid.so  ; \
	 )
	@if [ -r $(UTILLINUX_PKG)/usr/sbin/fdformat ] ; then \
	   mkdir -p $(UTILLINUX_PKG)/usr/bin ; \
	   mv $(UTILLINUX_PKG)/usr/sbin/fdformat $(UTILLINUX_PKG)/usr/bin/fdformat ; \
	   ( cd $(UTILLINUX_PKG)/usr/sbin ; ln -sf ../bin/fdformat . ) ; \
	 fi
	@if [ -r $(UTILLINUX_PKG)/usr/bin/setterm ] ; then \
	   mkdir -p $(UTILLINUX_PKG)/bin ; \
	   mv $(UTILLINUX_PKG)/usr/bin/setterm $(UTILLINUX_PKG)/bin/setterm ; \
	   ( cd $(UTILLINUX_PKG)/usr/bin ; ln -sf ../../bin/setterm . ) ; \
	 fi
	@if [ -r $(UTILLINUX_PKG)/usr/bin/getopt ] ; then \
	   mkdir -p $(UTILLINUX_PKG)/bin ; \
	   mv $(UTILLINUX_PKG)/usr/bin/getopt $(UTILLINUX_PKG)/bin/getopt ; \
	   ( cd $(UTILLINUX_PKG)/usr/bin ; ln -sf ../../bin/getopt . ) ; \
	 fi
	# ======= Install ziptool-$(ziptool_version) =======
	@mkdir -p $(UTILLINUX_PKG)/sbin
	@cat $(ZIPTOOL_SRC_DIR)/ziptool > $(UTILLINUX_PKG)/sbin/ziptool
	@chmod 0755 $(UTILLINUX_PKG)/sbin/ziptool
	@mkdir -p $(UTILLINUX_PKG)/usr/share/man/man1
	@zcat $(ZIPTOOL_SRC_DIR)/ziptool.1.gz > $(UTILLINUX_PKG)/usr/share/man/man1/ziptool.1
	@mkdir -p $(UTILLINUX_PKG)/usr/share/doc/ziptool-$(ziptool_version)
	@cp -a $(ZIPTOOL_SRC_DIR)/README $(UTILLINUX_PKG)/usr/share/doc/ziptool-$(ziptool_version)
	@chmod 0644 $(UTILLINUX_PKG)/usr/share/doc/ziptool-$(ziptool_version)/README
	# ======= Install bsdstrings =======
	@mkdir -p $(UTILLINUX_PKG)/usr/bin
	@cat $(BSDSTRINGS_SRC_DIR)/strings > $(UTILLINUX_PKG)/usr/bin/strings
	@chmod 0755 $(UTILLINUX_PKG)/usr/bin/strings
	@mkdir -p $(UTILLINUX_PKG)/usr/share/man/man1
	@cat $(BSDSTRINGS_SRC_DIR)/strings.1 > $(UTILLINUX_PKG)/usr/share/man/man1/strings.1
	# ======= Install net-tools-$(nettools_version)/hostname =======
	@mkdir -p $(UTILLINUX_PKG)/bin
	@cat $(NETTOOLS_SRC_DIR)/hostname > $(UTILLINUX_PKG)/bin/hostname
	@chmod 0755 $(UTILLINUX_PKG)/bin/hostname
	@( cd $(UTILLINUX_PKG)/bin ; \
	   ln -sf hostname dnsdomainname ; \
	   ln -sf hostname nisdomainname ; \
	   ln -sf hostname ypdomainname  ; \
	   ln -sf hostname domainname    ; \
	 )
	@mkdir -p $(UTILLINUX_PKG)/usr/share/man/man1
	@( cd $(NETTOOLS_SRC_DIR)/man/en_US ; \
	   for page in hostname.1 dnsdomainname.1 \
	               nisdomainname.1 ypdomainname.1 domainname.1 ; do \
	     cp -a $$page $(UTILLINUX_PKG)/usr/share/man/man1 ; \
	   done \
	 )
	# ======= Install adjtimex-$(adjtimex_version) =======
	@mkdir -p $(UTILLINUX_PKG)/sbin
	@cat $(ADJTIMEX_SRC_DIR)/adjtimex > $(UTILLINUX_PKG)/sbin/adjtimex
	@chmod 0755 $(UTILLINUX_PKG)/sbin/adjtimex
	@mkdir -p $(UTILLINUX_PKG)/usr/share/man/man8
	@cat $(ADJTIMEX_SRC_DIR)/adjtimex.8 > $(UTILLINUX_PKG)/usr/share/man/man8/adjtimex.8
	@mkdir -p $(UTILLINUX_PKG)/usr/doc/adjtimex-$(adjtimex_version)
	@( cd $(ADJTIMEX_SRC_DIR) ; \
	   cp -a COPYING COPYRIGHT $(UTILLINUX_PKG)/usr/doc/adjtimex-$(adjtimex_version) ; \
	 )
	@mkdir -p $(UTILLINUX_PKG)/usr/share/doc/adjtimex-$(adjtimex_version)
	@( cd $(ADJTIMEX_SRC_DIR) ; \
	   iconv -f KOI8-R -t UTF-8 README.ru > README.utf8.ru ; \
	 )
	@( cd $(ADJTIMEX_SRC_DIR) ; \
	   cp -a COPYING COPYRIGHT README README.utf8.ru $(UTILLINUX_PKG)/usr/share/doc/adjtimex-$(adjtimex_version) ; \
	 )
	@( cd $(ADJTIMEX_SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(UTILLINUX_PKG)/usr/share/doc/adjtimex-$(adjtimex_version)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install setserial-$(setserial_version) =======
	@mkdir -p $(UTILLINUX_PKG)/sbin
	@mkdir -p $(UTILLINUX_PKG)/var/lock/subsys
	@cat $(SETSERIAL_SRC_DIR)/setserial > $(UTILLINUX_PKG)/sbin/setserial
	@chmod 0755 $(UTILLINUX_PKG)/sbin/setserial
	@mkdir -p $(UTILLINUX_PKG)/usr/share/man/man8
	@cat $(SETSERIAL_SRC_DIR)/setserial.8 > $(UTILLINUX_PKG)/usr/share/man/man8/setserial.8
	@mkdir -p $(UTILLINUX_PKG)/etc/rc.d
	@( cd $(SETSERIAL_SRC_DIR) ; \
	   cat rc.serial > $(UTILLINUX_PKG)/etc/rc.d/rc.serial.new ; \
	   cat serial.conf > $(UTILLINUX_PKG)/etc/serial.conf.new ; \
	 )
	@mkdir -p $(UTILLINUX_PKG)/usr/share/doc/setserial-$(setserial_version)
	@( cd $(SETSERIAL_SRC_DIR) ; \
	   cp -a README Documentation/byterunner-setup $(UTILLINUX_PKG)/usr/share/doc/setserial-$(setserial_version) ; \
	 )
	# ======= Setup important symlinks =======
	@( cd $(UTILLINUX_PKG)/sbin ; \
	   ln -s ../bin/mount . ; \
	   ln -s ../bin/umount . ; \
	   ln -s ziptool jaztool ; \
	   ln -s hwclock clock ; \
	   cd $(UTILLINUX_PKG)/usr/sbin ; \
	   ln -s ../../sbin/cfdisk . ; \
	   ln -s ../../sbin/ctrlaltdel . ; \
	   ln -s ../../sbin/sfdisk . ; \
	   cd $(UTILLINUX_PKG)/usr/bin ; \
	   ln -s ../sbin/readprofile . ; \
	   ln -s ../sbin/tunelp . ; \
	   ln -s ../../bin/more . ; \
	   ln -s ../../sbin/raw . ; \
	   cd $(UTILLINUX_PKG)/usr/share/man/man1 ; \
	   ln -s ziptool.1 jaztool.1 ; \
	   cd $(UTILLINUX_PKG)/usr/share/man/man8 ; \
	   ln -s hwclock.8 clock.8 ; \
	 )
	# ======= Install Documentation =======
	@( cd $(UTILLINUX_PKG)/usr/share/man/man1 ; \
	   for file in *.1 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@( cd $(UTILLINUX_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@( cd $(UTILLINUX_PKG)/usr/share/man/man8 ; \
	   for file in *.8 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(UTILLINUX_PKG)/usr/share/man ]; then \
	  ( cd $(UTILLINUX_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(UTILLINUX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(UTILLINUX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(UTILLINUX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -ar AUTHORS COPYING* NEWS README* \
	          Documentation/licenses/* Documentation/example.files \
	          $(UTILLINUX_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(UTILLINUX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(UTILLINUX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libblkid.la libmount.la libuuid.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(UTILLINUX_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libblkid.la libmount.la libuuid.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libblkid.la libmount.la libuuid.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" blkid.pc mount.pc uuid.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(UTILLINUX_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(UTILLINUX_PKG_DESCRIPTION_FILE): $(UTILLINUX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(UTILLINUX_PKG_DESCRIPTION_FILE) $(UTILLINUX_PKG_INSTALL_SCRIPT)
	@cp $(UTILLINUX_PKG_DESCRIPTION_FILE) $(UTILLINUX_PKG)/.DESCRIPTION
	@cp $(UTILLINUX_PKG_INSTALL_SCRIPT) $(UTILLINUX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UTILLINUX_PKG)/.REQUIRES
	@echo "pkgname=$(UTILLINUX_PKG_NAME)"                            >  $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UTILLINUX_PKG_VERSION)"                          >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "arch=$(UTILLINUX_PKG_ARCH)"                               >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "distroname=$(UTILLINUX_PKG_DISTRO_NAME)"                  >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "distrover=$(UTILLINUX_PKG_DISTRO_VERSION)"                >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "group=$(UTILLINUX_PKG_GROUP)"                             >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UTILLINUX_PKG_SHORT_DESCRIPTION)\"" >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "url=$(UTILLINUX_PKG_URL)"                                 >> $(UTILLINUX_PKG)/.PKGINFO ; \
	 echo "license=$(UTILLINUX_PKG_LICENSE)"                         >> $(UTILLINUX_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UTILLINUX_PKG)  && \
	                    chown -R root:root . && \
	                    chgrp tty usr/bin/wall  && \
	                    chmod g+s usr/bin/wall  && \
	                    chgrp tty usr/bin/write && \
	                    chmod g+s usr/bin/write && \
	                    $(MAKE_PACKAGE) --linkadd yes .."
