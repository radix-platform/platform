
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


NEED_ABS_PATH = true


include ../../build-system/constants.mk


# ======= __END_OF_REQUIRES__ =======


PKG_GROUP = base

INIT_DEV_PKG_NAME                = init-devices
INIT_DEV_PKG_VERSION             = 1.2.0
INIT_DEV_PKG_ARCH                = $(TOOLCHAIN)
INIT_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
INIT_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
INIT_DEV_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
INIT_DEV_PKG_SHORT_DESCRIPTION   = Initial Device Inodes
INIT_DEV_PKG_URL                 = $(BUG_URL)
INIT_DEV_PKG_LICENSE             = free
INIT_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INIT_DEV_PKG_NAME)-pkg-description
INIT_DEV_PKG_DESCRIPTION_FILE_IN = $(INIT_DEV_PKG_NAME)-pkg-description.in
INIT_DEV_PKG_INSTALL_SCRIPT      = $(INIT_DEV_PKG_NAME)-pkg-install.sh


INIT_DEV_PKG    = $(TARGET_BUILD_DIR)/$(INIT_DEV_PKG_NAME)-package


build = $(TARGET_BUILD_DIR)/.done

pkg_basename    = $(INIT_DEV_PKG_NAME)-$(INIT_DEV_PKG_VERSION)-$(INIT_DEV_PKG_ARCH)-$(INIT_DEV_PKG_DISTRO_NAME)-$(INIT_DEV_PKG_DISTRO_VERSION)

pkg_archive     = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature   = $(call sign-name,$(pkg_archive))
pkg_description = $(call desc-name,$(pkg_archive))
products        = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS   = $(build)

PRODUCT_TARGETS = $(products)


include ../../build-system/core.mk


$(build):
	@mkdir -p $(INIT_DEV_PKG)/dev
	@touch $@

$(INIT_DEV_PKG_DESCRIPTION_FILE): $(INIT_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(INIT_DEV_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(INIT_DEV_PKG_DESCRIPTION_FILE) $(INIT_DEV_PKG_INSTALL_SCRIPT)
	@cp $(INIT_DEV_PKG_DESCRIPTION_FILE) $(INIT_DEV_PKG)/.DESCRIPTION
	@cp $(INIT_DEV_PKG_INSTALL_SCRIPT) $(INIT_DEV_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(INIT_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(INIT_DEV_PKG_NAME)"                            >  $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INIT_DEV_PKG_VERSION)"                          >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(INIT_DEV_PKG_ARCH)"                               >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(INIT_DEV_PKG_DISTRO_NAME)"                  >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(INIT_DEV_PKG_DISTRO_VERSION)"                >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(INIT_DEV_PKG_GROUP)"                             >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INIT_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(INIT_DEV_PKG_URL)"                                 >> $(INIT_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(INIT_DEV_PKG_LICENSE)"                         >> $(INIT_DEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(INIT_DEV_PKG)   && \
	                    chown -R root:root . && \
	                    ( cd dev              ; \
	                      mknod --mode=600 console       c    5 1   ; \
	                      \
	                      mknod --mode=660 ppp           c  108 0   ; \
	                      mknod --mode=666 null          c    1 3   ; \
	                      mknod --mode=666 random        c    1 8   ; \
	                      mknod --mode=666 urandom       c    1 9   ; \
	                      mknod --mode=666 zero          c    1 5   ; \
	                      \
	                      mknod --mode=660 fb0           c   29 0   ; \
	                      mknod --mode=660 fb1           c   29 1   ; \
	                      \
	                      mknod --mode=660 apm_bios      c   10 134 ; \
	                      \
	                      mknod --mode=660 hda           b    3 0   ; \
	                      mknod --mode=660 hda1          b    3 1   ; \
	                      mknod --mode=660 hda2          b    3 2   ; \
	                      mknod --mode=660 hda3          b    3 3   ; \
	                      mknod --mode=660 hda4          b    3 4   ; \
	                      \
	                      mknod --mode=660 sda           b    8 0   ; \
	                      mknod --mode=660 sda1          b    8 1   ; \
	                      mknod --mode=660 sda2          b    8 2   ; \
	                      mknod --mode=660 sda3          b    8 3   ; \
	                      mknod --mode=660 sda4          b    8 4   ; \
	                      \
	                      mknod --mode=660 sdb           b    8 16  ; \
	                      mknod --mode=660 sdb1          b    8 17  ; \
	                      mknod --mode=660 sdb2          b    8 18  ; \
	                      mknod --mode=660 sdb3          b    8 19  ; \
	                      mknod --mode=660 sdb4          b    8 20  ; \
	                      \
	                      mknod --mode=640 mem           c    1 1   ; \
	                      mknod --mode=640 kmem          c    1 2   ; \
	                      mknod --mode=644 kmsg          c    1 11  ; \
	                      mknod --mode=600 kvm           c   10 232 ; \
	                      \
	                      mknod --mode=660 mmcblk0       b  179 0   ; \
	                      mknod --mode=660 mmcblk0p1     b  179 1   ; \
	                      mknod --mode=660 mmcblk0p2     b  179 2   ; \
	                      mknod --mode=660 mmcblk0p3     b  179 3   ; \
	                      mknod --mode=660 mmcblk0p4     b  179 4   ; \
	                      \
	                      mknod --mode=660 mmcblk1       b  179 8   ; \
	                      mknod --mode=660 mmcblk1p1     b  179 9   ; \
	                      mknod --mode=660 mmcblk1p2     b  179 10  ; \
	                      mknod --mode=660 mmcblk1p3     b  179 11  ; \
	                      mknod --mode=660 mmcblk1p4     b  179 12  ; \
	                      \
	                      mknod --mode=660 mmcblk1boot0  b  179 16  ; \
	                      mknod --mode=660 mmcblk1boot1  b  179 24  ; \
	                      \
	                      mknod --mode=660 mtd0          c   90 0   ; \
	                      mknod --mode=660 mtd1          c   90 2   ; \
	                      mknod --mode=660 mtd2          c   90 4   ; \
	                      mknod --mode=660 mtd3          c   90 6   ; \
	                      mknod --mode=660 mtd4          c   90 8   ; \
	                      mknod --mode=660 mtd5          c   90 10  ; \
	                      mknod --mode=660 mtd6          c   90 12  ; \
	                      mknod --mode=660 mtd7          c   90 14  ; \
	                      \
	                      mknod --mode=640 mtdblock0     b   31 0   ; \
	                      mknod --mode=640 mtdblock1     b   31 1   ; \
	                      mknod --mode=640 mtdblock2     b   31 2   ; \
	                      mknod --mode=640 mtdblock3     b   31 3   ; \
	                      mknod --mode=640 mtdblock4     b   31 4   ; \
	                      mknod --mode=640 mtdblock5     b   31 5   ; \
	                      mknod --mode=640 mtdblock6     b   31 6   ; \
	                      mknod --mode=640 mtdblock7     b   31 7   ; \
	                      \
	                      mknod --mode=640 ram0          b    1 0   ; \
	                      mknod --mode=640 ram1          b    1 1   ; \
	                      mknod --mode=640 ram2          b    1 2   ; \
	                      mknod --mode=640 ram3          b    1 3   ; \
	                      \
	                      mknod --mode=666 tty           c    5 0   ; \
	                      \
	                      mknod --mode=660 ttyS0         c    4 64  ; \
	                      mknod --mode=660 ttyS1         c    4 65  ; \
	                      mknod --mode=660 ttyS2         c    4 66  ; \
	                      mknod --mode=660 ttyS3         c    4 67  ; \
	                      mknod --mode=660 ttyS4         c    4 68  ; \
	                      mknod --mode=660 ttyS5         c    4 69  ; \
	                      \
	                      mknod --mode=640 ttySA0        c  204 5   ; \
	                      mknod --mode=640 ttySA1        c  204 6   ; \
	                      mknod --mode=640 ttySA2        c  204 7   ; \
	                      \
	                      mknod --mode=640 cusa0         c  205 5   ; \
	                      mknod --mode=640 cusa1         c  205 6   ; \
	                      mknod --mode=640 cusa2         c  205 7   ; \
	                      \
	                      mknod --mode=600 initctl p ; \
	                      \
	                      mkdir -p cgroup ; chmod 755 cgroup ; \
	                      mkdir -p pts    ; chmod 755 pts    ; \
	                      mkdir -p shm    ; chmod 755 shm    ; \
	                      \
	                      ln -sf null XOR ; \
	                      \
	                      chown 0:5   tty ttySA? cusa?    ; \
	                      chown 0:16  ppp ttyS?           ; \
	                      chown 0:0   cgroup pts shm null random urandom zero apm_bios initctl ; \
	                      chown 0:18  fb0 fb1             ; \
	                      chown 0:6   ram? hda* sda* sdb* ; \
	                      chown 0:9   mem kmem            ; \
	                      chown 0:0   kmsg kvm            ; \
	                      chown 0:0   mtd? mtdblock? \
	                    ) && \
	                    $(MAKE_PACKAGE) --linkadd yes .."
