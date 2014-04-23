
COMPONENT_TARGETS  += $(TARGET_PC32)
COMPONENT_TARGETS  += $(TARGET_PC64)
COMPONENT_TARGETS  += $(TARGET_CB1X)
COMPONENT_TARGETS  += $(TARGET_VIP1830)
COMPONENT_TARGETS  += $(TARGET_BEAGLE)
COMPONENT_TARGETS  += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS  += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS  += $(TARGET_CB1N)
# COMPONENT_TARGETS  += $(TARGET_GUARD)
# COMPONENT_TARGETS  += $(TARGET_VIP1830N)
# COMPONENT_TARGETS  += $(TARGET_L17UC)
#


NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/packages/n/netkit-rsh


REQUIRES            = libs/eglibc/2.18.1


version             = 0.17
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/n/netkit-rsh/netkit-rsh-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/netkit-rsh-$(version)
src_dir_name        = netkit-rsh-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_rsh_pkg       = $(TARGET_BUILD_DIR)/.rsh_pkg_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RSH_PKG_NAME                = netkit-rsh
RSH_PKG_VERSION             = 0.17
RSH_PKG_ARCH                = $(TOOLCHAIN)
RSH_PKG_DISTRO_NAME         = kxLab
RSH_PKG_DISTRO_VERSION      = 1.0
RSH_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
RSH_PKG_SHORT_DESCRIPTION   = netkit-rsh $(version)
RSH_PKG_URL                 = http://www.kxLab.com
RSH_PKG_LICENSE             = BSD
RSH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RSH_PKG_NAME)-pkg-description
RSH_PKG_DESCRIPTION_FILE_IN = $(RSH_PKG_NAME)-pkg-description.in
RSH_PKG_INSTALL_SCRIPT      = $(RSH_PKG_NAME)-pkg-install.sh

RSH_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RSH_PKG_NAME)-package

pkg_basename     = $(RSH_PKG_NAME)-$(RSH_PKG_VERSION)-$(RSH_PKG_ARCH)-$(RSH_PKG_DISTRO_NAME)-$(RSH_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(RSH_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_rsh_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


rsh_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
rsh_environment = CFLAGS="$(rsh_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rsh_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rsh_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RSH_PKG)/usr/{bin,sbin}
	@mkdir -p $(RSH_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(RSH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rsh ; \
	   cat rsh > $(RSH_PKG)/usr/bin/rsh ; \
	   cat rsh.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rsh.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rshd ; \
	   cat rshd > $(RSH_PKG)/usr/sbin/in.rshd ; \
	   cat rshd.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rshd.8.gz ; \
	 )
	@( cd $(SRC_DIR)/rcp ; \
	   cat rcp > $(RSH_PKG)/usr/bin/rcp ; \
	   cat rcp.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rcp.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rexec ; \
	   cat rexec > $(RSH_PKG)/usr/bin/rexec ; \
	   cat rexec.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rexec.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rexecd ; \
	   cat rexecd > $(RSH_PKG)/usr/sbin/in.rexecd ; \
	   cat rexecd.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rexecd.8.gz ; \
	 )
	@( cd $(SRC_DIR)/rlogin ; \
	   cat rlogin > $(RSH_PKG)/usr/bin/rlogin ; \
	   cat rlogin.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rlogin.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rlogind ; \
	   cat rlogind > $(RSH_PKG)/usr/sbin/in.rlogind ; \
	   cat rlogind.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rlogind.8.gz ; \
	 )
	@chmod 4711 $(RSH_PKG)/usr/bin/*
	@chmod  755 $(RSH_PKG)/usr/sbin/*
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(RSH_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RSH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(RSH_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(RSH_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RSH_PKG_DESCRIPTION_FILE): $(RSH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_rsh_pkg): $(install_target) $(RSH_PKG_DESCRIPTION_FILE)
	@cp $(RSH_PKG_DESCRIPTION_FILE) $(RSH_PKG)/.DESCRIPTION
	@cp $(RSH_PKG_INSTALL_SCRIPT) $(RSH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RSH_PKG)/.REQUIRES
	@echo "pkgname=$(RSH_PKG_NAME)"                            >  $(RSH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RSH_PKG_VERSION)"                          >> $(RSH_PKG)/.PKGINFO ; \
	 echo "arch=$(RSH_PKG_ARCH)"                               >> $(RSH_PKG)/.PKGINFO ; \
	 echo "distroname=$(RSH_PKG_DISTRO_NAME)"                  >> $(RSH_PKG)/.PKGINFO ; \
	 echo "distrover=$(RSH_PKG_DISTRO_VERSION)"                >> $(RSH_PKG)/.PKGINFO ; \
	 echo "group=$(RSH_PKG_GROUP)"                             >> $(RSH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RSH_PKG_SHORT_DESCRIPTION)\"" >> $(RSH_PKG)/.PKGINFO ; \
	 echo "url=$(RSH_PKG_URL)"                                 >> $(RSH_PKG)/.PKGINFO ; \
	 echo "license=$(RSH_PKG_LICENSE)"                         >> $(RSH_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(RSH_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
