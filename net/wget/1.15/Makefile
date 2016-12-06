
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/wget

REQUIRES           = app/util-linux/2.24.1
REQUIRES          += libs/libidn/1.28
REQUIRES          += libs/pcre/8.38
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += net/ca-certificates/45.0.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.15
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/wget/wget-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/wget-$(version)
src_dir_name       = wget-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WGET_PKG_NAME                = wget
WGET_PKG_VERSION             = 1.15
WGET_PKG_ARCH                = $(TOOLCHAIN)
WGET_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WGET_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WGET_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
WGET_PKG_SHORT_DESCRIPTION   = a non-interactive network retriever
WGET_PKG_URL                 = $(BUG_URL)
WGET_PKG_LICENSE             = GPLv3
WGET_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WGET_PKG_NAME)-pkg-description
WGET_PKG_DESCRIPTION_FILE_IN = $(WGET_PKG_NAME)-pkg-description.in
WGET_PKG_INSTALL_SCRIPT      = $(WGET_PKG_NAME)-pkg-install.sh

WGET_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WGET_PKG_NAME)-package

pkg_basename     = $(WGET_PKG_NAME)-$(WGET_PKG_VERSION)-$(WGET_PKG_ARCH)-$(WGET_PKG_DISTRO_NAME)-$(WGET_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(WGET_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-ssl=openssl
extra_configure_switches += --with-openssl

extra_configure_switches += --with-libssl-prefix=$(TARGET_DEST_DIR)
extra_configure_switches += --with-gnutls-prefix=$(TARGET_DEST_DIR)
extra_configure_switches += --with-libpth-prefix=$(TARGET_DEST_DIR)
extra_configure_switches += --with-libidn=yes

extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WGET_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mv $(WGET_PKG)/etc/wgetrc $(WGET_PKG)/etc/wgetrc.new
	# ======= Install Documentation =======
	@rm -f $(WGET_PKG)/usr/share/info/dir
	@gzip -9 $(WGET_PKG)/usr/share/info/*
	@if [ -d $(WGET_PKG)/usr/share/man ]; then \
	  ( cd $(WGET_PKG)/usr/share/man ; \
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
	@mkdir -p $(WGET_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(WGET_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WGET_PKG)/usr/share/doc/$(src_dir_name)/util
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL MAILING-LIST NEWS README \
	         $(WGET_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a util/README util/rmold.pl util/trunc.c \
	         $(WGET_PKG)/usr/share/doc/$(src_dir_name)/util ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WGET_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WGET_PKG))
	# ======= Strip binaries =======
	@( cd $(WGET_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(WGET_PKG_DESCRIPTION_FILE): $(WGET_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WGET_PKG_DESCRIPTION_FILE) $(WGET_PKG_INSTALL_SCRIPT)
	@cp $(WGET_PKG_DESCRIPTION_FILE) $(WGET_PKG)/.DESCRIPTION
	@cp $(WGET_PKG_INSTALL_SCRIPT) $(WGET_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WGET_PKG)/.REQUIRES
	@echo "pkgname=$(WGET_PKG_NAME)"                            >  $(WGET_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WGET_PKG_VERSION)"                          >> $(WGET_PKG)/.PKGINFO ; \
	 echo "arch=$(WGET_PKG_ARCH)"                               >> $(WGET_PKG)/.PKGINFO ; \
	 echo "distroname=$(WGET_PKG_DISTRO_NAME)"                  >> $(WGET_PKG)/.PKGINFO ; \
	 echo "distrover=$(WGET_PKG_DISTRO_VERSION)"                >> $(WGET_PKG)/.PKGINFO ; \
	 echo "group=$(WGET_PKG_GROUP)"                             >> $(WGET_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WGET_PKG_SHORT_DESCRIPTION)\"" >> $(WGET_PKG)/.PKGINFO ; \
	 echo "url=$(WGET_PKG_URL)"                                 >> $(WGET_PKG)/.PKGINFO ; \
	 echo "license=$(WGET_PKG_LICENSE)"                         >> $(WGET_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WGET_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
