
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/bzip2

REQUIRES           = libs/eglibc/2.18.1


version            = 1.0.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/bzip2/bzip2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bzip2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_bzip2x32_pkg = $(TARGET_BUILD_DIR)/.bzip2x32_pkg_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BZIP2_32_PKG_NAME                = bzip2x32
BZIP2_32_PKG_VERSION             = 1.0.6
ifeq ($(HARDWARE),$(TARGET_HOST))
BZIP2_32_PKG_ARCH                = $(shell uname -m)
else
BZIP2_32_PKG_ARCH                = $(TOOLCHAIN)
endif
BZIP2_32_PKG_DISTRO_NAME         = kxLab
BZIP2_32_PKG_DISTRO_VERSION      = 1.0
BZIP2_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BZIP2_32_PKG_SHORT_DESCRIPTION   = bzip2x32 $(version)
BZIP2_32_PKG_URL                 = http://www.kxLab.com
BZIP2_32_PKG_LICENSE             = GPLv2
BZIP2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BZIP2_32_PKG_NAME)-pkg-description
BZIP2_32_PKG_DESCRIPTION_FILE_IN = $(BZIP2_32_PKG_NAME)-pkg-description.in
BZIP2_32_PKG_INSTALL_SCRIPT      = $(BZIP2_32_PKG_NAME)-pkg-install.sh

BZIP2_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BZIP2_32_PKG_NAME)-package

pkg_basename     = $(BZIP2_32_PKG_NAME)-$(BZIP2_32_PKG_VERSION)-$(BZIP2_32_PKG_ARCH)-$(BZIP2_32_PKG_DISTRO_NAME)-$(BZIP2_32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(BZIP2_32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_bzip2x32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


OPTIMIZATION_FLAGS = -O3

CC                += -m32

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
else
LIBSUFFIX          =
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -f Makefile-libbz2_so
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BZIP2_32_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && cp -a libbz2.a $(BZIP2_32_PKG)/usr/lib$(LIBSUFFIX)
	@chmod 644 $(BZIP2_32_PKG)/usr/lib$(LIBSUFFIX)/libbz2.a 
	@mkdir -p $(BZIP2_32_PKG)/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && cp -a libbz2.so.$(version) $(BZIP2_32_PKG)/lib$(LIBSUFFIX)
	@chmod 755 $(BZIP2_32_PKG)/lib$(LIBSUFFIX)/libbz2.so.$(version)
	@mkdir -p $(BZIP2_32_PKG)/bin/32
	@mkdir -p $(BZIP2_32_PKG)/usr/bin/32
	@cd $(SRC_DIR) && cat bzip2-shared > $(BZIP2_32_PKG)/bin/32/bzip2
	@cd $(SRC_DIR) && cat bzip2recover > $(BZIP2_32_PKG)/bin/32/bzip2recover
	@chmod 755 $(BZIP2_32_PKG)/bin/32/bzip2
	@chmod 755 $(BZIP2_32_PKG)/bin/32/bzip2recover
	@( cd $(BZIP2_32_PKG)/lib$(LIBSUFFIX) ; \
	   rm -f libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 \
	 )
	@( cd $(BZIP2_32_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libbz2.so.$(version) libbz2.so.$(version) ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.1 libbz2.so \
	 )
	@( cd $(BZIP2_32_PKG)/bin/32 ; \
	   ln -sf bzip2 bunzip2 ; \
	   ln -sf bzip2 bzcat \
	 )
	@( cd $(BZIP2_32_PKG)/usr/bin/32 ; \
	   ln -sf ../../../bin/32/bzip2 . ; \
	   ln -sf ../../../bin/32/bzip2 bunzip2 ; \
	   ln -sf ../../../bin/32/bzip2 bzcat \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(BZIP2_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(BZIP2_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BZIP2_32_PKG_DESCRIPTION_FILE): $(BZIP2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_bzip2x32_pkg): $(install_target) $(BZIP2_32_PKG_DESCRIPTION_FILE)
	@cp $(BZIP2_32_PKG_DESCRIPTION_FILE) $(BZIP2_32_PKG)/.DESCRIPTION
	@cp $(BZIP2_32_PKG_INSTALL_SCRIPT) $(BZIP2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BZIP2_32_PKG)/.REQUIRES
	@echo "pkgname=$(BZIP2_32_PKG_NAME)"                            >  $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BZIP2_32_PKG_VERSION)"                          >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BZIP2_32_PKG_ARCH)"                               >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BZIP2_32_PKG_DISTRO_NAME)"                  >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BZIP2_32_PKG_DISTRO_VERSION)"                >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "group=$(BZIP2_32_PKG_GROUP)"                             >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BZIP2_32_PKG_SHORT_DESCRIPTION)\"" >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "url=$(BZIP2_32_PKG_URL)"                                 >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "license=$(BZIP2_32_PKG_LICENSE)"                         >> $(BZIP2_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BZIP2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
