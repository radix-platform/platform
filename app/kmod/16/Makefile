
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/kmod


REQUIRES           = libs/zlib/1.2.8
REQUIRES          += app/xz/5.0.5


version            = 16
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/kmod/kmod-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/kmod-$(version)
src_dir_name       = kmod-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_kmod_pkg     = $(TARGET_BUILD_DIR)/.kmod_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KMOD_PKG_NAME                = kmod
KMOD_PKG_VERSION             = 16
KMOD_PKG_ARCH                = $(TOOLCHAIN)
KMOD_PKG_DISTRO_NAME         = kxLab
KMOD_PKG_DISTRO_VERSION      = 1.0
KMOD_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
KMOD_PKG_SHORT_DESCRIPTION   = kmod $(version)
KMOD_PKG_URL                 = http://www.kxLab.com
KMOD_PKG_LICENSE             = GPLv2
KMOD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KMOD_PKG_NAME)-pkg-description
KMOD_PKG_DESCRIPTION_FILE_IN = $(KMOD_PKG_NAME)-pkg-description.in
KMOD_PKG_INSTALL_SCRIPT      = $(KMOD_PKG_NAME)-pkg-install.sh

KMOD_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KMOD_PKG_NAME)-package

pkg_basename     = $(KMOD_PKG_NAME)-$(KMOD_PKG_VERSION)-$(KMOD_PKG_ARCH)-$(KMOD_PKG_DISTRO_NAME)-$(KMOD_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(KMOD_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_kmod_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(KMOD_PKG)

OPTIMIZATION_FLAGS = -O3


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --with-xz
extra_configure_switches += --with-zlib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
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
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(KMOD_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(KMOD_PKG)/sbin ; \
	   for file in depmod insmod lsmod modinfo modprobe rmmod ; do \
	     ln -sf kmod $$file ; \
	   done \
	 )
	@mkdir -p $(KMOD_PKG)/bin
	@( cd $(KMOD_PKG)/bin ; ln -sf /sbin/lsmod . )
	@mkdir -p $(KMOD_PKG)/etc/modprobe.d
	@mkdir -p $(KMOD_PKG)/usr/lib$(LIBSUFFIX)
	@mv $(KMOD_PKG)/lib$(LIBSUFFIX)/pkgconfig $(KMOD_PKG)/usr/lib$(LIBSUFFIX)
	@mv $(KMOD_PKG)/lib$(LIBSUFFIX)/{*.so,*.la} $(KMOD_PKG)/usr/lib$(LIBSUFFIX)
	@cp -a $(KMOD_PKG)/lib$(LIBSUFFIX)/libkmod.so.2 $(KMOD_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(KMOD_PKG)/usr/lib$(LIBSUFFIX) ; \
	  ln -sf ../../lib$(LIBSUFFIX)/libkmod.so.2.2.6 libkmod.so.2.2.6 ; \
	  sed -i "s,libdir='/lib',libdir='/usr/lib',g" libkmod.la ; \
	  sed -i "s,libdir=/lib,libdir=/usr/lib,g" pkgconfig/libkmod.pc \
	 )
	@mkdir -p $(KMOD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(KMOD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(KMOD_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/NEWS $(SRC_DIR)/README* $(SRC_DIR)/TODO \
	       $(KMOD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(KMOD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	@if [ -d $(KMOD_PKG)/usr/share/man ]; then \
	  ( cd $(KMOD_PKG)/usr/share/man ; \
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
	# remove toolchain path from target libtool *.la files and
	@( cd $(KMOD_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libkmod.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(KMOD_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libkmod.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.pc \
	 )
	@(cd $(KMOD_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(KMOD_PKG_DESCRIPTION_FILE): $(KMOD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_kmod_pkg): $(install_target) $(KMOD_PKG_DESCRIPTION_FILE)
	@cp $(KMOD_PKG_DESCRIPTION_FILE) $(KMOD_PKG)/.DESCRIPTION
	@cp $(KMOD_PKG_INSTALL_SCRIPT) $(KMOD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KMOD_PKG)/.REQUIRES
	@echo "pkgname=$(KMOD_PKG_NAME)"                            >  $(KMOD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KMOD_PKG_VERSION)"                          >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "arch=$(KMOD_PKG_ARCH)"                               >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "distroname=$(KMOD_PKG_DISTRO_NAME)"                  >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "distrover=$(KMOD_PKG_DISTRO_VERSION)"                >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "group=$(KMOD_PKG_GROUP)"                             >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KMOD_PKG_SHORT_DESCRIPTION)\"" >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "url=$(KMOD_PKG_URL)"                                 >> $(KMOD_PKG)/.PKGINFO ; \
	 echo "license=$(KMOD_PKG_LICENSE)"                         >> $(KMOD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KMOD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
