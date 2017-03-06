
COMPONENT_TARGETS  = $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/ump/DX/r5p1-01rel0

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 5.1.1.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/hal/ump/DX/r5p1-01rel0/libump-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libump-$(version)
src_dir_name       = libump-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

udev_rules         = $(CURDIR)/udev/50-mali.rules

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBUMP_PKG_NAME                = libump
LIBUMP_PKG_VERSION             = 5.1.1.0
LIBUMP_PKG_ARCH                = $(TOOLCHAIN)
LIBUMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUMP_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBUMP_PKG_SHORT_DESCRIPTION   = ARMs Universal Memory Provider
LIBUMP_PKG_URL                 = $(BUG_URL)
LIBUMP_PKG_LICENSE             = Apache
LIBUMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUMP_PKG_NAME)-pkg-description
LIBUMP_PKG_DESCRIPTION_FILE_IN = $(LIBUMP_PKG_NAME)-pkg-description.in
LIBUMP_PKG_INSTALL_SCRIPT      = $(LIBUMP_PKG_NAME)-pkg-install.sh

LIBUMP_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUMP_PKG_NAME)-package

pkg_basename     = $(LIBUMP_PKG_NAME)-$(LIBUMP_PKG_VERSION)-$(LIBUMP_PKG_ARCH)-$(LIBUMP_PKG_DISTRO_NAME)-$(LIBUMP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBUMP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

CFLAGS += -Wno-pointer-to-int-cast
CFLAGS += -Wno-int-to-pointer-cast
CFLAGS += -fno-strict-aliasing
CFLAGS += -Wno-strict-aliasing


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
	@mkdir -p $(LIBUMP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBUMP_PKG)/lib/udev/rules.d
	@cp $(udev_rules) $(LIBUMP_PKG)/lib/udev/rules.d
	# ======= Install Documentation =======
	@if [ -d $(LIBUMP_PKG)/usr/share/man ]; then \
	  ( cd $(LIBUMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBUMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBUMP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBUMP_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/README \
	       $(LIBUMP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBUMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUMP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libUMP.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUMP_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libUMP.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libUMP.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libump.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBUMP_PKG_DESCRIPTION_FILE): $(LIBUMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUMP_PKG_DESCRIPTION_FILE) $(LIBUMP_PKG_INSTALL_SCRIPT)
	@cp $(LIBUMP_PKG_DESCRIPTION_FILE) $(LIBUMP_PKG)/.DESCRIPTION
	@cp $(LIBUMP_PKG_INSTALL_SCRIPT) $(LIBUMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUMP_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUMP_PKG_NAME)"                            >  $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUMP_PKG_VERSION)"                          >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUMP_PKG_ARCH)"                               >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUMP_PKG_DISTRO_NAME)"                  >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUMP_PKG_DISTRO_VERSION)"                >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUMP_PKG_GROUP)"                             >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUMP_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUMP_PKG_URL)"                                 >> $(LIBUMP_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUMP_PKG_LICENSE)"                         >> $(LIBUMP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBUMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
