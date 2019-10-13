
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libgphoto2

REQUIRES           = libs/libgphoto2/2.5.10
REQUIRES          += libs/libexif/0.6.21-x86_32
REQUIRES          += libs/libgd/2.2.2-x86_32
REQUIRES          += libs/libusb/1.0.20-x86_32
REQUIRES          += libs/libxml2/2.9.9-x86_32
REQUIRES          += dev/libtool/2.4.6-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.5.10
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libgphoto2/libgphoto2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgphoto2-$(version)
src_dir_name       = libgphoto2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

port_version       = 0.12.0

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPHOTO2_32_PKG_NAME                = libgphoto2-x32
GPHOTO2_32_PKG_VERSION             = 2.5.10
GPHOTO2_32_PKG_ARCH                = $(TOOLCHAIN)
GPHOTO2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPHOTO2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPHOTO2_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GPHOTO2_32_PKG_SHORT_DESCRIPTION   = Library for access to digital cameras
GPHOTO2_32_PKG_URL                 = $(BUG_URL)
GPHOTO2_32_PKG_LICENSE             = LGPLv2.1
GPHOTO2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPHOTO2_32_PKG_NAME)-pkg-description
GPHOTO2_32_PKG_DESCRIPTION_FILE_IN = $(GPHOTO2_32_PKG_NAME)-pkg-description.in
GPHOTO2_32_PKG_INSTALL_SCRIPT      = $(GPHOTO2_32_PKG_NAME)-pkg-install.sh

GPHOTO2_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPHOTO2_32_PKG_NAME)-package

pkg_basename     = $(GPHOTO2_32_PKG_NAME)-$(GPHOTO2_32_PKG_VERSION)-$(GPHOTO2_32_PKG_ARCH)-$(GPHOTO2_32_PKG_DISTRO_NAME)-$(GPHOTO2_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GPHOTO2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-doc-dir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

gphoto_environment  = udevscriptdir=/lib/udev
gphoto_environment += utilsdir=/usr/sbin


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(gphoto_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPHOTO2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(gphoto_environment) install $(env_sysroot)
	@rm -rf $(GPHOTO2_32_PKG)/usr/include
	@rm -rf $(GPHOTO2_32_PKG)/usr/share
	@rm -rf $(GPHOTO2_32_PKG)/usr/sbin
	@rm -rf $(GPHOTO2_32_PKG)/lib
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GPHOTO2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgphoto2.la libgphoto2_port.la \
	 )
	@( cd $(GPHOTO2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgphoto2/$(version) ; \
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
	@( cd $(GPHOTO2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgphoto2_port/$(port_version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" disk.la ptpip.la serial.la usb1.la    \
	                                    usbdiskdirect.la usbscsi.la vusb.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPHOTO2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgphoto2.la libgphoto2_port.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgphoto2.la libgphoto2_port.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgphoto2/$(version) ; \
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
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgphoto2_port/$(port_version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" disk.la ptpip.la serial.la usb1.la    \
	                                            usbdiskdirect.la usbscsi.la vusb.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" disk.la ptpip.la serial.la usb1.la    \
	                                              usbdiskdirect.la usbscsi.la vusb.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgphoto2.pc libgphoto2_port.pc \
	 )
	# ======= tune LDFLAGS in gphoto2-config file to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gphoto2-config ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gphoto2-port-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GPHOTO2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GPHOTO2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GPHOTO2_32_PKG_DESCRIPTION_FILE): $(GPHOTO2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPHOTO2_32_PKG_DESCRIPTION_FILE) $(GPHOTO2_32_PKG_INSTALL_SCRIPT)
	@cp $(GPHOTO2_32_PKG_DESCRIPTION_FILE) $(GPHOTO2_32_PKG)/.DESCRIPTION
	@cp $(GPHOTO2_32_PKG_INSTALL_SCRIPT) $(GPHOTO2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPHOTO2_32_PKG)/.REQUIRES
	@echo "pkgname=$(GPHOTO2_32_PKG_NAME)"                            >  $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPHOTO2_32_PKG_VERSION)"                          >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GPHOTO2_32_PKG_ARCH)"                               >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPHOTO2_32_PKG_DISTRO_NAME)"                  >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPHOTO2_32_PKG_DISTRO_VERSION)"                >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "group=$(GPHOTO2_32_PKG_GROUP)"                             >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPHOTO2_32_PKG_SHORT_DESCRIPTION)\"" >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "url=$(GPHOTO2_32_PKG_URL)"                                 >> $(GPHOTO2_32_PKG)/.PKGINFO ; \
	 echo "license=$(GPHOTO2_32_PKG_LICENSE)"                         >> $(GPHOTO2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GPHOTO2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
