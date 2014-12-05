
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libxslt

REQUIRES           = libs/libxslt/1.1.28
REQUIRES          += app/xz/5.0.5-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += libs/pth/2.0.7-x86_32
REQUIRES          += libs/libxml2/2.9.1-x86_32
REQUIRES          += net/libgpg-error/1.16-x86_32
REQUIRES          += net/libgcrypt/1.6.2-x86_32
REQUIRES          += dev/python2/2.7.6-x86_32

PYTHON_VERSION = 2.7


version            = 1.1.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libxslt/libxslt-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libxslt-$(version)
src_dir_name       = libxslt-$(version)
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
LIBXSLT_32_PKG_NAME                = libxslt-x32
LIBXSLT_32_PKG_VERSION             = 1.1.28
LIBXSLT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBXSLT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBXSLT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBXSLT_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBXSLT_32_PKG_SHORT_DESCRIPTION   = XML transformation library
LIBXSLT_32_PKG_URL                 = $(BUG_URL)
LIBXSLT_32_PKG_LICENSE             = custom
LIBXSLT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBXSLT_32_PKG_NAME)-pkg-description
LIBXSLT_32_PKG_DESCRIPTION_FILE_IN = $(LIBXSLT_32_PKG_NAME)-pkg-description.in
LIBXSLT_32_PKG_INSTALL_SCRIPT      = $(LIBXSLT_32_PKG_NAME)-pkg-install.sh

LIBXSLT_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBXSLT_32_PKG_NAME)-package

pkg_basename     = $(LIBXSLT_32_PKG_NAME)-$(LIBXSLT_32_PKG_VERSION)-$(LIBXSLT_32_PKG_ARCH)-$(LIBXSLT_32_PKG_DISTRO_NAME)-$(LIBXSLT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBXSLT_32_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LIBS=-L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch -t 201401010000.00 $(SRC_DIR)/*
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
	@mkdir -p $(LIBXSLT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(LIBXSLT_32_PKG)/usr/bin/32
	@( cd $(LIBXSLT_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBXSLT_32_PKG)/usr/include
	@rm -rf $(LIBXSLT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBXSLT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,-L/usr/lib64,,g" libexslt.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexslt.la libxslt.la \
	 )
	@( cd $(LIBXSLT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,-L/usr/lib64,,g" libxsltmod.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxsltmod.la \
	 )
	# ======= Fix LDFLAGS in libexslt.pc =======
	@( cd $(LIBXSLT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,-L/usr/lib64,,g" libexslt.pc ; \
	 )
	# ======= tune xslt-config script for runtime =======
	@( cd $(LIBXSLT_32_PKG)/usr/bin/32 ; \
	   sed -i "s,lib/lib,lib$(MULTILIB_X86_32_SUFFIX)/lib,g" xslt-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBXSLT_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexslt.la libxslt.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexslt.la libxslt.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxsltmod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxsltmod.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexslt.pc libxslt.pc \
	 )
	# ======= tune xslt-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" xslt-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBXSLT_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBXSLT_32_PKG_DESCRIPTION_FILE): $(LIBXSLT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBXSLT_32_PKG_DESCRIPTION_FILE) $(LIBXSLT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBXSLT_32_PKG_DESCRIPTION_FILE) $(LIBXSLT_32_PKG)/.DESCRIPTION
	@cp $(LIBXSLT_32_PKG_INSTALL_SCRIPT) $(LIBXSLT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBXSLT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBXSLT_32_PKG_NAME)"                            >  $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBXSLT_32_PKG_VERSION)"                          >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBXSLT_32_PKG_ARCH)"                               >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBXSLT_32_PKG_DISTRO_NAME)"                  >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBXSLT_32_PKG_DISTRO_VERSION)"                >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBXSLT_32_PKG_GROUP)"                             >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBXSLT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBXSLT_32_PKG_URL)"                                 >> $(LIBXSLT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBXSLT_32_PKG_LICENSE)"                         >> $(LIBXSLT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBXSLT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
