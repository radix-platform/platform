
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/gamin

REQUIRES           = libs/libgamin/0.1.10
REQUIRES          += dev/python2/2.7.11-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/gamin/gamin-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gamin-$(version)
src_dir_name       = gamin-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(CURDIR)/$(build_dir)/hw.cache


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GAMIN32_PKG_NAME                = libgamin-x32
GAMIN32_PKG_VERSION             = 0.1.10
GAMIN32_PKG_ARCH                = $(TOOLCHAIN)
GAMIN32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GAMIN32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GAMIN32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GAMIN32_PKG_SHORT_DESCRIPTION   = fam/gamin x86_32 libraries for Gamin
GAMIN32_PKG_URL                 = $(BUG_URL)
GAMIN32_PKG_LICENSE             = GPLv2
GAMIN32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GAMIN32_PKG_NAME)-pkg-description
GAMIN32_PKG_DESCRIPTION_FILE_IN = $(GAMIN32_PKG_NAME)-pkg-description.in
GAMIN32_PKG_INSTALL_SCRIPT      = $(GAMIN32_PKG_NAME)-pkg-install.sh

GAMIN32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GAMIN32_PKG_NAME)-package

pkg_basename     = $(GAMIN32_PKG_NAME)-$(GAMIN32_PKG_VERSION)-$(GAMIN32_PKG_ARCH)-$(GAMIN32_PKG_DISTRO_NAME)-$(GAMIN32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GAMIN32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-server

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-inotify
extra_configure_switches += --disable-dnotify

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --cache-file=$(hw_cache)


#
# Python Configuration:
#
PYTHON_MAJOR_VERSION = 2

ifeq ($(PYTHON_MAJOR_VERSION),3)
PYTHON_VERSION = 3.5
extra_configure_switches += --with-python=$(PYTHON3)

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
endif

ifeq ($(PYTHON_MAJOR_VERSION),2)
PYTHON_VERSION = 2.7
extra_configure_switches += --with-python=$(PYTHON2)

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
endif


CFLAGS += -Wno-address -Wno-unused-variable


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cp -a $(hw_cache_in) $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GAMIN32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GAMIN32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GAMIN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfam.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgamin-1.la  \
	 )
	@( cd $(GAMIN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _gamin.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GAMIN32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfam.la ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgamin-1.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfam.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgamin-1.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gamin.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gamin.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gamin.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GAMIN32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GAMIN32_PKG_DESCRIPTION_FILE): $(GAMIN32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GAMIN32_PKG_DESCRIPTION_FILE) $(GAMIN32_PKG_INSTALL_SCRIPT)
	@cp $(GAMIN32_PKG_DESCRIPTION_FILE) $(GAMIN32_PKG)/.DESCRIPTION
	@cp $(GAMIN32_PKG_INSTALL_SCRIPT) $(GAMIN32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GAMIN32_PKG)/.REQUIRES
	@echo "pkgname=$(GAMIN32_PKG_NAME)"                            >  $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GAMIN32_PKG_VERSION)"                          >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "arch=$(GAMIN32_PKG_ARCH)"                               >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GAMIN32_PKG_DISTRO_NAME)"                  >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GAMIN32_PKG_DISTRO_VERSION)"                >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "group=$(GAMIN32_PKG_GROUP)"                             >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GAMIN32_PKG_SHORT_DESCRIPTION)\"" >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "url=$(GAMIN32_PKG_URL)"                                 >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "license=$(GAMIN32_PKG_LICENSE)"                         >> $(GAMIN32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GAMIN32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
