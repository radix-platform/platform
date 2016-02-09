
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/sane/backends

REQUIRES           = libs/eudev/3.1.5
REQUIRES          += libs/libusb/1.0.19
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += libs/libieee1284/0.2.11
REQUIRES          += libs/libgphoto2/2.5.8
REQUIRES          += libs/v4l-utils/1.8.0
else
REQUIRES          += libs/libieee1284/0.2.11-x86_32
REQUIRES          += libs/libgphoto2/2.5.8-x86_32
REQUIRES          += libs/v4l-utils/1.8.0-x86_32
endif
REQUIRES          += net/avahi-daemon/0.6.31
REQUIRES          += net/net-snmp/5.7.3
REQUIRES          += app/dbus/1.8.10
REQUIRES          += app/cups/2.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.24
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/sane/backends/sane-backends-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sane-backends-$(version)
src_dir_name       = sane-backends-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

dev_dir_name       = dev-machine
dev_dir            = $(TARGET_BUILD_DIR)/$(dev_dir_name)

radix_doc_dir      = $(CURDIR)/doc


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SANE_PKG_NAME                = sane-backends
SANE_PKG_VERSION             = 1.0.24
SANE_PKG_ARCH                = $(TOOLCHAIN)
SANE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SANE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SANE_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
SANE_PKG_SHORT_DESCRIPTION   = universal scanner interface backends
SANE_PKG_URL                 = $(BUG_URL)
SANE_PKG_LICENSE             = GPLv2
SANE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SANE_PKG_NAME)-pkg-description
SANE_PKG_DESCRIPTION_FILE_IN = $(SANE_PKG_NAME)-pkg-description.in
SANE_PKG_INSTALL_SCRIPT      = $(SANE_PKG_NAME)-pkg-install.sh

SANE_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SANE_PKG_NAME)-package

pkg_basename     = $(SANE_PKG_NAME)-$(SANE_PKG_VERSION)-$(SANE_PKG_ARCH)-$(SANE_PKG_DISTRO_NAME)-$(SANE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(SANE_PKG)


ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
OPTIMIZATION_FLAGS = -O2
endif


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib

extra_configure_switches += --with-docdir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --enable-locking
extra_configure_switches += --with-lockdir=/var/lock/sane
extra_configure_switches += --enable-pthread
extra_configure_switches += --enable-avahi
extra_configure_switches += --enable-libusb_1_0

extra_configure_switches += --with-group=scanner
extra_configure_switches += --with-gphoto2=yes
extra_configure_switches += --with-v4l=yes
extra_configure_switches += --with-snmp=yes

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


environment += SNMP_CONFIG_PATH=$(TARGET_DEST_DIR)/usr/bin/net-snmp-config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(dev_dir)
	# ======= build 'sane-desc' utility for development machine =======
	@cd $(dev_dir) && \
	  CC=gcc LD=ld CFLAGS= LDFLAGS= LIBS= \
	  PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig \
	    ../$(src_dir_name)/configure --prefix=/usr --with-group=scanner
	@cd $(dev_dir) && $(MAKE) -C lib && $(MAKE) -C sanei && $(MAKE) -C tools sane-desc
	# ======= build SANE for target machine =======
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@( cd $(build_dir)/tools ; \
	   mkdir -p hal udev ; \
	   ../../$(dev_dir_name)/tools/sane-desc -m hal \
	     -s $(CURDIR)/$(SRC_DIR)/doc/descriptions:$(CURDIR)/$(SRC_DIR)/doc/descriptions-external \
	                                                                    -d 0 > hal/libsane.fdi ; \
	   ../../$(dev_dir_name)/tools/sane-desc -m udev \
	     -s $(CURDIR)/$(SRC_DIR)/doc/descriptions:$(CURDIR)/$(SRC_DIR)/doc/descriptions-external \
	                                                                 -d 0 > udev/libsane.rules ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SANE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(SANE_PKG)/etc/sane.d ; \
	   echo "# Uncomment the following line if hplip is installed:" >> dll.conf ; \
	   echo "hpaio" >>                                                 dll.conf ; \
	   for file in *.conf ; do \
	     mv $$file $${file}.new ; \
	   done ; \
	 )
	# ======= install udev rules =======
	@mkdir -p $(SANE_PKG)/lib/udev/rules.d
	@( cd $(build_dir) ; \
	   cat tools/udev/libsane.rules \
	     | sed -e "s/GROUP=\"scanner\"/GROUP=\"lp\"/g" \
	     | sed -e "s/MODE=\"0664\"/MODE=\"0660\"/g" \
	     | sed -e "s/ACTION!=\"add\"/ACTION!=\"add|change\"/g" \
	     > $(SANE_PKG)/lib/udev/rules.d/80-libsane.rules ; \
	 )
	# ======= uncomment following lines to install the HAL fdi file =======
	@mkdir -p $(SANE_PKG)/usr/share/hal/fdi/policy/10osvendor
	@( cd $(build_dir) ; \
	   cat tools/hal/libsane.fdi \
	     > $(SANE_PKG)/usr/share/hal/fdi/policy/10osvendor/10-libsane.fdi ; \
	 )
	@mkdir -p $(SANE_PKG)/var/lock/sane
	# ======= Install Documentation =======
	@if [ -d $(SANE_PKG)/usr/share/man ]; then \
	  ( cd $(SANE_PKG)/usr/share/man ; \
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
	@mkdir -p $(SANE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SANE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SANE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL $(SANE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SANE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install additional Documentation =======
	@mkdir -p $(SANE_PKG)/usr/share/doc/$(src_dir_name)/scanner-in-a-network
	@cp -a $(radix_doc_dir)/scanner-in-a-network.txt \
	       $(SANE_PKG)/usr/share/doc/$(src_dir_name)/scanner-in-a-network
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SANE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsane.la ; \
	 )
	@( cd $(SANE_PKG)/usr/lib$(LIBSUFFIX)/sane ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsane-*.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(SANE_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" sane-backends.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SANE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsane.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsane.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/sane ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsane-*.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsane-*.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sane-backends.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" sane-backends.pc ; \
	 )
	# ======= tune 'sane-config' script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sane-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SANE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SANE_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SANE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SANE_PKG_DESCRIPTION_FILE): $(SANE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SANE_PKG_DESCRIPTION_FILE) $(SANE_PKG_INSTALL_SCRIPT)
	@cp $(SANE_PKG_DESCRIPTION_FILE) $(SANE_PKG)/.DESCRIPTION
	@cp $(SANE_PKG_INSTALL_SCRIPT) $(SANE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SANE_PKG)/.REQUIRES
	@echo "pkgname=$(SANE_PKG_NAME)"                            >  $(SANE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SANE_PKG_VERSION)"                          >> $(SANE_PKG)/.PKGINFO ; \
	 echo "arch=$(SANE_PKG_ARCH)"                               >> $(SANE_PKG)/.PKGINFO ; \
	 echo "distroname=$(SANE_PKG_DISTRO_NAME)"                  >> $(SANE_PKG)/.PKGINFO ; \
	 echo "distrover=$(SANE_PKG_DISTRO_VERSION)"                >> $(SANE_PKG)/.PKGINFO ; \
	 echo "group=$(SANE_PKG_GROUP)"                             >> $(SANE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SANE_PKG_SHORT_DESCRIPTION)\"" >> $(SANE_PKG)/.PKGINFO ; \
	 echo "url=$(SANE_PKG_URL)"                                 >> $(SANE_PKG)/.PKGINFO ; \
	 echo "license=$(SANE_PKG_LICENSE)"                         >> $(SANE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SANE_PKG) && \
	                       chown   -R root:root .   && \
	                       chmod  755 var           && \
	                       chmod 1777 var/lock      && \
	                       chown 0:93 var/lock/sane && \
	                       chmod  755 var/lock/sane && $(MAKE_PACKAGE) --linkadd yes .."
