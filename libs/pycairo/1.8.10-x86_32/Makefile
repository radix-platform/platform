
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/pycairo

REQUIRES           = libs/pycairo/1.8.10
REQUIRES          += dev/python2/2.7.11-x86_32
REQUIRES          += X11/libs/cairo/1.14.6-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 1.8.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/pycairo/py2cairo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pycairo-$(version)
src_dir_name       = pycairo-$(version)
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
PYCAIRO_32_PKG_NAME                = pycairo-x32
PYCAIRO_32_PKG_VERSION             = 1.8.10
PYCAIRO_32_PKG_ARCH                = $(TOOLCHAIN)
PYCAIRO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYCAIRO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYCAIRO_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
PYCAIRO_32_PKG_SHORT_DESCRIPTION   = Python bindings for the cairo library
PYCAIRO_32_PKG_URL                 = $(BUG_URL)
PYCAIRO_32_PKG_LICENSE             = LGPLv2.1
PYCAIRO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYCAIRO_32_PKG_NAME)-pkg-description
PYCAIRO_32_PKG_DESCRIPTION_FILE_IN = $(PYCAIRO_32_PKG_NAME)-pkg-description.in
PYCAIRO_32_PKG_INSTALL_SCRIPT      = $(PYCAIRO_32_PKG_NAME)-pkg-install.sh

PYCAIRO_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYCAIRO_32_PKG_NAME)-package

pkg_basename     = $(PYCAIRO_32_PKG_NAME)-$(PYCAIRO_32_PKG_VERSION)-$(PYCAIRO_32_PKG_ARCH)-$(PYCAIRO_32_PKG_DISTRO_NAME)-$(PYCAIRO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PYCAIRO_32_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

python_environment  = am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += PYTHON_INCLUDES=-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += am_cv_python_pythondir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PYCAIRO_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PYCAIRO_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PYCAIRO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages/cairo ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _cairo.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYCAIRO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages/cairo ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _cairo.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _cairo.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pycairo.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PYCAIRO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PYCAIRO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PYCAIRO_32_PKG_DESCRIPTION_FILE): $(PYCAIRO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYCAIRO_32_PKG_DESCRIPTION_FILE) $(PYCAIRO_32_PKG_INSTALL_SCRIPT)
	@cp $(PYCAIRO_32_PKG_DESCRIPTION_FILE) $(PYCAIRO_32_PKG)/.DESCRIPTION
	@cp $(PYCAIRO_32_PKG_INSTALL_SCRIPT) $(PYCAIRO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYCAIRO_32_PKG)/.REQUIRES
	@echo "pkgname=$(PYCAIRO_32_PKG_NAME)"                            >  $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYCAIRO_32_PKG_VERSION)"                          >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PYCAIRO_32_PKG_ARCH)"                               >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYCAIRO_32_PKG_DISTRO_NAME)"                  >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYCAIRO_32_PKG_DISTRO_VERSION)"                >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "group=$(PYCAIRO_32_PKG_GROUP)"                             >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYCAIRO_32_PKG_SHORT_DESCRIPTION)\"" >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "url=$(PYCAIRO_32_PKG_URL)"                                 >> $(PYCAIRO_32_PKG)/.PKGINFO ; \
	 echo "license=$(PYCAIRO_32_PKG_LICENSE)"                         >> $(PYCAIRO_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PYCAIRO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
