
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/GNU/readline

REQUIRES             = libs/ncurses/5.9
REQUIRES            += libs/libtermcap/1.2.3


version              = 6.2
tar_gz_archive       = $(SRC_PACKAGE_PATH)/GNU/readline/readline-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/readline-$(version)
src_dir_name         = readline-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done
build_readline32_pkg = $(TARGET_BUILD_DIR)/.readline32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
READLINE32_PKG_NAME                = readline32
READLINE32_PKG_VERSION             = 6.2
READLINE32_PKG_ARCH                = $(TOOLCHAIN)
READLINE32_PKG_DISTRO_NAME         = kxLab
READLINE32_PKG_DISTRO_VERSION      = 1.0
READLINE32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
READLINE32_PKG_SHORT_DESCRIPTION   = readline32 $(version)
READLINE32_PKG_URL                 = http://www.kxLab.com
READLINE32_PKG_LICENSE             = GPLv2
READLINE32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(READLINE32_PKG_NAME)-pkg-description
READLINE32_PKG_DESCRIPTION_FILE_IN = $(READLINE32_PKG_NAME)-pkg-description.in
READLINE32_PKG_INSTALL_SCRIPT      = $(READLINE32_PKG_NAME)-pkg-install.sh

READLINE32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(READLINE32_PKG_NAME)-package

pkg_basename     = $(READLINE32_PKG_NAME)-$(READLINE32_PKG_VERSION)-$(READLINE32_PKG_ARCH)-$(READLINE32_PKG_DISTRO_NAME)-$(READLINE32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(READLINE32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_readline32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot         = DESTDIR=$(READLINE32_PKG)

OPTIMIZATION_FLAGS  = -O3

CC                 += -m32

# owerwrite LDFLAGS:
#
LDFLAGS             = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS            += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS          = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32            = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-curses
extra_configure_switches += --enable-multibyte
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes



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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) static shared
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(READLINE32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(READLINE32_PKG)/usr/bin
	@rm -rf $(READLINE32_PKG)/usr/include
	@rm -rf $(READLINE32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(READLINE32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(READLINE32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(READLINE32_PKG_DESCRIPTION_FILE): $(READLINE32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_readline32_pkg): $(install_target) $(READLINE32_PKG_DESCRIPTION_FILE)
	@cp $(READLINE32_PKG_DESCRIPTION_FILE) $(READLINE32_PKG)/.DESCRIPTION
	@cp $(READLINE32_PKG_INSTALL_SCRIPT) $(READLINE32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(READLINE32_PKG)/.REQUIRES
	@echo "pkgname=$(READLINE32_PKG_NAME)"                            >  $(READLINE32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(READLINE32_PKG_VERSION)"                          >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "arch=$(READLINE32_PKG_ARCH)"                               >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "distroname=$(READLINE32_PKG_DISTRO_NAME)"                  >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "distrover=$(READLINE32_PKG_DISTRO_VERSION)"                >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "group=$(READLINE32_PKG_GROUP)"                             >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(READLINE32_PKG_SHORT_DESCRIPTION)\"" >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "url=$(READLINE32_PKG_URL)"                                 >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "license=$(READLINE32_PKG_LICENSE)"                         >> $(READLINE32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(READLINE32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
