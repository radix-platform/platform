
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


SOURCE_REQUIRES      = sources/GNU/ncurses/5.9

REQUIRES             = app/gpm/1.20.7

# ======= __END_OF_REQUIRES__ =======


version              = 5.9
tar_gz_archive       = $(SRC_PACKAGE_PATH)/GNU/ncurses/$(version)/ncurses-$(version).tar.gz
patch_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/ncurses/$(version)/patch-$(version)-20130504.sh.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/ncurses-$(version)
src_dir_name         = ncurses-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

terminfo_files       = $(CURDIR)/terminfo/Eterm.ti
terminfo_files      += $(CURDIR)/terminfo/rxvt.terminfo
terminfo_files      += $(CURDIR)/terminfo/screeninfo.src
terminfo_files      += $(CURDIR)/terminfo/xterm.terminfo

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done

build_widec_dir      = $(TARGET_BUILD_DIR)/build-widec
build_widec_target   = $(TARGET_BUILD_DIR)/.build_widec_done
install_widec_target = $(TARGET_BUILD_DIR)/.install_widec_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NCURSES_PKG_NAME                = ncurses
NCURSES_PKG_VERSION             = 5.9
NCURSES_PKG_ARCH                = $(TOOLCHAIN)
NCURSES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NCURSES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NCURSES_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
NCURSES_PKG_SHORT_DESCRIPTION   = CRT screen handling and optimization package
NCURSES_PKG_URL                 = $(BUG_URL)
NCURSES_PKG_LICENSE             = GPLv2
NCURSES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NCURSES_PKG_NAME)-pkg-description
NCURSES_PKG_DESCRIPTION_FILE_IN = $(NCURSES_PKG_NAME)-pkg-description.in
NCURSES_PKG_INSTALL_SCRIPT      = $(NCURSES_PKG_NAME)-pkg-install.sh

NCURSES_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NCURSES_PKG_NAME)-package

pkg_basename     = $(NCURSES_PKG_NAME)-$(NCURSES_PKG_VERSION)-$(NCURSES_PKG_ARCH)-$(NCURSES_PKG_DISTRO_NAME)-$(NCURSES_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_widec_target)
BUILD_TARGETS   += $(install_widec_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(NCURSES_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gpm
extra_configure_switches += --disable-termcap
extra_configure_switches += --with-normal
extra_configure_switches += --with-shared
extra_configure_switches += --with-cxx-shared
extra_configure_switches += --enable-symlinks
extra_configure_switches += --enable-pc-files
extra_configure_switches += --with-pkg-config-libdir=/usr/lib$(LIBSUFFIX)/pkgconfig
extra_configure_switches += --without-debug
extra_configure_switches += --without-profile
extra_configure_switches += --without-ada
extra_configure_switches += --with-build-cc=gcc
extra_configure_switches += --program-suffix=""
extra_configure_switches += --program-prefix=""

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
extra_configure_switches += --with-chtype=long
extra_configure_switches += --with-mmask-t=long
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(patch_gz_archive) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@zcat $(patch_gz_archive) > $(SRC_DIR)/patch.sh
	@chmod a+x $(SRC_DIR)/patch.sh
	@( cd $(SRC_DIR) && ./patch.sh )
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) BUILD_CC=gcc ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NCURSES_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@touch $@

$(build_widec_target): $(install_target)
	@mkdir -p $(build_widec_dir)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  --enable-widec              \
	  $(extra_configure_switches)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_widec_target): $(build_widec_target)
	@mkdir -p $(NCURSES_PKG)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@if [ ! -d $(NCURSES_PKG)/usr/include/ncursesw -a ! -L $(NCURSES_PKG)/usr/include/ncursesw ] ; then \
	   ( cd $(NCURSES_PKG)/usr/include ; ln -sf ncurses ncursesw ) \
	 fi
	@( cd $(NCURSES_PKG)/usr/include ; \
	   rm -rf ncurses ; \
	   mkdir ncurses ; \
	   mv *.h ncurses ; \
	   for file in ncurses/* ; do \
	     ln -sf $$file . ; \
	   done ; \
	   mv termcap.h termcap-ncurses.h \
	 )
	@mkdir -p $(NCURSES_PKG)/lib$(LIBSUFFIX)
	@( cd $(NCURSES_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 *.so ; \
	   chmod 644 *.a ; \
	   cp -a libncurses.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX)    ; \
	   cp -a libncurses++.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX)  ; \
	   cp -a libncursesw.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX)   ; \
	   cp -a libncurses++w.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   mv libncurses.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX)     ; \
	   mv libncurses++.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX)   ; \
	   mv libncursesw.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX)    ; \
	   mv libncurses++w.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX)  ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses.so.5.? .    ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses++.so.5.? .  ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncursesw.so.5.? .   ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses++w.so.5.? . ; \
	   ln -sf libncursesw.a libcursesw.a           ; \
	   ln -sf libncurses++w.a libcurses++w.a       ; \
	   ln -sf libncursesw.so.5.? libcursesw.so     ; \
	   ln -sf libncurses++w.so.5.? libcurses++w.so ; \
	 )
	# ======= Fix the xterm, screen, rxvt, and Eterm entries: =======
	@( export TERMINFO=$(NCURSES_PKG)/usr/share/terminfo ; \
	   if [ -x /usr/bin/tic -o -x /bin/tic ] ; then \
	     for tfile in $(terminfo_files) ; do \
	       if [ -r $$tfile ]; then \
	         tic -v $$tfile ; \
	       fi ; \
	     done ; \
	   fi ; \
	   unset TERMINFO \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(NCURSES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/ANNOUNCE $(SRC_DIR)/AUTHORS $(SRC_DIR)/README \
	       $(NCURSES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NCURSES_PKG)/usr/share/doc/$(src_dir_name)/c++
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE AUTHORS INSTALL README* TO-DO \
	         doc/{hackguide.doc,ncurses-intro.doc} \
	       $(NCURSES_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a c++/{NEWS,PROBLEMS,README-first} \
	       $(NCURSES_PKG)/usr/share/doc/$(src_dir_name)/c++ ; \
	   cp -ar doc/html $(NCURSES_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r NEWS ] ; then \
	     DOCSDIR=`echo $(NCURSES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat NEWS | head -n 1000 > $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     echo "        =======  SNIP  ======="    >> $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     echo "  see source code for full file  " >> $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     touch -r NEWS $$DOCSDIR/NEWS ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NCURSES_PKG))
	# ======= remove TARGET_DEST_DIR from ncurses-config scripts =======
	@( cd $(NCURSES_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" ncurses5-config ncursesw5-config \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
	                                            ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(NCURSES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(NCURSES_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(NCURSES_PKG_DESCRIPTION_FILE): $(NCURSES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_widec_target) $(NCURSES_PKG_DESCRIPTION_FILE) $(NCURSES_PKG_INSTALL_SCRIPT)
	@cp $(NCURSES_PKG_DESCRIPTION_FILE) $(NCURSES_PKG)/.DESCRIPTION
	@cp $(NCURSES_PKG_INSTALL_SCRIPT) $(NCURSES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NCURSES_PKG)/.REQUIRES
	@echo "pkgname=$(NCURSES_PKG_NAME)"                            >  $(NCURSES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NCURSES_PKG_VERSION)"                          >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "arch=$(NCURSES_PKG_ARCH)"                               >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "distroname=$(NCURSES_PKG_DISTRO_NAME)"                  >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "distrover=$(NCURSES_PKG_DISTRO_VERSION)"                >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "group=$(NCURSES_PKG_GROUP)"                             >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NCURSES_PKG_SHORT_DESCRIPTION)\"" >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "url=$(NCURSES_PKG_URL)"                                 >> $(NCURSES_PKG)/.PKGINFO ; \
	 echo "license=$(NCURSES_PKG_LICENSE)"                         >> $(NCURSES_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NCURSES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
