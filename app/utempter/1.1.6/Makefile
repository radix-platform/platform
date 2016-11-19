
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/utempter

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.23
else
REQUIRES           = libs/glibc/2.23-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.6
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/utempter/libutempter-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libutempter-$(version)
src_dir_name       = libutempter-$(version)
doc_dir_name       = utempter-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UTEMPTER_PKG_NAME                = utempter
UTEMPTER_PKG_VERSION             = 1.1.6
UTEMPTER_PKG_ARCH                = $(TOOLCHAIN)
UTEMPTER_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UTEMPTER_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UTEMPTER_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
UTEMPTER_PKG_SHORT_DESCRIPTION   = utmp updating library and utility
UTEMPTER_PKG_URL                 = $(BUG_URL)
UTEMPTER_PKG_LICENSE             = LGPLv2.1
UTEMPTER_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UTEMPTER_PKG_NAME)-pkg-description
UTEMPTER_PKG_DESCRIPTION_FILE_IN = $(UTEMPTER_PKG_NAME)-pkg-description.in
UTEMPTER_PKG_INSTALL_SCRIPT      = $(UTEMPTER_PKG_NAME)-pkg-install.sh

UTEMPTER_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UTEMPTER_PKG_NAME)-package

pkg_basename     = $(UTEMPTER_PKG_NAME)-$(UTEMPTER_PKG_VERSION)-$(UTEMPTER_PKG_ARCH)-$(UTEMPTER_PKG_DISTRO_NAME)-$(UTEMPTER_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(UTEMPTER_PKG)

environment  = libdir=/usr/lib$(LIBSUFFIX)
environment += libexecdir=/usr/lib$(LIBSUFFIX)
environment += includedir=/usr/include
environment += mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UTEMPTER_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(UTEMPTER_PKG)/usr/share/man ]; then \
	  ( cd $(UTEMPTER_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(UTEMPTER_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(UTEMPTER_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(UTEMPTER_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(UTEMPTER_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(UTEMPTER_PKG))
	# ======= Strip binaries =======
	@( cd $(UTEMPTER_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(UTEMPTER_PKG_DESCRIPTION_FILE): $(UTEMPTER_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(UTEMPTER_PKG_DESCRIPTION_FILE) $(UTEMPTER_PKG_INSTALL_SCRIPT)
	@cp $(UTEMPTER_PKG_DESCRIPTION_FILE) $(UTEMPTER_PKG)/.DESCRIPTION
	@cp $(UTEMPTER_PKG_INSTALL_SCRIPT) $(UTEMPTER_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UTEMPTER_PKG)/.REQUIRES
	@echo "pkgname=$(UTEMPTER_PKG_NAME)"                            >  $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UTEMPTER_PKG_VERSION)"                          >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "arch=$(UTEMPTER_PKG_ARCH)"                               >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "distroname=$(UTEMPTER_PKG_DISTRO_NAME)"                  >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "distrover=$(UTEMPTER_PKG_DISTRO_VERSION)"                >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "group=$(UTEMPTER_PKG_GROUP)"                             >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UTEMPTER_PKG_SHORT_DESCRIPTION)\"" >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "url=$(UTEMPTER_PKG_URL)"                                 >> $(UTEMPTER_PKG)/.PKGINFO ; \
	 echo "license=$(UTEMPTER_PKG_LICENSE)"                         >> $(UTEMPTER_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UTEMPTER_PKG)   && \
	                    chown -R root:root . && \
	                    chown    root:22 usr/lib$(LIBSUFFIX)/utempter/utempter && \
	                    $(MAKE_PACKAGE) --linkadd yes .."
