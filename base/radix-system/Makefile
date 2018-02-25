
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


# ======= __END_OF_REQUIRES__ =======


source_etc  = $(CURDIR)/etc
modprobes   = $(CURDIR)/modprobe
scripts     = $(CURDIR)/scripts


PKG_GROUP = base

SYSINIT_BIN_PKG_NAME                = radix-system
SYSINIT_BIN_PKG_VERSION             = 1.3.0
SYSINIT_BIN_PKG_ARCH                = $(TOOLCHAIN)
SYSINIT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSINIT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSINIT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SYSINIT_BIN_PKG_SHORT_DESCRIPTION   = Radix System Scripts
SYSINIT_BIN_PKG_URL                 = $(BUG_URL)
SYSINIT_BIN_PKG_LICENSE             = LGPLv2.1
SYSINIT_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSINIT_BIN_PKG_NAME)-pkg-description
SYSINIT_BIN_PKG_DESCRIPTION_FILE_IN = $(SYSINIT_BIN_PKG_NAME)-pkg-description.in
SYSINIT_BIN_PKG_INSTALL_SCRIPT      = $(SYSINIT_BIN_PKG_NAME)-pkg-install.sh


SYSINIT_BIN_PKG = $(TARGET_BUILD_DIR)/$(SYSINIT_BIN_PKG_NAME)-package

build = $(TARGET_BUILD_DIR)/.done

pkg_basename    = $(SYSINIT_BIN_PKG_NAME)-$(SYSINIT_BIN_PKG_VERSION)-$(SYSINIT_BIN_PKG_ARCH)-$(SYSINIT_BIN_PKG_DISTRO_NAME)-$(SYSINIT_BIN_PKG_DISTRO_VERSION)

pkg_archive     = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature   = $(call sign-name,$(pkg_archive))
pkg_description = $(call desc-name,$(pkg_archive))
products        = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS   = $(build)

PRODUCT_TARGETS = $(products)

ROOTFS_TARGETS  = $(pkg_archive)


include ../../build-system/core.mk


NOCLEAR_FIRST_TTY =
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
NOCLEAR_FIRST_TTY = --noclear
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)   \
                                             $(HARDWARE_KHADAS_VIM2)),)
FB_BPP = 24
else
FB_BPP = 32
endif


$(build):
	@mkdir -p $(SYSINIT_BIN_PKG)/dev/{cgroup,pts,shm}
	@mkdir -p $(SYSINIT_BIN_PKG)/etc/{X11,rc.d,profile.d,skel}
	@mkdir -p $(SYSINIT_BIN_PKG)/{home,media,proc,root,run,sys,tmp}
	@mkdir -p $(SYSINIT_BIN_PKG)/var/{log,run,tmp}
	@touch $(SYSINIT_BIN_PKG)/var/log/{lastlog.new,wtmp}
	@touch $(SYSINIT_BIN_PKG)/var/run/utmp
	@( cd $(SYSINIT_BIN_PKG)/var ; \
	   ln -sf log adm ; \
	 )
	# ======= Common /etc files =======
	@( for file in csh.login filesystems group inputrc networks nsswitch.conf printcap \
	               profile passwd securetty services shadow shells termcap        ; do \
	     if [ -f $(source_etc)/$$file ] ; then \
	       cp -a $(source_etc)/$$file $(SYSINIT_BIN_PKG)/etc/$${file}.new ; \
	     fi ; \
	   done ; \
	 )
	@( for file in motd termcap-BSD termcap-Linux ; do \
	     if [ -f $(source_etc)/$$file ] ; then \
	       cp -a $(source_etc)/$$file $(SYSINIT_BIN_PKG)/etc ; \
	     fi ; \
	   done ; \
	 )
	@cp -a $(source_etc)/rc.d/rc.{local,local_shutdown,loop,sysvinit} $(SYSINIT_BIN_PKG)/etc/rc.d
	@( cd $(SYSINIT_BIN_PKG)/etc/rc.d ; \
	   mv rc.local           rc.local.new          ; \
	   mv rc.local_shutdown  rc.local_shutdown.new ; \
	   mv rc.loop            rc.loop.new           ; \
	   mv rc.sysvinit        rc.sysvinit.new       ; \
	 )
	@chmod a+x $(SYSINIT_BIN_PKG)/etc/rc.d/rc.{local.new,local_shutdown.new,sysvinit.new}
	# ======= Console Font config an modules config =======
	@cp -a $(source_etc)/rc.d/rc.{fbset,font,gpm,keymap,modules} $(SYSINIT_BIN_PKG)/etc/rc.d
	@( cd $(SYSINIT_BIN_PKG)/etc/rc.d ; \
	   mv rc.fbset    rc.fbset.new   ; \
	   mv rc.font     rc.font.new    ; \
	   mv rc.gpm      rc.gpm.new     ; \
	   mv rc.keymap   rc.keymap.new  ; \
	   mv rc.modules  rc.modules.new ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
	@cat $(scripts)/rc.meson8fb >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.fbset.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)   \
                                             $(HARDWARE_KHADAS_VIM2)),)
	@cat $(scripts)/rc.meson64fb >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.fbset.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_ODROID_C2)),)
	@cat $(scripts)/rc.odroidc2 >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.fbset.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
	@echo "# Ethernet:"                    >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe sunxi_gmac"      >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Wi-Fi/Bluetooth:"             >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe ap6210"          >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Mali:"                        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe mali_drm"        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe mali"            >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe disp_ump"        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Additional stuff:"            >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe cpufreq_stats"   >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe hid_logitech_dj" >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe spidev"          >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
	@echo "# Ethernet:"                    >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe sunxi_gmac"      >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Wi-Fi/Bluetooth:"             >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe ap6210"          >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Additional stuff:"            >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe cpufreq_stats"   >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe hid_logitech_dj" >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe spidev"          >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
	@echo "# PowerVR:"                     >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe bc_example"      >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
	@echo "# HW Random:"                   >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe rng-core"        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
	@cat $(modprobes)/modprobe.$(HARDWARE) >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
	@echo "# Mali:"                        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe mali"            >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe mali_drm"        >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# /sbin/modprobe ump"           >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo ""                               >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "# Additional stuff:"            >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe udl"             >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_ENYBOX_X2)   \
                            $(HARDWARE_KHADAS_VIM2)),)
	@echo "# Wi-Fi/Bluetooth:"             >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe dhd"             >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
	@echo "/sbin/modprobe bcmdhd"          >> $(SYSINIT_BIN_PKG)/etc/rc.d/rc.modules.new
endif
	@chmod a+x $(SYSINIT_BIN_PKG)/etc/rc.d/rc.{fbset.new,font.new,gpm.new,keymap.new,modules.new}
	# ======= etc/inittab =======
	@cat $(source_etc)/inittab.in | \
	     sed 's,@NOCLEAR@,$(NOCLEAR_FIRST_TTY),'  > $(SYSINIT_BIN_PKG)/etc/inittab.new
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB2X)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)         \
                            $(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)   \
                                             $(HARDWARE_KHADAS_VIM2)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS4 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
	@echo "mxc1:12345:respawn:/sbin/agetty -L ttymxc1 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS2 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DRA7XXEVM)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
	@echo "s1:12345:respawn:/sbin/agetty -L ttyS0 115200 vt100" >> $(SYSINIT_BIN_PKG)/etc/inittab.new
endif
	@echo ""                                                    >> $(SYSINIT_BIN_PKG)/etc/inittab.new
	@echo "# End of /etc/inittab"                               >> $(SYSINIT_BIN_PKG)/etc/inittab.new
	# ======= etc/fstab =======
	@cp -a $(source_etc)/fstab $(SYSINIT_BIN_PKG)/etc/fstab.new
	# ======= etc/profile.d =======
	@cp -a $(source_etc)/profile.d/lang.{csh,sh} $(SYSINIT_BIN_PKG)/etc/profile.d
	@( cd $(SYSINIT_BIN_PKG)/etc/profile.d ; \
	   mv lang.csh lang.csh.new ; \
	   mv lang.sh  lang.sh.new  ; \
	 )
	@chmod a+x $(SYSINIT_BIN_PKG)/etc/profile.d/lang.{csh.new,sh.new}
	# ======= etc/rc.{4,6,K,M,S} =======
	@( for file in rc.{4,6,K,S} ; do \
	     if [ -f $(source_etc)/rc.d/$$file ] ; then \
	       cp -a $(source_etc)/rc.d/$$file $(SYSINIT_BIN_PKG)/etc/rc.d/$${file}.new ; \
	     fi ; \
	   done ; \
	 )
	@cat $(source_etc)/rc.d/rc.M.in | \
	     sed 's,@HARDWARE@,$(HARDWARE),' > $(SYSINIT_BIN_PKG)/etc/rc.d/rc.M.new
	@chmod a+x $(SYSINIT_BIN_PKG)/etc/rc.d/rc.{4.new,6.new,K.new,M.new,S.new}
	# ======= etc/profile.d =======
	@cat $(source_etc)/X11/xorg.conf.fbdev.in | \
	     sed 's,@HARDWARE_SPEC@,$(HW_SPEC),'  | \
	     sed 's,@DEFAULT_FB_BPP@,$(FB_BPP),'  > $(SYSINIT_BIN_PKG)/etc/X11/xorg.conf.fbdev
	@cat $(source_etc)/HOSTNAME.in | \
	     sed 's,@HARDWARE@,$(HARDWARE),' > $(SYSINIT_BIN_PKG)/etc/HOSTNAME.new
	@cat $(source_etc)/hosts.in | \
	     sed 's,@HARDWARE@,$(HARDWARE),g' > $(SYSINIT_BIN_PKG)/etc/hosts.new
	@cat $(source_etc)/radix-version.in | \
	     sed "s,@DISTRO_CAPTION@,$(DISTRO_CAPTION),g" | \
	     sed "s,@DISTRO_VERSION@,$(DISTRO_VERSION),g" > $(SYSINIT_BIN_PKG)/etc/radix-version
	@cat $(source_etc)/os-release.in | \
	     sed "s,@BUG_URL@,$(BUG_URL),g"               | \
	     sed "s,@DISTRO_NAME@,$(DISTRO_NAME),g"       | \
	     sed "s,@DISTRO_CAPTION@,$(DISTRO_CAPTION),g" | \
	     sed "s,@DISTRO_VERSION@,$(DISTRO_VERSION),g" > $(SYSINIT_BIN_PKG)/etc/os-release
	@cat $(source_etc)/issue.in | \
	     sed "s,@HW_SPEC@,$(HW_SPEC),g"               | \
	     sed "s,@DISTRO_CAPTION@,$(DISTRO_CAPTION),g" | \
	     sed "s,@DISTRO_VERSION@,$(DISTRO_VERSION),g" > $(SYSINIT_BIN_PKG)/etc/issue.new
	@touch $(SYSINIT_BIN_PKG)/etc/issue.net.new
	@touch $(SYSINIT_BIN_PKG)/etc/mtab
	@touch $(SYSINIT_BIN_PKG)/etc/gshadow.new
	@cat $(source_etc)/ld.so.conf.in | \
	     sed 's,@TARGET@,$(TARGET),'  > $(SYSINIT_BIN_PKG)/etc/ld.so.conf.new
	@touch $@

$(SYSINIT_BIN_PKG_DESCRIPTION_FILE): $(SYSINIT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(SYSINIT_BIN_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(SYSINIT_BIN_PKG_DESCRIPTION_FILE) $(SYSINIT_BIN_PKG_INSTALL_SCRIPT)
	@cp $(SYSINIT_BIN_PKG_DESCRIPTION_FILE) $(SYSINIT_BIN_PKG)/.DESCRIPTION
	@cp $(SYSINIT_BIN_PKG_INSTALL_SCRIPT) $(SYSINIT_BIN_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(SYSINIT_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(SYSINIT_BIN_PKG_NAME)"                            >  $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSINIT_BIN_PKG_VERSION)"                          >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSINIT_BIN_PKG_ARCH)"                               >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSINIT_BIN_PKG_DISTRO_NAME)"                  >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSINIT_BIN_PKG_DISTRO_VERSION)"                >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(SYSINIT_BIN_PKG_GROUP)"                             >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSINIT_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(SYSINIT_BIN_PKG_URL)"                                 >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(SYSINIT_BIN_PKG_LICENSE)"                         >> $(SYSINIT_BIN_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SYSINIT_BIN_PKG)  && \
	                  chown -R 0:0 .       && \
	                  chown -R 0:22 var/log/wtmp var/run/utmp && \
	                  $(MAKE_PACKAGE) --linkadd yes .."
