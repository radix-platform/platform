
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/bzip2

REQUIRES           = libs/eglibc/2.19.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/bzip2/bzip2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bzip2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BZIP2_PKG_NAME                = bzip2
BZIP2_PKG_VERSION             = 1.0.6
BZIP2_PKG_ARCH                = $(TOOLCHAIN)
BZIP2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BZIP2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BZIP2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BZIP2_PKG_SHORT_DESCRIPTION   = block-sorting file compressor
BZIP2_PKG_URL                 = $(BUG_URL)
BZIP2_PKG_LICENSE             = GPLv2
BZIP2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BZIP2_PKG_NAME)-pkg-description
BZIP2_PKG_DESCRIPTION_FILE_IN = $(BZIP2_PKG_NAME)-pkg-description.in
BZIP2_PKG_INSTALL_SCRIPT      = $(BZIP2_PKG_NAME)-pkg-install.sh

BZIP2_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BZIP2_PKG_NAME)-package

pkg_basename     = $(BZIP2_PKG_NAME)-$(BZIP2_PKG_VERSION)-$(BZIP2_PKG_ARCH)-$(BZIP2_PKG_DISTRO_NAME)-$(BZIP2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk



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
	@mkdir -p $(BZIP2_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && cp -a libbz2.a $(BZIP2_PKG)/usr/lib$(LIBSUFFIX)
	@chmod 644 $(BZIP2_PKG)/usr/lib$(LIBSUFFIX)/libbz2.a 
	@mkdir -p $(BZIP2_PKG)/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && cp -a libbz2.so.$(version) $(BZIP2_PKG)/lib$(LIBSUFFIX)
	@chmod 755 $(BZIP2_PKG)/lib$(LIBSUFFIX)/libbz2.so.$(version)
	@mkdir -p $(BZIP2_PKG)/bin
	@mkdir -p $(BZIP2_PKG)/usr/bin
	@cd $(SRC_DIR) && cat bzip2-shared > $(BZIP2_PKG)/bin/bzip2
	@cd $(SRC_DIR) && cat bzip2recover > $(BZIP2_PKG)/bin/bzip2recover
	@chmod 755 $(BZIP2_PKG)/bin/bzip2
	@chmod 755 $(BZIP2_PKG)/bin/bzip2recover

	@( cd $(SRC_DIR) ; \
	   for file in bzdiff bzgrep bzmore ; do \
	     cat $$file > $(BZIP2_PKG)/usr/bin/$$file ; \
	     chmod 755 $(BZIP2_PKG)/usr/bin/$$file ; \
	   done \
	 )
	@( cd $(BZIP2_PKG)/lib$(LIBSUFFIX) ; \
	   rm -f libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 \
	 )
	@( cd $(BZIP2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libbz2.so.$(version) libbz2.so.$(version) ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.1 libbz2.so \
	 )
	@( cd $(BZIP2_PKG)/bin ; \
	   ln -sf bzip2 bunzip2 ; \
	   ln -sf bzip2 bzcat \
	 )
	@( cd $(BZIP2_PKG)/usr/bin ; \
	   ln -sf ../../bin/bzip2 . ; \
	   ln -sf ../../bin/bzip2 bunzip2 ; \
	   ln -sf ../../bin/bzip2 bzcat ; \
	   ln -sf bzmore bzless \
	 )
	@mkdir -p $(BZIP2_PKG)/usr/include
	@cd $(SRC_DIR) && cp -a bzlib.h $(BZIP2_PKG)/usr/include/bzlib.h
	@chmod 644 $(BZIP2_PKG)/usr/include/bzlib.h
	# ======= Install Documentation =======
	@mkdir -p $(BZIP2_PKG)/usr/share/man/man1
	@( cd $(SRC_DIR) ; \
	   for file in bzdiff.1 bzgrep.1 bzip2.1 bzmore.1 ; do \
	     cat $$file | gzip -9c > $(BZIP2_PKG)/usr/share/man/man1/$$file.gz ; \
	   done ; \
	   cat bzip2.1 | gzip -9c > $(BZIP2_PKG)/usr/share/man/man1/bzip2recover.gz \
	 )
	@mkdir -p $(BZIP2_PKG)/usr/doc/bzip2-$(version)
	@mkdir -p $(BZIP2_PKG)/usr/share/doc/bzip2-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE $(BZIP2_PKG)/usr/doc/bzip2-$(version) \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGES LICENSE README* bzip.css bzip2.txt entities.xml manual.* \
	         $(BZIP2_PKG)/usr/share/doc/bzip2-$(version) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(BZIP2_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(BZIP2_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BZIP2_PKG_DESCRIPTION_FILE): $(BZIP2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BZIP2_PKG_DESCRIPTION_FILE) $(BZIP2_PKG_INSTALL_SCRIPT)
	@cp $(BZIP2_PKG_DESCRIPTION_FILE) $(BZIP2_PKG)/.DESCRIPTION
	@cp $(BZIP2_PKG_INSTALL_SCRIPT) $(BZIP2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BZIP2_PKG)/.REQUIRES
	@echo "pkgname=$(BZIP2_PKG_NAME)"                            >  $(BZIP2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BZIP2_PKG_VERSION)"                          >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "arch=$(BZIP2_PKG_ARCH)"                               >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "distroname=$(BZIP2_PKG_DISTRO_NAME)"                  >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "distrover=$(BZIP2_PKG_DISTRO_VERSION)"                >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "group=$(BZIP2_PKG_GROUP)"                             >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BZIP2_PKG_SHORT_DESCRIPTION)\"" >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "url=$(BZIP2_PKG_URL)"                                 >> $(BZIP2_PKG)/.PKGINFO ; \
	 echo "license=$(BZIP2_PKG_LICENSE)"                         >> $(BZIP2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BZIP2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
