
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libieee1284

REQUIRES           = libs/libieee1284/0.2.11
REQUIRES          += dev/python2/2.7.6-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.2.11
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libieee1284/libieee1284-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libieee1284-$(version)
src_dir_name       = libieee1284-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IEEE1284_32_PKG_NAME                = libieee1284-x32
IEEE1284_32_PKG_VERSION             = 0.2.11
IEEE1284_32_PKG_ARCH                = $(TOOLCHAIN)
IEEE1284_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IEEE1284_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IEEE1284_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
IEEE1284_32_PKG_SHORT_DESCRIPTION   = parallel port library
IEEE1284_32_PKG_URL                 = $(BUG_URL)
IEEE1284_32_PKG_LICENSE             = GPLv2
IEEE1284_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IEEE1284_32_PKG_NAME)-pkg-description
IEEE1284_32_PKG_DESCRIPTION_FILE_IN = $(IEEE1284_32_PKG_NAME)-pkg-description.in
IEEE1284_32_PKG_INSTALL_SCRIPT      = $(IEEE1284_32_PKG_NAME)-pkg-install.sh

IEEE1284_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IEEE1284_32_PKG_NAME)-package

pkg_basename     = $(IEEE1284_32_PKG_NAME)-$(IEEE1284_32_PKG_VERSION)-$(IEEE1284_32_PKG_ARCH)-$(IEEE1284_32_PKG_DISTRO_NAME)-$(IEEE1284_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IEEE1284_32_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-python

extra_configure_switches += --program-prefix=''
extra_configure_switches += --program-suffix=''

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

python_environment  = am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += PYTHON_INCLUDES=-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += src_ieee1284module_la_CFLAGS='-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION) -fpic'
python_environment += am_cv_python_pythondir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IEEE1284_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(IEEE1284_32_PKG)/usr/bin
	@rm -rf $(IEEE1284_32_PKG)/usr/include
	@rm -rf $(IEEE1284_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IEEE1284_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libieee1284.la \
	 )
	@( cd $(IEEE1284_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" ieee1284module.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IEEE1284_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libieee1284.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libieee1284.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ieee1284module.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" ieee1284module.la \
	 )
	# ======= Strip binaries =======
	@( cd $(IEEE1284_32_PKG) ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(IEEE1284_32_PKG_DESCRIPTION_FILE): $(IEEE1284_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IEEE1284_32_PKG_DESCRIPTION_FILE) $(IEEE1284_32_PKG_INSTALL_SCRIPT)
	@cp $(IEEE1284_32_PKG_DESCRIPTION_FILE) $(IEEE1284_32_PKG)/.DESCRIPTION
	@cp $(IEEE1284_32_PKG_INSTALL_SCRIPT) $(IEEE1284_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IEEE1284_32_PKG)/.REQUIRES
	@echo "pkgname=$(IEEE1284_32_PKG_NAME)"                            >  $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IEEE1284_32_PKG_VERSION)"                          >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "arch=$(IEEE1284_32_PKG_ARCH)"                               >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(IEEE1284_32_PKG_DISTRO_NAME)"                  >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(IEEE1284_32_PKG_DISTRO_VERSION)"                >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "group=$(IEEE1284_32_PKG_GROUP)"                             >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IEEE1284_32_PKG_SHORT_DESCRIPTION)\"" >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "url=$(IEEE1284_32_PKG_URL)"                                 >> $(IEEE1284_32_PKG)/.PKGINFO ; \
	 echo "license=$(IEEE1284_32_PKG_LICENSE)"                         >> $(IEEE1284_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IEEE1284_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
