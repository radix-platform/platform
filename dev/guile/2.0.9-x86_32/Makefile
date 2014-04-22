
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/guile

REQUIRES           = libs/eglibc/2.18.1
REQUIRES          += libs/libffi/3.0.13
REQUIRES          += libs/gmp/5.1.3
REQUIRES          += libs/readline/6.3
REQUIRES          += libs/ncurses/5.9
REQUIRES          += dev/libtool/2.4.2
REQUIRES          += libs/libunistring/0.9.3
REQUIRES          += libs/gc/7.2d


version            = 2.0.9
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/guile/guile-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/guile-$(version)
src_dir_name       = guile-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_guile32_pkg  = $(TARGET_BUILD_DIR)/.guile32_pkg_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GUILE32_PKG_NAME                = guile32
GUILE32_PKG_VERSION             = 2.0.9
GUILE32_PKG_ARCH                = $(TOOLCHAIN)
GUILE32_PKG_DISTRO_NAME         = kxLab
GUILE32_PKG_DISTRO_VERSION      = 1.0
GUILE32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GUILE32_PKG_SHORT_DESCRIPTION   = guile32 $(version)
GUILE32_PKG_URL                 = http://www.kxLab.com
GUILE32_PKG_LICENSE             = GPLv2
GUILE32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GUILE32_PKG_NAME)-pkg-description
GUILE32_PKG_DESCRIPTION_FILE_IN = $(GUILE32_PKG_NAME)-pkg-description.in
GUILE32_PKG_INSTALL_SCRIPT      = $(GUILE32_PKG_NAME)-pkg-install.sh

GUILE32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GUILE32_PKG_NAME)-package

pkg_basename     = $(GUILE32_PKG_NAME)-$(GUILE32_PKG_VERSION)-$(GUILE32_PKG_ARCH)-$(GUILE32_PKG_DISTRO_NAME)-$(GUILE32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GUILE32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_guile32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GUILE32_PKG)


CC          += -m32

# overwrite PKG_CONFIG_PATH:
#
PKG_CONFIG_PATH = $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig

# overwrite LDFLAGS:
#
LDFLAGS      = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS     += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O2 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-threads
extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-error-on-warning
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


GUILE_LOAD_PATH   = ../../$(src_dir_name)/module
guile_environment = GUILE_LOAD_PATH=$(GUILE_LOAD_PATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GUILE32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(GUILE32_PKG)/usr/bin/32
	@( cd $(GUILE32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	@rm -rf $(GUILE32_PKG)/usr/include
	@rm -rf $(GUILE32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(GUILE32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	@( cd $(GUILE32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,-L/lib ,,g" libguile-?.?.la libguilereadline-v-??.la ; \
	  sed -i "s,-L/usr/lib ,,g" libguile-?.?.la libguilereadline-v-??.la ; \
	 )
	@( cd $(GUILE32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" guile-?.?.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GUILE32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libguile-?.?.la libguilereadline-v-??.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" guile-?.?.pc ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" guile-?.?.pc \
	 )
	# tune guile-snarf for target system
	@( cd $(GUILE32_PKG)/usr/bin/32 ; \
	  sed -i "s,\"/opt/toolchain/.*\",\"gcc -m32 -E\",g" guile-snarf ; \
	 )
	@( cd $(GUILE32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GUILE32_PKG_DESCRIPTION_FILE): $(GUILE32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_guile32_pkg): $(install_target) $(GUILE32_PKG_DESCRIPTION_FILE)
	@cp $(GUILE32_PKG_DESCRIPTION_FILE) $(GUILE32_PKG)/.DESCRIPTION
	@cp $(GUILE32_PKG_INSTALL_SCRIPT) $(GUILE32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GUILE32_PKG)/.REQUIRES
	@echo "pkgname=$(GUILE32_PKG_NAME)"                            >  $(GUILE32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GUILE32_PKG_VERSION)"                          >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "arch=$(GUILE32_PKG_ARCH)"                               >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GUILE32_PKG_DISTRO_NAME)"                  >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GUILE32_PKG_DISTRO_VERSION)"                >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "group=$(GUILE32_PKG_GROUP)"                             >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GUILE32_PKG_SHORT_DESCRIPTION)\"" >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "url=$(GUILE32_PKG_URL)"                                 >> $(GUILE32_PKG)/.PKGINFO ; \
	 echo "license=$(GUILE32_PKG_LICENSE)"                         >> $(GUILE32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GUILE32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
