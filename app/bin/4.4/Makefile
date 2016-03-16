
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/debianutils
SOURCE_REQUIRES   += sources/packages/a/mktemp
SOURCE_REQUIRES   += sources/packages/a/banners
SOURCE_REQUIRES   += sources/packages/a/todos
SOURCE_REQUIRES   += sources/packages/m/fb/fbset


ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.23
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/debianutils/debianutils_$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/debianutils-$(version)
src_dir_name       = debianutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

mktemp_version     = 2.7
mktemp_archive     = $(SRC_PACKAGE_PATH)/packages/a/mktemp/mktemp-$(mktemp_version).tar.bz2
MKTEMP_SRC_DIR     = $(TARGET_BUILD_DIR)/mktemp-$(mktemp_version)
mktemp_src_done    = $(TARGET_BUILD_DIR)/.mktemp-source-done

banners_archive    = $(SRC_PACKAGE_PATH)/packages/a/banners/banners.tar.gz
BANNERS_SRC_DIR    = $(TARGET_BUILD_DIR)/banners
banners_src_done   = $(TARGET_BUILD_DIR)/.banners-source-done

todos_archive      = $(SRC_PACKAGE_PATH)/packages/a/todos/todos.tar.gz
TODOS_SRC_DIR      = $(TARGET_BUILD_DIR)/todos
todos_src_done     = $(TARGET_BUILD_DIR)/.todos-source-done

fbset_version      = 2.1
fbset_archive      = $(SRC_PACKAGE_PATH)/packages/m/fb/fbset/fbset-$(fbset_version).tar.gz
FBSET_SRC_DIR      = $(TARGET_BUILD_DIR)/fbset-$(fbset_version)
fbset_src_done     = $(TARGET_BUILD_DIR)/.fbset-source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

licenses_dir       = $(CURDIR)/licenses
scripts_dir        = $(CURDIR)/scripts

####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CMDUTILS_PKG_NAME                = bin
CMDUTILS_PKG_VERSION             = 4.4
CMDUTILS_PKG_ARCH                = $(TOOLCHAIN)
CMDUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CMDUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CMDUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CMDUTILS_PKG_SHORT_DESCRIPTION   = some command-line utilities
CMDUTILS_PKG_URL                 = $(BUG_URL)
CMDUTILS_PKG_LICENSE             = GPLv2
CMDUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CMDUTILS_PKG_NAME)-pkg-description
CMDUTILS_PKG_DESCRIPTION_FILE_IN = $(CMDUTILS_PKG_NAME)-pkg-description.in
CMDUTILS_PKG_INSTALL_SCRIPT      = $(CMDUTILS_PKG_NAME)-pkg-install.sh

CMDUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CMDUTILS_PKG_NAME)-package

pkg_basename     = $(CMDUTILS_PKG_NAME)-$(CMDUTILS_PKG_VERSION)-$(CMDUTILS_PKG_ARCH)-$(CMDUTILS_PKG_DISTRO_NAME)-$(CMDUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CMDUTILS_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc

banners_environment = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS) -Wall"
todos_environment   = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS) -Wall"
fbset_environment   = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMIZATION_FLAGS) -Wall"


####### Dependencies

$(mktemp_src_done): $(mktemp_archive)
	@echo "Expanding $(mktemp_archive)"
	@tar xjf $(mktemp_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(banners_src_done): $(banners_archive)
	@echo "Expanding $(banners_archive)"
	@tar xzf $(banners_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(todos_src_done): $(todos_archive)
	@echo "Expanding $(todos_archive)"
	@tar xzf $(todos_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(fbset_src_done): $(fbset_archive)
	@echo "Expanding $(fbset_archive)"
	@tar xzf $(fbset_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(mktemp_src_done) $(banners_src_done) $(todos_src_done) $(fbset_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(MKTEMP_SRC_DIR) && \
	    $(BUILD_ENVIRONMENT) ./configure --prefix=/usr --build=$(BUILD) --host=$(TARGET)
	@cd $(MKTEMP_SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(BANNERS_SRC_DIR) && $(BUILD_ENVIRONMENT) $(banners_environment) $(MAKE)
	@cd $(TODOS_SRC_DIR) && $(BUILD_ENVIRONMENT) $(todos_environment) $(MAKE)
	@cd $(FBSET_SRC_DIR) && $(BUILD_ENVIRONMENT) $(fbset_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CMDUTILS_PKG)/etc
	@mkdir -p $(CMDUTILS_PKG)/usr/{bin,sbin}
	@mkdir -p $(CMDUTILS_PKG)/usr/share/man/man{1,5,8}
	# ======= Install debianutils-$(version) =======
	@( cd $(SRC_DIR) ; \
	   # ======= We use our own very simple run-parts ======= ; \
	   # ======= script in the dcron package instead  ======= ; \
	   # cat run-parts > $(CMDUTILS_PKG)/usr/bin/run-parts    ; \
	   # cat run-parts.8 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man8/run-parts.8.gz ; \
	   cat savelog > $(CMDUTILS_PKG)/usr/bin/savelog          ; \
	   cat savelog.8 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man8/savelog.8.gz ; \
	   cat tempfile > $(CMDUTILS_PKG)/usr/bin/tempfile        ; \
	   cat tempfile.1 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man1/tempfile.1.gz ; \
	   chmod 755 $(CMDUTILS_PKG)/usr/bin/*  ; \
	   mkdir -p $(CMDUTILS_PKG)/usr/doc/debianutils-$(version) ; \
	   cp -a debian/copyright $(CMDUTILS_PKG)/usr/doc/debianutils-$(version) ; \
	 )
	# ======= Install mktemp-$(mktemp_version) =======
	@( cd $(MKTEMP_SRC_DIR) ; \
	   cat mktemp > $(CMDUTILS_PKG)/usr/bin/mktemp ; \
	   chmod 755 $(CMDUTILS_PKG)/usr/bin/mktemp    ; \
	   cat mktemp.1 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man1/mktemp.1.gz ; \
	   mkdir -p $(CMDUTILS_PKG)/usr/doc/mktemp-$(mktemp_version) ; \
	   cp -a COPYING $(CMDUTILS_PKG)/usr/doc/mktemp-$(mktemp_version) ; \
	   mkdir -p $(CMDUTILS_PKG)/usr/share/doc/mktemp-$(mktemp_version) ; \
	   cp -a COPYING README $(CMDUTILS_PKG)/usr/share/doc/mktemp-$(mktemp_version) ; \
	 )
	# ======= Install banners utilites =======
	@( cd $(BANNERS_SRC_DIR) ; \
	   cat bban > $(CMDUTILS_PKG)/usr/bin/bban ; \
	   cat sysvbanner > $(CMDUTILS_PKG)/usr/bin/sysvbanner ; \
	   chmod 755 $(CMDUTILS_PKG)/usr/bin/{bban,sysvbanner} ; \
	 )
	# ======= Install todos/fromdos utilites =======
	@( cd $(TODOS_SRC_DIR) ; \
	   cat todos > $(CMDUTILS_PKG)/usr/bin/todos     ; \
	   cat fromdos > $(CMDUTILS_PKG)/usr/bin/fromdos ; \
	   chmod 755 $(CMDUTILS_PKG)/usr/bin/*dos        ; \
	   cat todos.1.gz   > $(CMDUTILS_PKG)/usr/share/man/man1/todos.1.gz   ; \
	   cat fromdos.1.gz > $(CMDUTILS_PKG)/usr/share/man/man1/fromdos.1.gz ; \
	 )
	# ======= Install fbset-$(fbset_version) =======
	@( cd $(FBSET_SRC_DIR) ; \
	   cat fbset > $(CMDUTILS_PKG)/usr/sbin/fbset ; \
	   chmod 755 $(CMDUTILS_PKG)/usr/sbin/fbset   ; \
	   cat etc/fb.modes.ATI > $(CMDUTILS_PKG)/etc/fb.modes.new ; \
	   cat fb.modes.5 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man5/fb.modes.5.gz ; \
	   cat fbset.8 | gzip -9c > $(CMDUTILS_PKG)/usr/share/man/man8/fbset.8.gz       ; \
	   mkdir -p $(CMDUTILS_PKG)/usr/doc/fbset-$(fbset_version)            ; \
	   cp -a $(licenses_dir)/fbset.license \
	         $(CMDUTILS_PKG)/usr/doc/fbset-$(fbset_version)/COPYING       ; \
	   mkdir -p $(CMDUTILS_PKG)/usr/share/doc/fbset-$(fbset_version)      ; \
	   cp -a INSTALL etc/* \
	     $(CMDUTILS_PKG)/usr/share/doc/fbset-$(fbset_version)             ; \
	   cp -a $(licenses_dir)/fbset.license \
	         $(CMDUTILS_PKG)/usr/share/doc/fbset-$(fbset_version)/COPYING ; \
	   rm -rf $(CMDUTILS_PKG)/usr/share/doc/fbset-$(fbset_version)/CVS    ; \
	 )
	# ======= Install diskcopy, xx scripts =======
	@cp -a $(scripts_dir)/diskcopy $(CMDUTILS_PKG)/usr/bin
	@cp -a $(scripts_dir)/xx       $(CMDUTILS_PKG)/usr/bin
	@chmod 0755 $(CMDUTILS_PKG)/usr/bin/diskcopy
	@chmod 0755 $(CMDUTILS_PKG)/usr/bin/xx
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CMDUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(CMDUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(CMDUTILS_PKG_DESCRIPTION_FILE): $(CMDUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CMDUTILS_PKG_DESCRIPTION_FILE) $(CMDUTILS_PKG_INSTALL_SCRIPT)
	@cp $(CMDUTILS_PKG_DESCRIPTION_FILE) $(CMDUTILS_PKG)/.DESCRIPTION
	@cp $(CMDUTILS_PKG_INSTALL_SCRIPT) $(CMDUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CMDUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(CMDUTILS_PKG_NAME)"                            >  $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CMDUTILS_PKG_VERSION)"                          >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(CMDUTILS_PKG_ARCH)"                               >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(CMDUTILS_PKG_DISTRO_NAME)"                  >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(CMDUTILS_PKG_DISTRO_VERSION)"                >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(CMDUTILS_PKG_GROUP)"                             >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CMDUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(CMDUTILS_PKG_URL)"                                 >> $(CMDUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(CMDUTILS_PKG_LICENSE)"                         >> $(CMDUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CMDUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
