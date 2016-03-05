
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/aalib

REQUIRES          += libs/slang/2.2.4
REQUIRES          += X11/X.org/lib/libXt/1.1.4

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/aalib/aalib-1.4rc5.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/aalib-$(version)
src_dir_name       = aalib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AALIB_PKG_NAME                = aalib
AALIB_PKG_VERSION             = 1.4.0
AALIB_PKG_ARCH                = $(TOOLCHAIN)
AALIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AALIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AALIB_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
AALIB_PKG_SHORT_DESCRIPTION   = ASCII Art library
AALIB_PKG_URL                 = $(BUG_URL)
AALIB_PKG_LICENSE             = LGPLv2
AALIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AALIB_PKG_NAME)-pkg-description
AALIB_PKG_DESCRIPTION_FILE_IN = $(AALIB_PKG_NAME)-pkg-description.in
AALIB_PKG_INSTALL_SCRIPT      = $(AALIB_PKG_NAME)-pkg-install.sh

AALIB_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AALIB_PKG_NAME)-package

pkg_basename     = $(AALIB_PKG_NAME)-$(AALIB_PKG_VERSION)-$(AALIB_PKG_ARCH)-$(AALIB_PKG_DISTRO_NAME)-$(AALIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AALIB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --x-includes=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches += --x-libraries=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)
extra_configure_switches += --with-ncurses=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-curses-driver=yes

extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	# ====== Fix CFLAGS, LDFLAGS =======
	@( cd $(build_dir) ; \
	   sed -i "s,-L/usr/lib64,,g" Makefile ; \
	 )
	@( cd $(build_dir)/src ; \
	   sed -i "s,-I/usr/include,,g" Makefile ; \
	   sed -i "s,-L/usr/lib64,,g" Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AALIB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(AALIB_PKG)/usr/share/info/dir
	@gzip -9 $(AALIB_PKG)/usr/share/info/*
	@if [ -d $(AALIB_PKG)/usr/share/man ]; then \
	  ( cd $(AALIB_PKG)/usr/share/man ; \
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
	# ======= Install Documentation =======
	@mkdir -p $(AALIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(AALIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AALIB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE AUTHORS COPYING INSTALL NEWS README* \
	         $(AALIB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AALIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AALIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libaa.la \
	 )
	# ======= remove toolchain path from target aalib-config script =======
	@( cd $(AALIB_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"      aalib-config ; \
	   sed -i 's,-L/usr,-L$${exec_prefix},g' aalib-config ; \
	   sed -i "s,/lib -lncurses,/lib$(LIBSUFFIX) -lncurses,g" aalib-config ; \
	   sed -i 's,lib",lib$(LIBSUFFIX)",g'                     aalib-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AALIB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libaa.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libaa.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" aalib-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(AALIB_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(AALIB_PKG_DESCRIPTION_FILE): $(AALIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AALIB_PKG_DESCRIPTION_FILE) $(AALIB_PKG_INSTALL_SCRIPT)
	@cp $(AALIB_PKG_DESCRIPTION_FILE) $(AALIB_PKG)/.DESCRIPTION
	@cp $(AALIB_PKG_INSTALL_SCRIPT) $(AALIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AALIB_PKG)/.REQUIRES
	@echo "pkgname=$(AALIB_PKG_NAME)"                            >  $(AALIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AALIB_PKG_VERSION)"                          >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "arch=$(AALIB_PKG_ARCH)"                               >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(AALIB_PKG_DISTRO_NAME)"                  >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(AALIB_PKG_DISTRO_VERSION)"                >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "group=$(AALIB_PKG_GROUP)"                             >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AALIB_PKG_SHORT_DESCRIPTION)\"" >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "url=$(AALIB_PKG_URL)"                                 >> $(AALIB_PKG)/.PKGINFO ; \
	 echo "license=$(AALIB_PKG_LICENSE)"                         >> $(AALIB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AALIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
