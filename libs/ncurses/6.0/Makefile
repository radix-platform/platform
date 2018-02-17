
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES      = sources/GNU/ncurses/6.0

REQUIRES             = app/gpm/1.20.7

# ======= __END_OF_REQUIRES__ =======


version              = 6.0
date                 = 20160130
tar_gz_archive       = $(SRC_PACKAGE_PATH)/GNU/ncurses/$(version)/ncurses-$(version)-$(date).tgz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/ncurses-$(version)-$(date)
src_dir_name         = ncurses-$(version)-$(date)
doc_dir_name         = ncurses-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

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
NCURSES_PKG_VERSION             = 6.0
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
extra_configure_switches += --enable-overwrite
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

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
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
	@( cd $(NCURSES_PKG)/usr/include ; \
	   rm -rf ncurses ; \
	   mkdir ncurses ; \
	   mv *.h ncurses ; \
	   for file in ncurses/* ; do \
	     ln -sf $$file . ; \
	   done ; \
	   mv termcap.h termcap-ncurses.h \
	 )
	@if [ ! -d $(NCURSES_PKG)/usr/include/ncursesw -a ! -L $(NCURSES_PKG)/usr/include/ncursesw ] ; then \
	   ( cd $(NCURSES_PKG)/usr/include ; ln -sf ncurses ncursesw ) \
	 fi
	@mkdir -p $(NCURSES_PKG)/lib$(LIBSUFFIX)
	@( cd $(NCURSES_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 *.so ; \
	   chmod 644 *.a ; \
	   cp -a libncurses.so.6 $(NCURSES_PKG)/lib$(LIBSUFFIX)    ; \
	   cp -a libncurses++.so.6 $(NCURSES_PKG)/lib$(LIBSUFFIX)  ; \
	   cp -a libncursesw.so.6 $(NCURSES_PKG)/lib$(LIBSUFFIX)   ; \
	   cp -a libncurses++w.so.6 $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   mv libncurses.so.6.? $(NCURSES_PKG)/lib$(LIBSUFFIX)     ; \
	   mv libncurses++.so.6.? $(NCURSES_PKG)/lib$(LIBSUFFIX)   ; \
	   mv libncursesw.so.6.? $(NCURSES_PKG)/lib$(LIBSUFFIX)    ; \
	   mv libncurses++w.so.6.? $(NCURSES_PKG)/lib$(LIBSUFFIX)  ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses.so.6.? .    ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses++.so.6.? .  ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncursesw.so.6.? .   ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses++w.so.6.? . ; \
	   ln -sf libncursesw.a libcursesw.a           ; \
	   ln -sf libncurses++w.a libcurses++w.a       ; \
	   ln -sf libncursesw.so.6.? libcursesw.so     ; \
	   ln -sf libncurses++w.so.6.? libcurses++w.so ; \
	 )
	# ======= Check terminfo symbolic links =======
	@( cd $(NCURSES_PKG) ; \
	   for dir in `ls usr/share/terminfo` ; do \
	     if [ -d usr/share/terminfo/$${dir} ] ; then \
	       ( cd usr/share/terminfo/$${dir} ; \
	         for link in `ls` ; do \
	           if [ -L $${link} -a ! -f `readlink -f $${link}` ] ; then \
	             file=`readlink $${link}` ; file=`basename $${file}` ; \
	             ltr=$${file:0:1} ; \
	             ln -sf ../$${ltr}/$${file} $${link} ; \
	           fi ; \
	         done ; \
	       ) ; \
	     fi ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(NCURSES_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/ANNOUNCE $(SRC_DIR)/AUTHORS \
	       $(SRC_DIR)/COPYING $(SRC_DIR)/README $(SRC_DIR)/VERSION \
	       $(NCURSES_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(NCURSES_PKG)/usr/share/doc/$(doc_dir_name)/c++
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE AUTHORS COPYING INSTALL README* TO-DO VERSION \
	         doc/{hackguide.doc,ncurses-intro.doc} \
	       $(NCURSES_PKG)/usr/share/doc/$(doc_dir_name) ; \
	   cp -a c++/{NEWS,PROBLEMS,README-first} \
	       $(NCURSES_PKG)/usr/share/doc/$(doc_dir_name)/c++ ; \
	   cp -ar doc/html $(NCURSES_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r NEWS ] ; then \
	     DOCSDIR=`echo $(NCURSES_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat NEWS | head -n 1000 > $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     echo "        =======  SNIP  ======="    >> $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     echo "  see source code for full file  " >> $$DOCSDIR/NEWS ; \
	     echo ""                                  >> $$DOCSDIR/NEWS ; \
	     touch -r NEWS $$DOCSDIR/NEWS ; \
	   fi \
	 )
	# ======= remove TARGET_DEST_DIR from ncurses-config scripts =======
	@( cd $(NCURSES_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" ncurses6-config ncursesw6-config \
	 )
	# ======= remove TARGET_DEST_DIR from pkg-config *.pc files =======
	@( cd $(NCURSES_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
	                                    ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NCURSES_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
	                                              ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc \
	 )
	# ======= tune ncurses-config scripts for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i 's,prefix="/usr,prefix="$(TARGET_DEST_DIR)/usr,' ncurses6-config ncursesw6-config ; \
	   sed -i 's,libdir="/usr,libdir="$(TARGET_DEST_DIR)/usr,' ncurses6-config ncursesw6-config ; \
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
	@$(PSEUDO) sh -c "cd $(NCURSES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
