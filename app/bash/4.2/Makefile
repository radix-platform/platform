
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/bash

REQUIRES           = libs/readline/6.2
REQUIRES          += app/gettext/0.19.7

# ======= __END_OF_REQUIRES__ =======


version            = 4.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/bash/bash-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bash-$(version)
src_dir_name       = bash-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BASH_PKG_NAME                = bash
BASH_PKG_VERSION             = 4.2
BASH_PKG_ARCH                = $(TOOLCHAIN)
BASH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BASH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BASH_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
BASH_PKG_SHORT_DESCRIPTION   = Bourne-Again SHell
BASH_PKG_URL                 = $(BUG_URL)
BASH_PKG_LICENSE             = GPLv2
BASH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BASH_PKG_NAME)-pkg-description
BASH_PKG_DESCRIPTION_FILE_IN = $(BASH_PKG_NAME)-pkg-description.in
BASH_PKG_INSTALL_SCRIPT      = $(BASH_PKG_NAME)-pkg-install.sh

BASH_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BASH_PKG_NAME)-package

pkg_basename     = $(BASH_PKG_NAME)-$(BASH_PKG_VERSION)-$(BASH_PKG_ARCH)-$(BASH_PKG_DISTRO_NAME)-$(BASH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BASH_PKG)


ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
# NOTE: MULTILIB_X86_32_SUFFIX related to bulld machine
#       (slacware64 - lib; ununtu64 - lib32) see $(BUILDSYSTEM)/targets.mk
environment  = CPPFLAGS_FOR_BUILD="-I/usr/include"
environment += CFLAGS_FOR_BUILD="-m32 -I/usr/include"
environment += LDFLAGS_FOR_BUILD="-m32 -L/usr/lib$(BUILD_MULTILIB_X86_32_SUFFIX)"
endif

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-readline
extra_configure_switches += --with-installed-readline=$(TARGET_DEST_DIR)/usr


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BASH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(BASH_PKG)/etc
	@mkdir -p $(BASH_PKG)/bin
	@mv $(BASH_PKG)/usr/bin/bash $(BASH_PKG)/bin/bash4.new
	@rm -rf $(BASH_PKG)/usr/bin $(BASH_PKG)/usr/share/man/man1/bashbug.1
	@mkdir -p $(BASH_PKG)/usr/bin
	# ======= Install Documentation =======
	@cp -a $(SRC_DIR)/doc/builtins.1 $(BASH_PKG)/usr/share/man/man1
	@cp -a $(SRC_DIR)/doc/rbash.1 $(BASH_PKG)/usr/share/man/man1
	@rm -f $(BASH_PKG)/usr/share/info/dir
	@gzip -9 $(BASH_PKG)/usr/share/info/*
	@if [ -d $(BASH_PKG)/usr/share/man ]; then \
	  ( cd $(BASH_PKG)/usr/share/man ; \
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
	@mkdir -p $(BASH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(BASH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BASH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL MANIFEST NOTES Y2K \
	         doc/article.pdf doc/bash.pdf doc/bashref.pdf doc/rose94.pdf \
	         $(BASH_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BASH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BASH_PKG))
	@( cd $(TARGET_DEST_DIR) ; \
	   mv bin/bash4.new bin/bash ; \
	   ( cd usr/bin ; ln -sf ../../bin/bash bash ) \
	 )
	# ======= Strip binaries =======
	@( cd $(BASH_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(BASH_PKG_DESCRIPTION_FILE): $(BASH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BASH_PKG_DESCRIPTION_FILE) $(BASH_PKG_INSTALL_SCRIPT)
	@cp $(BASH_PKG_DESCRIPTION_FILE) $(BASH_PKG)/.DESCRIPTION
	@cp $(BASH_PKG_INSTALL_SCRIPT) $(BASH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BASH_PKG)/.REQUIRES
	@echo "pkgname=$(BASH_PKG_NAME)"                            >  $(BASH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BASH_PKG_VERSION)"                          >> $(BASH_PKG)/.PKGINFO ; \
	 echo "arch=$(BASH_PKG_ARCH)"                               >> $(BASH_PKG)/.PKGINFO ; \
	 echo "distroname=$(BASH_PKG_DISTRO_NAME)"                  >> $(BASH_PKG)/.PKGINFO ; \
	 echo "distrover=$(BASH_PKG_DISTRO_VERSION)"                >> $(BASH_PKG)/.PKGINFO ; \
	 echo "group=$(BASH_PKG_GROUP)"                             >> $(BASH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BASH_PKG_SHORT_DESCRIPTION)\"" >> $(BASH_PKG)/.PKGINFO ; \
	 echo "url=$(BASH_PKG_URL)"                                 >> $(BASH_PKG)/.PKGINFO ; \
	 echo "license=$(BASH_PKG_LICENSE)"                         >> $(BASH_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BASH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
