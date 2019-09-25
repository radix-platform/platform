
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libgphoto2

REQUIRES           = libs/libexif/0.6.21
REQUIRES          += libs/libgd/2.2.2
REQUIRES          += libs/libusb/1.0.20
REQUIRES          += libs/libxml2/2.9.3
REQUIRES          += dev/libtool/2.4.6

# ======= __END_OF_REQUIRES__ =======


version            = 2.5.10
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libgphoto2/libgphoto2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgphoto2-$(version)
src_dir_name       = libgphoto2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

port_version       = 0.12.0
update_hwdb_in     = $(CURDIR)/scripts/update-gphoto-hwdb.in
udev_version       = 220


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPHOTO2_PKG_NAME                = libgphoto2
GPHOTO2_PKG_VERSION             = 2.5.10
GPHOTO2_PKG_ARCH                = $(TOOLCHAIN)
GPHOTO2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPHOTO2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPHOTO2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GPHOTO2_PKG_SHORT_DESCRIPTION   = Library for access to digital cameras
GPHOTO2_PKG_URL                 = $(BUG_URL)
GPHOTO2_PKG_LICENSE             = LGPLv2.1
GPHOTO2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPHOTO2_PKG_NAME)-pkg-description
GPHOTO2_PKG_DESCRIPTION_FILE_IN = $(GPHOTO2_PKG_NAME)-pkg-description.in
GPHOTO2_PKG_INSTALL_SCRIPT      = $(GPHOTO2_PKG_NAME)-pkg-install.sh

GPHOTO2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPHOTO2_PKG_NAME)-package

pkg_basename     = $(GPHOTO2_PKG_NAME)-$(GPHOTO2_PKG_VERSION)-$(GPHOTO2_PKG_ARCH)-$(GPHOTO2_PKG_DISTRO_NAME)-$(GPHOTO2_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GPHOTO2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --with-doc-dir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


gphoto_environment  = udevscriptdir=/lib/udev
gphoto_environment += utilsdir=/usr/sbin


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(gphoto_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(gphoto_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPHOTO2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(gphoto_environment) install $(env_sysroot)
	@mkdir -p $(GPHOTO2_PKG)/lib/udev/hwdb.d
	@mkdir -p $(GPHOTO2_PKG)/lib/udev/rules.d
	@mkdir -p $(GPHOTO2_PKG)/usr/sbin
	@cat $(update_hwdb_in) | \
	     sed -e 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g' | \
	     sed -e 's,@GPHOTO_VERSION@,$(version),g' | \
	     sed -e 's,@UDEV_VERSION@,$(udev_version),g' > $(GPHOTO2_PKG)/usr/sbin/update-gphoto-hwdb
	@chmod 0755 $(GPHOTO2_PKG)/usr/sbin/update-gphoto-hwdb
	@rm -f $(GPHOTO2_PKG)/usr/include/gphoto2/gphoto2
	# ======= Install Documentation =======
	@if [ -d $(GPHOTO2_PKG)/usr/share/man ]; then \
	  ( cd $(GPHOTO2_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(GPHOTO2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GPHOTO2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GPHOTO2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a HACKING INSTALL MAINTAINERS TESTERS \
	         $(GPHOTO2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPHOTO2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GPHOTO2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgphoto2.la libgphoto2_port.la \
	 )
	@( cd $(GPHOTO2_PKG)/usr/lib$(LIBSUFFIX)/libgphoto2/$(version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" adc65.la agfa_cl20.la aox.la ax203.la barbie.la        \
	                                    canon.la casio_qv.la clicksmart310.la digigr8.la       \
	                                    digita.la dimagev.la dimera3500.la directory.la        \
	                                    enigma13.la fuji.la gsmart300.la hp215.la iclick.la    \
	                                    jamcam.la jd11.la jl2005a.la jl2005c.la kodak_dc120.la \
	                                    kodak_dc210.la kodak_dc240.la kodak_dc3200.la          \
	                                    kodak_ez200.la konica.la konica_qm150.la largan.la     \
	                                    lg_gsm.la mars.la mustek.la panasonic_coolshot.la      \
	                                    panasonic_dc1000.la panasonic_dc1580.la                \
	                                    panasonic_l859.la pccam300.la pccam600.la pentax.la    \
	                                    polaroid_pdc320.la polaroid_pdc640.la                  \
	                                    polaroid_pdc700.la ptp2.la ricoh.la ricoh_g3.la        \
	                                    samsung.la sierra.la sipix_blink2.la sipix_web2.la     \
	                                    smal.la sonix.la sony_dscf1.la sony_dscf55.la          \
	                                    soundvision.la spca50x.la sq905.la st2205.la           \
	                                    stv0674.la stv0680.la sx330z.la topfield.la            \
	                                    toshiba_pdrm11.la tp6801.la                          ; \
	 )
	@( cd $(GPHOTO2_PKG)/usr/lib$(LIBSUFFIX)/libgphoto2_port/$(port_version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" disk.la ptpip.la serial.la usb1.la    \
	                                    usbdiskdirect.la usbscsi.la vusb.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPHOTO2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgphoto2.la libgphoto2_port.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgphoto2.la libgphoto2_port.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libgphoto2/$(version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" adc65.la agfa_cl20.la aox.la ax203.la barbie.la        \
	                                            canon.la casio_qv.la clicksmart310.la digigr8.la       \
	                                            digita.la dimagev.la dimera3500.la directory.la        \
	                                            enigma13.la fuji.la gsmart300.la hp215.la iclick.la    \
	                                            jamcam.la jd11.la jl2005a.la jl2005c.la kodak_dc120.la \
	                                            kodak_dc210.la kodak_dc240.la kodak_dc3200.la          \
	                                            kodak_ez200.la konica.la konica_qm150.la largan.la     \
	                                            lg_gsm.la mars.la mustek.la panasonic_coolshot.la      \
	                                            panasonic_dc1000.la panasonic_dc1580.la                \
	                                            panasonic_l859.la pccam300.la pccam600.la pentax.la    \
	                                            polaroid_pdc320.la polaroid_pdc640.la                  \
	                                            polaroid_pdc700.la ptp2.la ricoh.la ricoh_g3.la        \
	                                            samsung.la sierra.la sipix_blink2.la sipix_web2.la     \
	                                            smal.la sonix.la sony_dscf1.la sony_dscf55.la          \
	                                            soundvision.la spca50x.la sq905.la st2205.la           \
	                                            stv0674.la stv0680.la sx330z.la topfield.la            \
	                                            toshiba_pdrm11.la tp6801.la                          ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" adc65.la agfa_cl20.la aox.la ax203.la barbie.la        \
	                                              canon.la casio_qv.la clicksmart310.la digigr8.la       \
	                                              digita.la dimagev.la dimera3500.la directory.la        \
	                                              enigma13.la fuji.la gsmart300.la hp215.la iclick.la    \
	                                              jamcam.la jd11.la jl2005a.la jl2005c.la kodak_dc120.la \
	                                              kodak_dc210.la kodak_dc240.la kodak_dc3200.la          \
	                                              kodak_ez200.la konica.la konica_qm150.la largan.la     \
	                                              lg_gsm.la mars.la mustek.la panasonic_coolshot.la      \
	                                              panasonic_dc1000.la panasonic_dc1580.la                \
	                                              panasonic_l859.la pccam300.la pccam600.la pentax.la    \
	                                              polaroid_pdc320.la polaroid_pdc640.la                  \
	                                              polaroid_pdc700.la ptp2.la ricoh.la ricoh_g3.la        \
	                                              samsung.la sierra.la sipix_blink2.la sipix_web2.la     \
	                                              smal.la sonix.la sony_dscf1.la sony_dscf55.la          \
	                                              soundvision.la spca50x.la sq905.la st2205.la           \
	                                              stv0674.la stv0680.la sx330z.la topfield.la            \
	                                              toshiba_pdrm11.la tp6801.la                          ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libgphoto2_port/$(port_version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" disk.la ptpip.la serial.la usb1.la    \
	                                            usbdiskdirect.la usbscsi.la vusb.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" disk.la ptpip.la serial.la usb1.la    \
	                                              usbdiskdirect.la usbscsi.la vusb.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgphoto2.pc libgphoto2_port.pc \
	 )
	# ======= tune LDFLAGS in gphoto2-config file to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gphoto2-config ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gphoto2-port-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GPHOTO2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBGD_PKG)/usr/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBGD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GPHOTO2_PKG_DESCRIPTION_FILE): $(GPHOTO2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPHOTO2_PKG_DESCRIPTION_FILE) $(GPHOTO2_PKG_INSTALL_SCRIPT)
	@cp $(GPHOTO2_PKG_DESCRIPTION_FILE) $(GPHOTO2_PKG)/.DESCRIPTION
	@cp $(GPHOTO2_PKG_INSTALL_SCRIPT) $(GPHOTO2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPHOTO2_PKG)/.REQUIRES
	@echo "pkgname=$(GPHOTO2_PKG_NAME)"                            >  $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPHOTO2_PKG_VERSION)"                          >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "arch=$(GPHOTO2_PKG_ARCH)"                               >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPHOTO2_PKG_DISTRO_NAME)"                  >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPHOTO2_PKG_DISTRO_VERSION)"                >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "group=$(GPHOTO2_PKG_GROUP)"                             >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPHOTO2_PKG_SHORT_DESCRIPTION)\"" >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "url=$(GPHOTO2_PKG_URL)"                                 >> $(GPHOTO2_PKG)/.PKGINFO ; \
	 echo "license=$(GPHOTO2_PKG_LICENSE)"                         >> $(GPHOTO2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GPHOTO2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
