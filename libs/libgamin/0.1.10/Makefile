
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/gamin

REQUIRES           = dev/python2/2.7.11

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
GAMIN_PKG_NAME                = libgamin
GAMIN_PKG_VERSION             = 0.1.10
GAMIN_PKG_ARCH                = $(TOOLCHAIN)
GAMIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GAMIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GAMIN_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GAMIN_PKG_SHORT_DESCRIPTION   = fam/gamin libraries for Gamin
GAMIN_PKG_URL                 = $(BUG_URL)
GAMIN_PKG_LICENSE             = GPLv2
GAMIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GAMIN_PKG_NAME)-pkg-description
GAMIN_PKG_DESCRIPTION_FILE_IN = $(GAMIN_PKG_NAME)-pkg-description.in
GAMIN_PKG_INSTALL_SCRIPT      = $(GAMIN_PKG_NAME)-pkg-install.sh

GAMIN_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GAMIN_PKG_NAME)-package

pkg_basename     = $(GAMIN_PKG_NAME)-$(GAMIN_PKG_VERSION)-$(GAMIN_PKG_ARCH)-$(GAMIN_PKG_DISTRO_NAME)-$(GAMIN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GAMIN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
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
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
endif

ifeq ($(PYTHON_MAJOR_VERSION),2)
PYTHON_VERSION = 2.7
extra_configure_switches += --with-python=$(PYTHON2)

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GAMIN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(GAMIN_PKG)/usr/doc/lib$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GAMIN_PKG)/usr/doc/lib$(src_dir_name)
	@mkdir -p $(GAMIN_PKG)/usr/share/doc/lib$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README TODO doc/debugging.txt doc/socket.txt \
	         $(GAMIN_PKG)/usr/share/doc/lib$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a *.html *.gif \
	         $(GAMIN_PKG)/usr/share/doc/lib$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GAMIN_PKG)/usr/share/doc/lib$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GAMIN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfam.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgamin-1.la  \
	 )
	@( cd $(GAMIN_PKG)/usr/lib$(LIBSUFFIX)/python2.7/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _gamin.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GAMIN_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfam.la ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgamin-1.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfam.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgamin-1.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python2.7/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gamin.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gamin.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gamin.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GAMIN_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GAMIN_PKG_DESCRIPTION_FILE): $(GAMIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GAMIN_PKG_DESCRIPTION_FILE) $(GAMIN_PKG_INSTALL_SCRIPT)
	@cp $(GAMIN_PKG_DESCRIPTION_FILE) $(GAMIN_PKG)/.DESCRIPTION
	@cp $(GAMIN_PKG_INSTALL_SCRIPT) $(GAMIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GAMIN_PKG)/.REQUIRES
	@echo "pkgname=$(GAMIN_PKG_NAME)"                            >  $(GAMIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GAMIN_PKG_VERSION)"                          >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "arch=$(GAMIN_PKG_ARCH)"                               >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(GAMIN_PKG_DISTRO_NAME)"                  >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(GAMIN_PKG_DISTRO_VERSION)"                >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "group=$(GAMIN_PKG_GROUP)"                             >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GAMIN_PKG_SHORT_DESCRIPTION)\"" >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "url=$(GAMIN_PKG_URL)"                                 >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "license=$(GAMIN_PKG_LICENSE)"                         >> $(GAMIN_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GAMIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
