
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/schroedinger

REQUIRES           = dev/orc/0.4.26.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/schroedinger/schroedinger-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/schroedinger-$(version)
src_dir_name       = schroedinger-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DIRAC_PKG_NAME                = schroedinger
DIRAC_PKG_VERSION             = 1.0.11
DIRAC_PKG_ARCH                = $(TOOLCHAIN)
DIRAC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DIRAC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DIRAC_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
DIRAC_PKG_SHORT_DESCRIPTION   = Dirac video codec
DIRAC_PKG_URL                 = $(BUG_URL)
DIRAC_PKG_LICENSE             = MIT
DIRAC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIRAC_PKG_NAME)-pkg-description
DIRAC_PKG_DESCRIPTION_FILE_IN = $(DIRAC_PKG_NAME)-pkg-description.in
DIRAC_PKG_INSTALL_SCRIPT      = $(DIRAC_PKG_NAME)-pkg-install.sh

DIRAC_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIRAC_PKG_NAME)-package

pkg_basename     = $(DIRAC_PKG_NAME)-$(DIRAC_PKG_VERSION)-$(DIRAC_PKG_ARCH)-$(DIRAC_PKG_DISTRO_NAME)-$(DIRAC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DIRAC_PKG)


ENABLE_GTK_DOCUMENTATION  = yes

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
extra_configure_switches += --enable-gtk-doc=yes
extra_configure_switches += --enable-gtk-doc-html=yes
extra_configure_switches += --enable-gtk-doc-pdf=no
else
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-gtk-doc-html=no
endif

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-strict-overflow


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DIRAC_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DIRAC_PKG)/usr/share/man ]; then \
	  ( cd $(DIRAC_PKG)/usr/share/man ; \
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
	@mkdir -p $(DIRAC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(DIRAC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DIRAC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS README TODO \
	         $(DIRAC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifneq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(DIRAC_PKG)/usr/share/gtk-doc/html/schroedinger
	@( cd $(SRC_DIR)/doc/html ; \
	   cp -a *.html *.sgml *.css *.png schroedinger.devhelp2 \
	         $(DIRAC_PKG)/usr/share/gtk-doc/html/schroedinger ; \
	 )
endif
	@ln -sf ../../gtk-doc/html/schroedinger $(DIRAC_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DIRAC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DIRAC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libschroedinger-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DIRAC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libschroedinger-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libschroedinger-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" schroedinger-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DIRAC_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DIRAC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DIRAC_PKG_DESCRIPTION_FILE): $(DIRAC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DIRAC_PKG_DESCRIPTION_FILE) $(DIRAC_PKG_INSTALL_SCRIPT)
	@cp $(DIRAC_PKG_DESCRIPTION_FILE) $(DIRAC_PKG)/.DESCRIPTION
	@cp $(DIRAC_PKG_INSTALL_SCRIPT) $(DIRAC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIRAC_PKG)/.REQUIRES
	@echo "pkgname=$(DIRAC_PKG_NAME)"                            >  $(DIRAC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIRAC_PKG_VERSION)"                          >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "arch=$(DIRAC_PKG_ARCH)"                               >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIRAC_PKG_DISTRO_NAME)"                  >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIRAC_PKG_DISTRO_VERSION)"                >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "group=$(DIRAC_PKG_GROUP)"                             >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIRAC_PKG_SHORT_DESCRIPTION)\"" >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "url=$(DIRAC_PKG_URL)"                                 >> $(DIRAC_PKG)/.PKGINFO ; \
	 echo "license=$(DIRAC_PKG_LICENSE)"                         >> $(DIRAC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DIRAC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
