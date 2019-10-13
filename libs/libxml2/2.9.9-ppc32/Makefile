
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libxml2

REQUIRES           = libs/libxml2/2.9.9
REQUIRES          += libs/zlib/1.2.8-ppc32
REQUIRES          += app/xz/5.2.4-ppc32
REQUIRES          += libs/icu4c/65.1-ppc32
REQUIRES          += libs/readline/8.0-ppc32
REQUIRES          += dev/python2/2.7.16-ppc32
REQUIRES          += dev/python3/3.7.4-ppc32

# ======= __END_OF_REQUIRES__ =======

version            = 2.9.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libxml2/libxml2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libxml2-$(version)
src_dir_name       = libxml2-$(version)
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
LIBXML2_32_PKG_NAME                = libxml2-x32
LIBXML2_32_PKG_VERSION             = 2.9.9
LIBXML2_32_PKG_ARCH                = $(TOOLCHAIN)
LIBXML2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBXML2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBXML2_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBXML2_32_PKG_SHORT_DESCRIPTION   = XML parser library
LIBXML2_32_PKG_URL                 = $(BUG_URL)
LIBXML2_32_PKG_LICENSE             = custom
LIBXML2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBXML2_32_PKG_NAME)-pkg-description
LIBXML2_32_PKG_DESCRIPTION_FILE_IN = $(LIBXML2_32_PKG_NAME)-pkg-description.in
LIBXML2_32_PKG_INSTALL_SCRIPT      = $(LIBXML2_32_PKG_NAME)-pkg-install.sh

LIBXML2_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBXML2_32_PKG_NAME)-package

pkg_basename     = $(LIBXML2_32_PKG_NAME)-$(LIBXML2_32_PKG_VERSION)-$(LIBXML2_32_PKG_ARCH)-$(LIBXML2_32_PKG_DISTRO_NAME)-$(LIBXML2_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBXML2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


PYTHON_VERSION = 3.7

ifeq ($(PYTHON_VERSION),2.7)
WITH_PYTHON = $(PYTHON2)
python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LIBS='$(shell $(TARGET_DEST_DIR)/usr/bin/32/python$(PYTHON_VERSION)-config --ldflags)'
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
endif

ifeq ($(PYTHON_VERSION),3.7)
WITH_PYTHON = $(PYTHON3)
python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES='$(shell $(TARGET_DEST_DIR)/usr/bin/32/python$(PYTHON_VERSION)-config --includes)'
python_environment += PYTHON_LIBS='$(shell $(TARGET_DEST_DIR)/usr/bin/32/python$(PYTHON_VERSION)-config --ldflags)'
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m
endif


TARGET_BIN_RPATH = /lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; autoreconf -vif )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET32)           \
	  --with-python=$(WITH_PYTHON) \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBXML2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBXML2_32_PKG)/usr/include
	@rm -rf $(LIBXML2_32_PKG)/usr/share
	# ======= remove toolchain path from xml2-config script =======
	@( cd $(LIBXML2_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" xml2-config ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBXML2_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxml2.la  ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" xml2Conf.sh ; \
	 )
	@( cd $(LIBXML2_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxml2mod.la ; \
	 )
	@( cd $(LIBXML2_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxml-2.0.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBXML2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libxml2.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxml2.la  ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   xml2Conf.sh ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libxml2mod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxml2mod.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxml-2.0.pc \
	 )
	# ======= tune xml2-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g"                 xml2-config ; \
	   sed -i "s,prefix/lib,prefix/lib$(MULTILIB_PPC32_SUFFIX),g" xml2-config ; \
	   sed -i "s,lib64,lib$(MULTILIB_PPC32_SUFFIX),g"             xml2-config ; \
	   sed -i "s,L/usr,L$(TARGET_DEST_DIR)/usr,g"                 xml2-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBXML2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBXML2_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBXML2_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBXML2_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBXML2_32_PKG_DESCRIPTION_FILE): $(LIBXML2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBXML2_32_PKG_DESCRIPTION_FILE) $(LIBXML2_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBXML2_32_PKG_DESCRIPTION_FILE) $(LIBXML2_32_PKG)/.DESCRIPTION
	@cp $(LIBXML2_32_PKG_INSTALL_SCRIPT) $(LIBXML2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBXML2_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBXML2_32_PKG_NAME)"                            >  $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBXML2_32_PKG_VERSION)"                          >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBXML2_32_PKG_ARCH)"                               >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBXML2_32_PKG_DISTRO_NAME)"                  >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBXML2_32_PKG_DISTRO_VERSION)"                >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBXML2_32_PKG_GROUP)"                             >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBXML2_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBXML2_32_PKG_URL)"                                 >> $(LIBXML2_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBXML2_32_PKG_LICENSE)"                         >> $(LIBXML2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBXML2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
