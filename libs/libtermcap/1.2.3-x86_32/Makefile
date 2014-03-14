
COMPONENT_TARGETS  += $(TARGET_HOST)
COMPONENT_TARGETS  += $(TARGET_PC64)

NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/packages/l/termcap-compat

REQUIRES            = libs/ncurses/5.9


version             = 1.2.3
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/l/termcap-compat/termcap-compat_$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/termcap-compat-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_termcap32_pkg = $(TARGET_BUILD_DIR)/.termcap32_pkg_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TERMCAP_32_PKG_NAME                = libtermcap32
TERMCAP_32_PKG_VERSION             = 1.2.3
ifeq ($(HARDWARE),$(TARGET_HOST))
TERMCAP_32_PKG_ARCH                = $(shell uname -m)
else
TERMCAP_32_PKG_ARCH                = $(TOOLCHAIN)
endif
TERMCAP_32_PKG_DISTRO_NAME         = kxLab
TERMCAP_32_PKG_DISTRO_VERSION      = 1.0
TERMCAP_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
TERMCAP_32_PKG_SHORT_DESCRIPTION   = libtermcap32 $(version)
TERMCAP_32_PKG_URL                 = http://www.kxLab.com
TERMCAP_32_PKG_LICENSE             = GPLv2
TERMCAP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TERMCAP_32_PKG_NAME)-pkg-description
TERMCAP_32_PKG_DESCRIPTION_FILE_IN = $(TERMCAP_32_PKG_NAME)-pkg-description.in
TERMCAP_32_PKG_INSTALL_SCRIPT      = $(TERMCAP_32_PKG_NAME)-pkg-install.sh

TERMCAP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TERMCAP_32_PKG_NAME)-package

pkg_basename     = $(TERMCAP_32_PKG_NAME)-$(TERMCAP_32_PKG_VERSION)-$(TERMCAP_32_PKG_ARCH)-$(TERMCAP_32_PKG_DISTRO_NAME)-$(TERMCAP_32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(TERMCAP_32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_termcap32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


OPTIMIZATION_FLAGS = -O3

CC                += -m32

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@mkdir -p $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(SRC_DIR) ; \
	   install -m755 libtermcap.so.* $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   install -m644 libtermcap.a $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) \
	 )
	@( cd $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	@( cd $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libtermcap.so.?.?.? . ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(TERMCAP_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(TERMCAP_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(TERMCAP_32_PKG_DESCRIPTION_FILE): $(TERMCAP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_termcap32_pkg): $(install_target) $(TERMCAP_32_PKG_DESCRIPTION_FILE)
	@cp $(TERMCAP_32_PKG_DESCRIPTION_FILE) $(TERMCAP_32_PKG)/.DESCRIPTION
	@cp $(TERMCAP_32_PKG_INSTALL_SCRIPT) $(TERMCAP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TERMCAP_32_PKG)/.REQUIRES
	@echo "pkgname=$(TERMCAP_32_PKG_NAME)"                            >  $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TERMCAP_32_PKG_VERSION)"                          >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(TERMCAP_32_PKG_ARCH)"                               >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(TERMCAP_32_PKG_DISTRO_NAME)"                  >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(TERMCAP_32_PKG_DISTRO_VERSION)"                >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "group=$(TERMCAP_32_PKG_GROUP)"                             >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TERMCAP_32_PKG_SHORT_DESCRIPTION)\"" >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "url=$(TERMCAP_32_PKG_URL)"                                 >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "license=$(TERMCAP_32_PKG_LICENSE)"                         >> $(TERMCAP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TERMCAP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
