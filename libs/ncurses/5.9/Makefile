
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/GNU/ncurses/5.9


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES             = libs/ncurses/5.9-x86_32
else
REQUIRES             = app/gpm/1.20.7
endif

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

build_ncurses_pkg    = $(TARGET_BUILD_DIR)/.ncurses_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NCURSES_PKG_NAME                = ncurses
NCURSES_PKG_VERSION             = 5.9
ifeq ($(HARDWARE),$(TARGET_HOST))
NCURSES_PKG_ARCH                = $(shell uname -m)
else
NCURSES_PKG_ARCH                = $(TOOLCHAIN)
endif
NCURSES_PKG_DISTRO_NAME         = kxLab
NCURSES_PKG_DISTRO_VERSION      = 1.0
NCURSES_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
NCURSES_PKG_SHORT_DESCRIPTION   = ncurses $(version)
NCURSES_PKG_URL                 = http://www.kxLab.com
NCURSES_PKG_LICENSE             = GPLv2
NCURSES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NCURSES_PKG_NAME)-pkg-description
NCURSES_PKG_DESCRIPTION_FILE_IN = $(NCURSES_PKG_NAME)-pkg-description.in
NCURSES_PKG_INSTALL_SCRIPT      = $(NCURSES_PKG_NAME)-pkg-install.sh

NCURSES_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NCURSES_PKG_NAME)-package

pkg_basename     = $(NCURSES_PKG_NAME)-$(NCURSES_PKG_VERSION)-$(NCURSES_PKG_ARCH)-$(NCURSES_PKG_DISTRO_NAME)-$(NCURSES_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(NCURSES_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_ncurses_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(NCURSES_PKG)

OPTIMIZATION_FLAGS = -O3

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
# we use the same compiler as BUILD_CC and CC but we want to organize
# pseudo cross compilation process for the HARDWARE=host. When ncurses
# configure script seen that BUILD_CC == CC we have configuration error
# with suggestion to use TWO compilers for cross development.
# To prevent this issue we trick the mcurses-5.9/configure script by
# using -m64 compiler oprion.
CC += -m64
endif


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gpm
extra_configure_switches += --disable-termcap
extra_configure_switches += --with-normal
extra_configure_switches += --with-shared
extra_configure_switches += --enable-symlinks
extra_configure_switches += --enable-pc-files
extra_configure_switches += --with-pkg-config-libdir=/usr/lib$(LIBSUFFIX)/pkgconfig
extra_configure_switches += --without-debug
extra_configure_switches += --without-profile
extra_configure_switches += --without-ada
extra_configure_switches += --program-suffix=""
extra_configure_switches += --program-prefix=""

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
extra_configure_switches += --with-chtype=long
extra_configure_switches += --with-mmask-t=long
endif


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
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
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
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
	   cp -a libncurses.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   cp -a libncursesw.so.5 $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   mv libncurses.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   mv libncursesw.so.5.? $(NCURSES_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncurses.so.5.? . ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libncursesw.so.5.? . ; \
	   ln -sf libncursesw.a libcursesw.a ; \
	   ln -sf libncursesw.so.5.? libcursesw.so ; \
	 )
	# Fix the xterm, screen, rxvt, and Eterm entries:
#	@( export TERMINFO=$(NCURSES_PKG)/usr/share/terminfo ; \
#	   if [ -x /usr/bin/tic -o -x /bin/tic ] ; then \
#	     for tfile in $(terminfo_files) ; do \
#	       if [ -r $$tfile ]; then \
#	         tic -v $$tfile ; \
#	       fi ; \
#	     done ; \
#	   fi ; \
#	   unset TERMINFO \
#	 )
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
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(NCURSES_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
                                                    ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc \
	 )
	@(cd $(NCURSES_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NCURSES_PKG_DESCRIPTION_FILE): $(NCURSES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_ncurses_pkg): $(install_widec_target) $(NCURSES_PKG_DESCRIPTION_FILE)
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
	@$(FAKEROOT) sh -c "cd $(NCURSES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@