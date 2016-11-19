
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/botan

REQUIRES           = libs/botan/1.10.13
REQUIRES          += dev/python3/3.5.1-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 3.5


version            = 1.10.13
short_version      = $(shell echo $(version) | cut -f1,2 -d'.')
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/botan/Botan-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Botan-$(version)
src_dir_name       = Botan-$(version)
doc_dir_name       = botan-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BOTAN_32_PKG_NAME                = botan-x32
BOTAN_32_PKG_VERSION             = 1.10.13
BOTAN_32_PKG_ARCH                = $(TOOLCHAIN)
BOTAN_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BOTAN_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BOTAN_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BOTAN_32_PKG_SHORT_DESCRIPTION   = Crypto and TLS library for C++11
BOTAN_32_PKG_URL                 = $(BUG_URL)
BOTAN_32_PKG_LICENSE             = BSD
BOTAN_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BOTAN_32_PKG_NAME)-pkg-description
BOTAN_32_PKG_DESCRIPTION_FILE_IN = $(BOTAN_32_PKG_NAME)-pkg-description.in
BOTAN_32_PKG_INSTALL_SCRIPT      = $(BOTAN_32_PKG_NAME)-pkg-install.sh

BOTAN_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BOTAN_32_PKG_NAME)-package

pkg_basename     = $(BOTAN_32_PKG_NAME)-$(BOTAN_32_PKG_VERSION)-$(BOTAN_32_PKG_ARCH)-$(BOTAN_32_PKG_DISTRO_NAME)-$(BOTAN_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


extra_configure_switches  = --libdir=lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=share/doc/$(src_dir_name)
extra_configure_switches += --bindir=bin
extra_configure_switches += --os=linux

extra_configure_switches += --cpu=i486

extra_configure_switches += --cc=gcc
extra_configure_switches += --with-doxygen
extra_configure_switches += --with-python-version=$(PYTHON_VERSION)


#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


# C++ Compiler
botan_build_environment  = CXX='$(CCACHE)$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR) $(CFLAGS) -m32'

# Compiler Options
botan_build_environment += LIB_OPT='-O2 -finline-functions'
botan_build_environment += CHECK_OPT=-O2
botan_build_environment += MACH_OPT='$(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'
botan_build_environment += LANG_FLAGS='-D_REENTRANT -Wno-long-long'
botan_build_environment += WARN_FLAGS='-W -Wall'
botan_build_environment += SO_OBJ_FLAGS='-fPIC -fvisibility=hidden'
botan_build_environment += SO_LINK_CMD='$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR) -m32 \
                                        -Wl,-rpath,$(TARGET_LIB_RPATH) -shared -fPIC -Wl,-soname,$(SONAME)'
botan_build_environment += LINK_TO='-ldl -lpthread -lrt'

# Installation Settings
botan_build_environment += DESTDIR='$(BOTAN_32_PKG)/usr'
botan_build_environment += BINDIR='$(BOTAN_32_PKG)/usr/bin/32'
botan_build_environment += LIBDIR='$(BOTAN_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
botan_build_environment += HEADERDIR='$(BOTAN_32_PKG)//usr/include/botan-$(short_version)/botan'
botan_build_environment += DOCDIR='$(BOTAN_32_PKG)/usr/share/doc/botan-$(version)'
botan_build_environment += PKGCONF_DIR='$(BOTAN_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig'

# Aliases for Common Programs
botan_build_environment += AR='$(CROSS_PREFIX)ar crs'
botan_build_environment += RANLIB='$(CROSS_PREFIX)ranlib'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure.py \
	  --prefix=/usr               \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(MAKE) $(botan_build_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BOTAN_32_PKG)
	# ======= Install Botan-$(version) library =======
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(botan_build_environment)
	@rm -rf $(BOTAN_32_PKG)/usr/include
	@rm -rf $(BOTAN_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BOTAN_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" botan-$(short_version).pc ; \
	 )
	# ======= tune botan-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" botan-config-$(short_version) ; \
	 )
	# ======= Strip binaries =======
	@( cd $(BOTAN_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BOTAN_32_PKG_DESCRIPTION_FILE): $(BOTAN_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BOTAN_32_PKG_DESCRIPTION_FILE) $(BOTAN_32_PKG_INSTALL_SCRIPT)
	@cp $(BOTAN_32_PKG_DESCRIPTION_FILE) $(BOTAN_32_PKG)/.DESCRIPTION
	@cp $(BOTAN_32_PKG_INSTALL_SCRIPT) $(BOTAN_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BOTAN_32_PKG)/.REQUIRES
	@echo "pkgname=$(BOTAN_32_PKG_NAME)"                            >  $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BOTAN_32_PKG_VERSION)"                          >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BOTAN_32_PKG_ARCH)"                               >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BOTAN_32_PKG_DISTRO_NAME)"                  >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BOTAN_32_PKG_DISTRO_VERSION)"                >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "group=$(BOTAN_32_PKG_GROUP)"                             >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BOTAN_32_PKG_SHORT_DESCRIPTION)\"" >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "url=$(BOTAN_32_PKG_URL)"                                 >> $(BOTAN_32_PKG)/.PKGINFO ; \
	 echo "license=$(BOTAN_32_PKG_LICENSE)"                         >> $(BOTAN_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BOTAN_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
