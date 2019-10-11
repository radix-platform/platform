
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/guile

REQUIRES           = dev/guile/2.0.11
REQUIRES          += libs/libffi/3.2.1-x86_32
REQUIRES          += libs/gmp/6.1.2-x86_32
REQUIRES          += libs/readline/8.0-x86_32
REQUIRES          += dev/libtool/2.4.6-x86_32
REQUIRES          += libs/libunistring/0.9.10-x86_32
REQUIRES          += libs/gc/8.0.4-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.11
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/guile/guile-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/guile-$(version)
src_dir_name       = guile-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

guile_for_build    = $(TARGET_BUILD_DIR)/guile-for-build


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GUILE_32_PKG_NAME                = guile-x32
GUILE_32_PKG_VERSION             = 2.0.11
GUILE_32_PKG_ARCH                = $(TOOLCHAIN)
GUILE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GUILE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GUILE_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GUILE_32_PKG_SHORT_DESCRIPTION   = GNU extension language library
GUILE_32_PKG_URL                 = $(BUG_URL)
GUILE_32_PKG_LICENSE             = GPLv2
GUILE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GUILE_32_PKG_NAME)-pkg-description
GUILE_32_PKG_DESCRIPTION_FILE_IN = $(GUILE_32_PKG_NAME)-pkg-description.in
GUILE_32_PKG_INSTALL_SCRIPT      = $(GUILE_32_PKG_NAME)-pkg-install.sh

GUILE_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GUILE_32_PKG_NAME)-package

pkg_basename     = $(GUILE_32_PKG_NAME)-$(GUILE_32_PKG_VERSION)-$(GUILE_32_PKG_ARCH)-$(GUILE_32_PKG_DISTRO_NAME)-$(GUILE_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GUILE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-threads
extra_configure_switches += --disable-error-on-warning
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

# Тhе road to hellis paved with good intentions:
extra_configure_switches += --without-libgmp-prefix
extra_configure_switches += --without-libiconv-prefix
extra_configure_switches += --without-libintl-prefix
extra_configure_switches += --without-libltdl-prefix
extra_configure_switches += --without-libreadline-prefix
extra_configure_switches += --without-libunistring-prefix


GUILE_LOAD_PATH    = ../../$(src_dir_name)/module
guile_environment  = GUILE_LOAD_PATH=$(GUILE_LOAD_PATH)

guile_environment += GUILE_FOR_BUILD=$(CURDIR)/$(guile_for_build)/meta/guile
guile_environment += CC_FOR_BUILD=gcc


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	# ======= Guile For Build =======
	@mkdir -p $(guile_for_build)
	@( cd $(guile_for_build) ; \
	   PKG_CONFIG_LIBDIR= \
	   PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig \
	   ../$(src_dir_name)/configure --prefix=/usr --libdir=/usr/lib$(BUILD_MULTILIB_SUFFIX) ; \
	   make ; \
	 )
	# ======= Guile For Target =======
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GUILE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Remove debugging script to avoid ldconfig errors =======
	@rm -f $(GUILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libguile-*-gdb.scm
	@mkdir -p $(GUILE_32_PKG)/usr/bin/32
	@( cd $(GUILE_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	@rm -rf $(GUILE_32_PKG)/usr/include
	@rm -rf $(GUILE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GUILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	@( cd $(GUILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,-L/lib ,,g" libguile-?.?.la libguilereadline-v-??.la ; \
	   sed -i "s,-L/usr/lib ,,g" libguile-?.?.la libguilereadline-v-??.la ; \
	 )
	@( cd $(GUILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" guile-?.?.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GUILE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libguile-?.?.la libguilereadline-v-??.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" guile-?.?.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" guile-?.?.pc \
	 )
	# ======= tune guile-snarf for target system =======
	@( cd $(GUILE_32_PKG)/usr/bin/32 ; \
	   sed -i "s,\"/opt/toolchain/.*\",\"gcc -m32 -E\",g" guile-snarf ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GUILE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GUILE_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GUILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GUILE_32_PKG_DESCRIPTION_FILE): $(GUILE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GUILE_32_PKG_DESCRIPTION_FILE) $(GUILE_32_PKG_INSTALL_SCRIPT)
	@cp $(GUILE_32_PKG_DESCRIPTION_FILE) $(GUILE_32_PKG)/.DESCRIPTION
	@cp $(GUILE_32_PKG_INSTALL_SCRIPT) $(GUILE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GUILE_32_PKG)/.REQUIRES
	@echo "pkgname=$(GUILE_32_PKG_NAME)"                            >  $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GUILE_32_PKG_VERSION)"                          >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GUILE_32_PKG_ARCH)"                               >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GUILE_32_PKG_DISTRO_NAME)"                  >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GUILE_32_PKG_DISTRO_VERSION)"                >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "group=$(GUILE_32_PKG_GROUP)"                             >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GUILE_32_PKG_SHORT_DESCRIPTION)\"" >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "url=$(GUILE_32_PKG_URL)"                                 >> $(GUILE_32_PKG)/.PKGINFO ; \
	 echo "license=$(GUILE_32_PKG_LICENSE)"                         >> $(GUILE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GUILE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
