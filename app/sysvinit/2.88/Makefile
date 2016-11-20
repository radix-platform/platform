
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/sysvinit

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version             = 2.88dsf
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/packages/a/sysvinit/sysvinit-$(version).tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/sysvinit-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SYSVINIT_PKG_NAME                = sysvinit
SYSVINIT_PKG_VERSION             = 2.88
SYSVINIT_PKG_ARCH                = $(TOOLCHAIN)
SYSVINIT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSVINIT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSVINIT_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
SYSVINIT_PKG_SHORT_DESCRIPTION   = init is the parent of all processes
SYSVINIT_PKG_URL                 = $(BUG_URL)
SYSVINIT_PKG_LICENSE             = GPLv2
SYSVINIT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSVINIT_PKG_NAME)-pkg-description
SYSVINIT_PKG_DESCRIPTION_FILE_IN = $(SYSVINIT_PKG_NAME)-pkg-description.in
SYSVINIT_PKG_INSTALL_SCRIPT      = $(SYSVINIT_PKG_NAME)-pkg-install.sh

SYSVINIT_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SYSVINIT_PKG_NAME)-package

pkg_basename     = $(SYSVINIT_PKG_NAME)-$(SYSVINIT_PKG_VERSION)-$(SYSVINIT_PKG_ARCH)-$(SYSVINIT_PKG_DISTRO_NAME)-$(SYSVINIT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk

#
# NOTE:
#   sysvinit doesn't want to have -I$(TARGET_DEST_DIR)/usr/include in CFLAGS
#   but we have to pass the architecture dependend CFLAGS. In this case we
#   overwrite CFLAGS with ARCH_FLAGS value to remove standatd -I flags added
#   by build-system.
#
# GCC CPP documentation:
#   All directories named by ‘-isystem’ are searched after all directories
#   named by ‘-I’, no matter what their order was on the command line. If the
#   same directory is named by both ‘-I’ and ‘-isystem’, the ‘-I’ option is
#   ignored. GCC provides an informative message when this occurs if ‘-v’ is
#   used. For example, we can make use following CFLAGS:
#
#     CFLAGS = -v -isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS)
#
CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/src && $(BUILD_ENVIRONMENT) $(MAKE) clobber
	@cd $(SRC_DIR)/src && $(BUILD_ENVIRONMENT) $(MAKE) all
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SYSVINIT_PKG)/sbin
	@( cd $(SRC_DIR)/src ; \
	   for program in bootlogd halt init killall5 shutdown runlevel ; do \
	     $(STRIP) --strip-unneeded $$program ; \
	     cat $$program > $(SYSVINIT_PKG)/sbin/$$program ; \
	     chmod 755 $(SYSVINIT_PKG)/sbin/$$program ; \
	   done \
	 )
	@mkdir -p $(SYSVINIT_PKG)/usr/bin
	@( cd $(SRC_DIR)/src ; \
	   for program in last ; do \
	     $(STRIP) --strip-unneeded $$program ; \
	     cat $$program > $(SYSVINIT_PKG)/usr/bin/$$program ; \
	     chmod 755 $(SYSVINIT_PKG)/usr/bin/$$program ; \
	   done \
	 )
	@( cd $(SYSVINIT_PKG)/usr/bin ; ln -sf last lastb )
	@mv $(SYSVINIT_PKG)/sbin/init $(SYSVINIT_PKG)/sbin/init.new
	@chmod 755 $(SYSVINIT_PKG)/sbin/init.new
	# ======= The version of 'powerd' is old. Now we have to use genpower =======
	@( cd $(SRC_DIR)/src ; cp initscript.sample $(SYSVINIT_PKG)/sbin/initscript.sample )
	@mkdir -p $(SYSVINIT_PKG)/usr/doc/sysvinit-$(version)
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* COPYRIGHT \
	         $(SYSVINIT_PKG)/usr/doc/sysvinit-$(version) \
	 )
	@mkdir -p $(SYSVINIT_PKG)/usr/share/doc/sysvinit-$(version)
	@( cd $(SRC_DIR)/doc ; \
	   cp -a Install Propaganda sysvinit-2.86.lsm \
	         ../COPYING* ../COPYRIGHT ../README*  \
	         $(SYSVINIT_PKG)/usr/share/doc/sysvinit-$(version) \
	 )
	@mkdir -p $(SYSVINIT_PKG)/usr/share/man/man{1,5,8}
	@( cd $(SRC_DIR)/man ; \
	   for page in last.1 ; do \
	     cat $$page | gzip -9c > $(SYSVINIT_PKG)/usr/share/man/man1/$$page.gz ; \
	   done ; \
	   for page in inittab.5 initscript.5 ; do \
	     cat $$page | gzip -9c > $(SYSVINIT_PKG)/usr/share/man/man5/$$page.gz ; \
	   done ; \
	   for page in halt.8 init.8 killall5.8 pidof.8 \
	               runlevel.8 shutdown.8 bootlogd.8 ; do \
	     cat $$page | gzip -9c > $(SYSVINIT_PKG)/usr/share/man/man8/$$page.gz ; \
	   done \
	 )
	@( cd $(SYSVINIT_PKG)/usr/share/man/man1 ; ln -sf last.1.gz lastb.1.gz )
	@( cd $(SYSVINIT_PKG)/usr/share/man/man8 ; \
	   ln -sf halt.8.gz poweroff.8.gz ; \
	   ln -sf halt.8.gz reboot.8.gz   ; \
	   ln -sf init.8.gz telinit.8.gz  ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SYSVINIT_PKG))
	# ======= Strip binaries =======
	@( cd $(SYSVINIT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(SYSVINIT_PKG_DESCRIPTION_FILE): $(SYSVINIT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SYSVINIT_PKG_DESCRIPTION_FILE) $(SYSVINIT_PKG_INSTALL_SCRIPT)
	@cp $(SYSVINIT_PKG_DESCRIPTION_FILE) $(SYSVINIT_PKG)/.DESCRIPTION
	@cp $(SYSVINIT_PKG_INSTALL_SCRIPT) $(SYSVINIT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SYSVINIT_PKG)/.REQUIRES
	@echo "pkgname=$(SYSVINIT_PKG_NAME)"                            >  $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSVINIT_PKG_VERSION)"                          >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSVINIT_PKG_ARCH)"                               >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSVINIT_PKG_DISTRO_NAME)"                  >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSVINIT_PKG_DISTRO_VERSION)"                >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "group=$(SYSVINIT_PKG_GROUP)"                             >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSVINIT_PKG_SHORT_DESCRIPTION)\"" >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "url=$(SYSVINIT_PKG_URL)"                                 >> $(SYSVINIT_PKG)/.PKGINFO ; \
	 echo "license=$(SYSVINIT_PKG_LICENSE)"                         >> $(SYSVINIT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SYSVINIT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
