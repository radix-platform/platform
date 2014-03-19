
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires zlib libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/linuxconsole


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES              = app/inputattach/1.4.7-x86_32
else
REQUIRES              = libs/eglibc/2.18.1
endif

version               = 1.4.7
tar_bz2_archive       = $(SRC_PACKAGE_PATH)/packages/a/linuxconsole/linuxconsoletools-$(version).tar.bz2
SRC_ARCHIVE           = $(tar_bz2_archive)
SRC_DIR               = $(TARGET_BUILD_DIR)/linuxconsoletools-$(version)
src_done              = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target          = $(TARGET_BUILD_DIR)/.build_done
install_target        = $(TARGET_BUILD_DIR)/.install_done
build_inputattach_pkg = $(TARGET_BUILD_DIR)/.inputattach_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
INPUTATTACH_PKG_NAME                = inputattach
INPUTATTACH_PKG_VERSION             = 1.4.7
INPUTATTACH_PKG_ARCH                = $(TOOLCHAIN)
INPUTATTACH_PKG_DISTRO_NAME         = kxLab
INPUTATTACH_PKG_DISTRO_VERSION      = 1.0
INPUTATTACH_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
INPUTATTACH_PKG_SHORT_DESCRIPTION   = inputattach $(version)
INPUTATTACH_PKG_URL                 = http://www.kxLab.com
INPUTATTACH_PKG_LICENSE             = GPLv2
INPUTATTACH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INPUTATTACH_PKG_NAME)-pkg-description
INPUTATTACH_PKG_DESCRIPTION_FILE_IN = $(INPUTATTACH_PKG_NAME)-pkg-description.in
INPUTATTACH_PKG_INSTALL_SCRIPT      = $(INPUTATTACH_PKG_NAME)-pkg-install.sh

INPUTATTACH_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(INPUTATTACH_PKG_NAME)-package

pkg_basename     = $(INPUTATTACH_PKG_NAME)-$(INPUTATTACH_PKG_VERSION)-$(INPUTATTACH_PKG_ARCH)-$(INPUTATTACH_PKG_DISTRO_NAME)-$(INPUTATTACH_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(INPUTATTACH_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_inputattach_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


OPTIMIZATION_FLAGS = -O3


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/utils && $(BUILD_ENVIRONMENT) $(CC) inputattach.c -o inputattach
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(INPUTATTACH_PKG)/usr/bin
	@cd $(SRC_DIR)/utils && cp -a inputattach $(INPUTATTACH_PKG)/usr/bin
	@chmod 755 $(INPUTATTACH_PKG)/usr/bin/*
	@mkdir -p $(INPUTATTACH_PKG)/usr/share/man/man1
	@cd $(SRC_DIR)/docs && cp -a inputattach.1 $(INPUTATTACH_PKG)/usr/share/man/man1
	@chmod 644 $(INPUTATTACH_PKG)/usr/share/man/man1/inputattach.1
	@if [ -d $(INPUTATTACH_PKG)/usr/share/man ]; then \
	  ( cd $(INPUTATTACH_PKG)/usr/share/man ; \
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
	@mkdir -p $(INPUTATTACH_PKG)/usr/doc/inputattach-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(INPUTATTACH_PKG)/usr/doc/inputattach-$(version) \
	 )
	@mkdir -p $(INPUTATTACH_PKG)/usr/share/doc/inputattach-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a NEWS README utils/serio-ids.h \
	         $(INPUTATTACH_PKG)/usr/share/doc/inputattach-$(version) \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(INPUTATTACH_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(INPUTATTACH_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(INPUTATTACH_PKG_DESCRIPTION_FILE): $(INPUTATTACH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_inputattach_pkg): $(install_target) $(INPUTATTACH_PKG_DESCRIPTION_FILE)
	@cp $(INPUTATTACH_PKG_DESCRIPTION_FILE) $(INPUTATTACH_PKG)/.DESCRIPTION
	@cp $(INPUTATTACH_PKG_INSTALL_SCRIPT) $(INPUTATTACH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(INPUTATTACH_PKG)/.REQUIRES
	@echo "pkgname=$(INPUTATTACH_PKG_NAME)"                            >  $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INPUTATTACH_PKG_VERSION)"                          >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "arch=$(INPUTATTACH_PKG_ARCH)"                               >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "distroname=$(INPUTATTACH_PKG_DISTRO_NAME)"                  >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "distrover=$(INPUTATTACH_PKG_DISTRO_VERSION)"                >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "group=$(INPUTATTACH_PKG_GROUP)"                             >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INPUTATTACH_PKG_SHORT_DESCRIPTION)\"" >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "url=$(INPUTATTACH_PKG_URL)"                                 >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "license=$(INPUTATTACH_PKG_LICENSE)"                         >> $(INPUTATTACH_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(INPUTATTACH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
