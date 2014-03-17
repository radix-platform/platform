
COMPONENT_TARGETS   = $(TARGET_HOST)
COMPONENT_TARGETS  += $(TARGET_PC32)
COMPONENT_TARGETS  += $(TARGET_PC64)
COMPONENT_TARGETS  += $(TARGET_CB1X)
COMPONENT_TARGETS  += $(TARGET_VIP1830)
COMPONENT_TARGETS  += $(TARGET_BEAGLE)
COMPONENT_TARGETS  += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS  += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS  += $(TARGET_CB1N)
# COMPONENT_TARGETS  += $(TARGET_GUARD)
# COMPONENT_TARGETS  += $(TARGET_VIP1830N)
# COMPONENT_TARGETS  += $(TARGET_L17UC)
#


NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/GNU/coreutils


REQUIRES            = app/bash/4.3


version             = 8.22
tar_xz_archive      = $(SRC_PACKAGE_PATH)/GNU/coreutils/coreutils-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/coreutils-$(version)
src_dir_name        = coreutils-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

ifneq ($(filter $(HARDWARE),$(TARGET_HOST) $(TARGET_PC32) $(TARGET_PC64)),)
PATCHES = PATCHES
else
PATCHES = PATCHES.noman
endif

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_coreutils_pkg = $(TARGET_BUILD_DIR)/.coreutils_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
COREUTILS_PKG_NAME                = coreutils
COREUTILS_PKG_VERSION             = 8.22
ifeq ($(HARDWARE),$(TARGET_HOST))
COREUTILS_PKG_ARCH                = $(shell uname -m)
else
COREUTILS_PKG_ARCH                = $(TOOLCHAIN)
endif
COREUTILS_PKG_DISTRO_NAME         = kxLab
COREUTILS_PKG_DISTRO_VERSION      = 1.0
COREUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
COREUTILS_PKG_SHORT_DESCRIPTION   = coreutils $(version)
COREUTILS_PKG_URL                 = http://www.kxLab.com
COREUTILS_PKG_LICENSE             = GPLv2
COREUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(COREUTILS_PKG_NAME)-pkg-description
COREUTILS_PKG_DESCRIPTION_FILE_IN = $(COREUTILS_PKG_NAME)-pkg-description.in
COREUTILS_PKG_INSTALL_SCRIPT      = $(COREUTILS_PKG_NAME)-pkg-install.sh

COREUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(COREUTILS_PKG_NAME)-package

pkg_basename     = $(COREUTILS_PKG_NAME)-$(COREUTILS_PKG_VERSION)-$(COREUTILS_PKG_ARCH)-$(COREUTILS_PKG_DISTRO_NAME)-$(COREUTILS_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(COREUTILS_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_coreutils_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot         = DESTDIR=$(COREUTILS_PKG)

OPTIMIZATION_FLAGS  = -O3


environment  = FORCE_UNSAFE_CONFIGURE=1
environment += DEFAULT_POSIX2_VERSION=199209

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/bin
extra_configure_switches += --without-gmp


ifeq ($(filter $(HARDWARE),$(TARGET_HOST) $(TARGET_PC32) $(TARGET_PC64)),)
#extra_configure_switches += --cache-file=$(CURDIR)/cross.cache
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
#	@( cd $(SRC_DIR) ; \
#	   find . -exec touch -t 201403171037.43 {} \; \
#	 )
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(COREUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@rm -rf $(COREUTILS_PKG)/usr/share/locale/*/LC_TIME
	@mkdir -p $(COREUTILS_PKG)/bin $(COREUTILS_PKG)/usr/bin
	@( cd $(COREUTILS_PKG)/usr/bin ; \
	   for file in ../../bin/* ; do \
	     ln -sf $$file . ; \
	   done \
	 )
	@mkdir -p $(COREUTILS_PKG)/etc
	@cat $(CURDIR)/dir-colors/DIR_COLORS > $(COREUTILS_PKG)/etc/DIR_COLORS.new
	@( cd $(COREUTILS_PKG)/bin ; ln -sf install ginstall )
	@( cd $(COREUTILS_PKG)/usr/bin ; ln -sf ../../bin/ginstall ginstall )
	@( cd $(COREUTILS_PKG)/usr/share/man/man1 ; ln -sf install.1 ginstall.1 )
	# ======= Remove 'hostname', 'kill', 'su', 'uptime' =======
	@for dupe in hostname kill su uptime ; do \
	  rm -f $(COREUTILS_PKG)/bin/$$dupe $(COREUTILS_PKG)/usr/bin/$$dupe \
	        $(COREUTILS_PKG)/usr/sbin/$$dupe $(COREUTILS_PKG)/usr/share/man/man?/$$dupe.* ; \
	 done
	@rm -f $(COREUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(COREUTILS_PKG)/usr/share/info/*
	@if [ -d $(COREUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(COREUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(COREUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(COREUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL NEWS README THANKS THANKS-* TODO \
	         $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	exit 1
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(COREUTILS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(COREUTILS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@
	exit 1

$(COREUTILS_PKG_DESCRIPTION_FILE): $(COREUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_coreutils_pkg): $(install_target) $(COREUTILS_PKG_DESCRIPTION_FILE)
	@cp $(COREUTILS_PKG_DESCRIPTION_FILE) $(COREUTILS_PKG)/.DESCRIPTION
	@cp $(COREUTILS_PKG_INSTALL_SCRIPT) $(COREUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(COREUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(COREUTILS_PKG_NAME)"                            >  $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(COREUTILS_PKG_VERSION)"                          >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(COREUTILS_PKG_ARCH)"                               >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(COREUTILS_PKG_DISTRO_NAME)"                  >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(COREUTILS_PKG_DISTRO_VERSION)"                >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(COREUTILS_PKG_GROUP)"                             >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(COREUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(COREUTILS_PKG_URL)"                                 >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(COREUTILS_PKG_LICENSE)"                         >> $(COREUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(COREUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
