
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/s/Linux-PAM

REQUIRES           = secure/cracklib/2.9.5
REQUIRES          += net/libtirpc/1.1.4
REQUIRES          += dev/flex/2.6.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.8
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/s/Linux-PAM/Linux-PAM-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Linux-PAM-$(version)
src_dir_name       = Linux-PAM-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

doc_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/s/Linux-PAM/Linux-PAM-$(version)-docs.tar.bz2

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PAM_PKG_NAME                = pam
PAM_PKG_VERSION             = 1.1.8
PAM_PKG_ARCH                = $(TOOLCHAIN)
PAM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PAM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PAM_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
PAM_PKG_SHORT_DESCRIPTION   = Pluggable Authentication Modules for Linux
PAM_PKG_URL                 = $(BUG_URL)
PAM_PKG_LICENSE             = BSD
PAM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PAM_PKG_NAME)-pkg-description
PAM_PKG_DESCRIPTION_FILE_IN = $(PAM_PKG_NAME)-pkg-description.in
PAM_PKG_INSTALL_SCRIPT      = $(PAM_PKG_NAME)-pkg-install.sh

PAM_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PAM_PKG_NAME)-package

pkg_basename     = $(PAM_PKG_NAME)-$(PAM_PKG_VERSION)-$(PAM_PKG_ARCH)-$(PAM_PKG_DISTRO_NAME)-$(PAM_PKG_DISTRO_VERSION)

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


CC_FOR_BUILD  = gcc
BUILD_CFLAGS  = -I/usr/include
BUILD_LDFLAGS = -L/usr/lib64

env_build = CC_FOR_BUILD=$(CC_FOR_BUILD)   \
            BUILD_CFLAGS=$(BUILD_CFLAGS)   \
            BUILD_LDFLAGS=$(BUILD_LDFLAGS)


env_sysroot = DESTDIR=$(PAM_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --includedir=/usr/include/security
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib
extra_configure_switches += --enable-nis
extra_configure_switches += --disable-prelude
extra_configure_switches += --disable-selinux
extra_configure_switches += --disable-audit
extra_configure_switches += --disable-db
extra_configure_switches += --enable-isadir=../../lib$(LIBSUFFIX)/security
extra_configure_switches += --without-libiconv-prefix
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


TARGET_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@tar xjf $(doc_bz2_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(env_build) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PAM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(PAM_PKG)/var/lib
	@chmod -v 4755 $(PAM_PKG)/sbin/unix_chkpwd
	@mkdir -p $(PAM_PKG)/lib$(LIBSUFFIX)
	@( cd $(PAM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@( cd $(PAM_PKG)/usr/lib$(LIBSUFFIX)/security ; \
	   ln -sf pam_unix.so pam_unix_acct.so    ; \
	   ln -sf pam_unix.so pam_unix_auth.so    ; \
	   ln -sf pam_unix.so pam_unix_passwd.so  ; \
	   ln -sf pam_unix.so pam_unix_session.so ; \
	 )
	# ======= edit etc/security/limits.conf =======
	@( cd $(PAM_PKG)/etc/security ; \
	   sed -i 's,# End of file,*               -       rtprio          0\n# End of file,'       limits.conf ; \
	   sed -i 's,# End of file,*               -       nice            0\n# End of file,'       limits.conf ; \
	   sed -i 's,# End of file,@audio          -       rtprio          65\n# End of file,'      limits.conf ; \
	   sed -i 's,# End of file,@audio          -       nice           -10\n# End of file,'      limits.conf ; \
	   sed -i 's,# End of file,@audio          -       memlock         40000\n\n# End of file,' limits.conf ; \
	 )
	@mkdir -p $(PAM_PKG)/usr/share/doc/$(src_dir_name)/conf
	@cp -a $(build_dir)/conf/pam_conv1/pam_conv1 \
	       $(PAM_PKG)/usr/share/doc/$(src_dir_name)/conf
	@cp -a $(SRC_DIR)/conf/pam_conv1/README \
	       $(PAM_PKG)/usr/share/doc/$(src_dir_name)/conf
	# ======= install etc/pam.d base PAM configuration =======
	@mkdir -p $(PAM_PKG)/etc/pam.d
	@cp -a $(CURDIR)/pam.d/* $(PAM_PKG)/etc/pam.d
	@( cd $(PAM_PKG)/etc/security ; \
	   echo ""                                                                    >> access.conf ; \
	   echo "#"                                                                   >> access.conf ; \
	   echo "# User 'root' should get access from all till set up correct policy" >> access.conf ; \
	   echo "#"                                                                   >> access.conf ; \
	   echo "+ : root : ALL"                                                      >> access.conf ; \
	   echo ""                                                                    >> access.conf ; \
	 )
	# ======= prepare new files for post install =======
	@( cd $(PAM_PKG)/etc ; \
	   mv environment environment.new ; \
	 )
	@( cd $(PAM_PKG)/etc/security ; \
	   mv access.conf    access.conf.new    ; \
	   mv group.conf     group.conf.new     ; \
	   mv limits.conf    limits.conf.new    ; \
	   mv namespace.conf namespace.conf.new ; \
	   mv pam_env.conf   pam_env.conf.new   ; \
	   mv time.conf      time.conf.new      ; \
	 )
	# ======= archive man pages =======
	@( cd $(PAM_PKG)/usr/share/man/man5 ; \
	   rm -f pam.d.5 ; ln -sf pam.conf.5 pam.d.5 ; \
	 )
	@( cd $(PAM_PKG)/usr/share/man/man8 ; \
	   rm -f pam.8 ; ln -sf PAM.8 pam.8 ; \
	 )
	@( cd $(PAM_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(PAM_PKG)/usr/share/man ]; then \
	  ( cd $(PAM_PKG)/usr/share/man ; \
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
	# ======= install package documentation =======
	@mkdir -p $(PAM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/Copyright \
	       $(PAM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS CHANGELOG \
	         COPYING Copyright INSTALL NEWS README \
	         $(PAM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(PAM_PKG)/usr/share/doc/$(src_dir_name) ; mv index.html html )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PAM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= install html documentation =======
	@mkdir -p $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html/{adg,mwg,sag}
	@( cd $(SRC_DIR)/doc/adg ; \
	   cp -a *.txt $(PAM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a html/*.html $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html/adg ; \
	 )
	@( cd $(SRC_DIR)/doc/mwg ; \
	   cp -a *.txt $(PAM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a html/*.html $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html/mwg ; \
	 )
	@( cd $(SRC_DIR)/doc/sag ; \
	   cp -a *.txt $(PAM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a html/*.html $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html/sag ; \
	 )
	@( cd $(PAM_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	   sed -i "s,Linux-PAM_SAG,sag/Linux-PAM_SAG," index.html ; \
	   sed -i 's,<td width="20%" align="left"> </td>,<td width="20%" align="left"><a accesskey="h" href="../index.html">Home</a></td>,' sag/Linux-PAM_SAG.html ; \
	   sed -i "s,Linux-PAM_MWG,mwg/Linux-PAM_MWG," index.html ; \
	   sed -i 's,<td width="20%" align="left"> </td>,<td width="20%" align="left"><a accesskey="h" href="../index.html">Home</a></td>,' mwg/Linux-PAM_MWG.html ; \
	   sed -i "s,Linux-PAM_ADG,adg/Linux-PAM_ADG," index.html ; \
	   sed -i 's,<td width="20%" align="left"> </td>,<td width="20%" align="left"><a accesskey="h" href="../index.html">Home</a></td>,' adg/Linux-PAM_ADG.html ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PAM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpam.la libpam_misc.la libpamc.la \
	 )
	@( cd $(PAM_PKG)/usr/lib$(LIBSUFFIX)/security ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pam_*.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PAM_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpam.la libpam_misc.la libpamc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpam.la libpam_misc.la libpamc.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/security ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pam_*.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" pam_*.la \
	 )
	# ======= Strip binaries =======
	@( cd $(PAM_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(PAM_PKG); \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PAM_PKG)/usr/lib$(LIBSUFFIX)/security ; \
	   rpath=`$(CHRPATH) -l pam_cracklib.so 2> /dev/null | grep "R*PATH"` ; \
	   if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	     $(CHRPATH) -r $(TARGET_RPATH) pam_cracklib.so 1> /dev/null 2> /dev/null ; \
	   fi ; \
	 )
endif
	@touch $@

$(PAM_PKG_DESCRIPTION_FILE): $(PAM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PAM_PKG_DESCRIPTION_FILE) $(PAM_PKG_INSTALL_SCRIPT)
	@cp $(PAM_PKG_DESCRIPTION_FILE) $(PAM_PKG)/.DESCRIPTION
	@cp $(PAM_PKG_INSTALL_SCRIPT) $(PAM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PAM_PKG)/.REQUIRES
	@echo "pkgname=$(PAM_PKG_NAME)"                            >  $(PAM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PAM_PKG_VERSION)"                          >> $(PAM_PKG)/.PKGINFO ; \
	 echo "arch=$(PAM_PKG_ARCH)"                               >> $(PAM_PKG)/.PKGINFO ; \
	 echo "distroname=$(PAM_PKG_DISTRO_NAME)"                  >> $(PAM_PKG)/.PKGINFO ; \
	 echo "distrover=$(PAM_PKG_DISTRO_VERSION)"                >> $(PAM_PKG)/.PKGINFO ; \
	 echo "group=$(PAM_PKG_GROUP)"                             >> $(PAM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PAM_PKG_SHORT_DESCRIPTION)\"" >> $(PAM_PKG)/.PKGINFO ; \
	 echo "url=$(PAM_PKG_URL)"                                 >> $(PAM_PKG)/.PKGINFO ; \
	 echo "license=$(PAM_PKG_LICENSE)"                         >> $(PAM_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PAM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
