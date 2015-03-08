
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/s/shadow

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += secure/cracklib/2.9.1
REQUIRES          += secure/pam/1.1.8
REQUIRES          += secure/pam_unix2/2.9.1
REQUIRES          += app/acl/2.2.52

# ======= __END_OF_REQUIRES__ =======


version            = 4.2.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/s/shadow/shadow-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/shadow-$(version)
src_dir_name       = shadow-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

adduser_script_dir = $(CURDIR)/scripts
pam_d_dir          = $(CURDIR)/pam.d
license            = $(CURDIR)/license/LICENSE
login_defs         = $(CURDIR)/conf/login.defs
pam_doc_dir        = $(CURDIR)/doc


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SHADOW_PKG_NAME                = shadow
SHADOW_PKG_VERSION             = 4.2.1
SHADOW_PKG_ARCH                = $(TOOLCHAIN)
SHADOW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SHADOW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SHADOW_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
SHADOW_PKG_SHORT_DESCRIPTION   = shadow password suite
SHADOW_PKG_URL                 = $(BUG_URL)
SHADOW_PKG_LICENSE             = BSD
SHADOW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SHADOW_PKG_NAME)-pkg-description
SHADOW_PKG_DESCRIPTION_FILE_IN = $(SHADOW_PKG_NAME)-pkg-description.in
SHADOW_PKG_INSTALL_SCRIPT      = $(SHADOW_PKG_NAME)-pkg-install.sh

SHADOW_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SHADOW_PKG_NAME)-package

pkg_basename     = $(SHADOW_PKG_NAME)-$(SHADOW_PKG_VERSION)-$(SHADOW_PKG_ARCH)-$(SHADOW_PKG_DISTRO_NAME)-$(SHADOW_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SHADOW_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-libcrack
extra_configure_switches += --with-libpam
extra_configure_switches += --with-acl
extra_configure_switches += --with-attr
extra_configure_switches += --with-group-name-max-length=32
extra_configure_switches += --enable-subordinate-ids=no
extra_configure_switches += --without-selinux
extra_configure_switches += --without-audit


TARGET_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Supress etc/pam.d/* ; we prowide our own =======
	@( cd $(SRC_DIR) ; sed -i '/^SUBDIRS/s/pam\.d//' etc/Makefile.in )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SHADOW_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Provide etc/pam.d =======
	@mkdir -p $(SHADOW_PKG)/etc/pam.d
	@for file in login passwd su ; do \
	   cp -a $(pam_d_dir)/$$file $(SHADOW_PKG)/etc/pam.d/$$file.new ; \
	 done
	@for PROG in chage chfn chgpasswd chpasswd chsh groupadd groupdel \
	             groupmems groupmod newusers useradd userdel usermod ; do \
	   cat $(pam_d_dir)/default.pam | sed "s/@PROG@/$$PROG/" > $(SHADOW_PKG)/etc/pam.d/$$PROG.new ; \
	 done
	# ======= /bin/groups is provided by coreutils =======
	@rm -f $(SHADOW_PKG)/bin/groups
	@find $(SHADOW_PKG) -name groups.1 -exec rm {} \;
	@cp -a $(login_defs) $(SHADOW_PKG)/etc/login.defs
	@mv $(SHADOW_PKG)/etc/login.defs $(SHADOW_PKG)/etc/login.defs.new
	# ======= Create symbolic links =======
	@cp -a $(build_dir)/src/sulogin $(SHADOW_PKG)/sbin
	@( cd $(SHADOW_PKG)/bin ; ln -sf ../sbin/sulogin . )
	@mkdir -p $(SHADOW_PKG)/var/log
	@touch $(SHADOW_PKG)/var/log/faillog.new
	@touch $(SHADOW_PKG)/var/log/lastlog.new
	@cp -a $(adduser_script_dir)/adduser $(SHADOW_PKG)/usr/sbin
	@chmod 0755 $(SHADOW_PKG)/usr/sbin/adduser
	@( cd $(SHADOW_PKG)/usr/bin ; \
	   mv faillog ../sbin ; \
	   mv lastlog ../sbin ; \
	   ln -s ../sbin/faillog ; \
	   ln -s ../sbin/lastlog ; \
	 )
	# ======= Use 4711 rather than 4755 permissions where setuid root is required =======
	@find $(SHADOW_PKG) -type f -perm 4755 -exec chmod 4711 "{}" \;
	@( cd $(SHADOW_PKG)/usr/share/man ; \
	   for page in `find . -type f -exec echo {} \;` ; do        \
	     if [ -n "`cat $$page | grep '^\.so '`" ] ; then         \
	       dir=`dirname $$page | sed 's,^\./,,'` ;               \
	       ( cd $$dir ;                                          \
	         for file in * ; do                                  \
	           ln=`head -n 1 $$file` ;                           \
	           if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	             origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	             origin=`basename $$origin` ;                    \
	             rm -f $$file ;                                  \
	             ln -sf $$origin $$file ;                        \
	           fi ;                                              \
	         done ;                                              \
	       ) ;                                                   \
	     fi ;                                                    \
	   done ;                                                    \
	 )
	@if [ -d $(SHADOW_PKG)/usr/share/man ]; then \
	  ( cd $(SHADOW_PKG)/usr/share/man ; \
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
	@mkdir -p $(SHADOW_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) $(SHADOW_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(SHADOW_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SHADOW_PKG)/usr/share/doc/$(src_dir_name)/PAM
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* NEWS README* TODO doc/{README*,HOWTO,WISHLIST,*.txt} \
	         $(SHADOW_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@cp -a $(pam_doc_dir)/* $(SHADOW_PKG)/usr/share/doc/$(src_dir_name)/PAM
	# ======= Install ChangeLog into docdir =======
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SHADOW_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(SHADOW_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(SHADOW_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SHADOW_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SHADOW_PKG_DESCRIPTION_FILE): $(SHADOW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SHADOW_PKG_DESCRIPTION_FILE) $(SHADOW_PKG_INSTALL_SCRIPT)
	@cp $(SHADOW_PKG_DESCRIPTION_FILE) $(SHADOW_PKG)/.DESCRIPTION
	@cp $(SHADOW_PKG_INSTALL_SCRIPT) $(SHADOW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SHADOW_PKG)/.REQUIRES
	@echo "pkgname=$(SHADOW_PKG_NAME)"                            >  $(SHADOW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SHADOW_PKG_VERSION)"                          >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "arch=$(SHADOW_PKG_ARCH)"                               >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "distroname=$(SHADOW_PKG_DISTRO_NAME)"                  >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "distrover=$(SHADOW_PKG_DISTRO_VERSION)"                >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "group=$(SHADOW_PKG_GROUP)"                             >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SHADOW_PKG_SHORT_DESCRIPTION)\"" >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "url=$(SHADOW_PKG_URL)"                                 >> $(SHADOW_PKG)/.PKGINFO ; \
	 echo "license=$(SHADOW_PKG_LICENSE)"                         >> $(SHADOW_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SHADOW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
