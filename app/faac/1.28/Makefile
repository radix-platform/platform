
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/audiocoding/faac

REQUIRES           = libs/mp4v2/2.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/audiocoding/faac/faac-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/faac-$(version)
src_dir_name       = faac-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FAAC_PKG_NAME                = faac
FAAC_PKG_VERSION             = 1.28
FAAC_PKG_ARCH                = $(TOOLCHAIN)
FAAC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FAAC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FAAC_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
FAAC_PKG_SHORT_DESCRIPTION   = MPEG-4 and MPEG-2 AAC encoder
FAAC_PKG_URL                 = $(BUG_URL)
FAAC_PKG_LICENSE             = LGPLv2
FAAC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FAAC_PKG_NAME)-pkg-description
FAAC_PKG_DESCRIPTION_FILE_IN = $(FAAC_PKG_NAME)-pkg-description.in
FAAC_PKG_INSTALL_SCRIPT      = $(FAAC_PKG_NAME)-pkg-install.sh

FAAC_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FAAC_PKG_NAME)-package

pkg_basename     = $(FAAC_PKG_NAME)-$(FAAC_PKG_VERSION)-$(FAAC_PKG_ARCH)-$(FAAC_PKG_DISTRO_NAME)-$(FAAC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FAAC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-pic

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CXXFLAGS += -Wno-write-strings -Wno-address


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   ./bootstrap ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FAAC_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(FAAC_PKG)/usr/share/man ]; then \
	  ( cd $(FAAC_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(FAAC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(FAAC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FAAC_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README TODO docs/*.pdf \
	         $(FAAC_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a docs/*.html \
	         $(FAAC_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FAAC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FAAC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfaac.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FAAC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfaac.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfaac.la \
	 )
	# ======= Strip binaries =======
	@( cd $(FAAC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FAAC_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FAAC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FAAC_PKG_DESCRIPTION_FILE): $(FAAC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FAAC_PKG_DESCRIPTION_FILE) $(FAAC_PKG_INSTALL_SCRIPT)
	@cp $(FAAC_PKG_DESCRIPTION_FILE) $(FAAC_PKG)/.DESCRIPTION
	@cp $(FAAC_PKG_INSTALL_SCRIPT) $(FAAC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FAAC_PKG)/.REQUIRES
	@echo "pkgname=$(FAAC_PKG_NAME)"                            >  $(FAAC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FAAC_PKG_VERSION)"                          >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "arch=$(FAAC_PKG_ARCH)"                               >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "distroname=$(FAAC_PKG_DISTRO_NAME)"                  >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "distrover=$(FAAC_PKG_DISTRO_VERSION)"                >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "group=$(FAAC_PKG_GROUP)"                             >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FAAC_PKG_SHORT_DESCRIPTION)\"" >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "url=$(FAAC_PKG_URL)"                                 >> $(FAAC_PKG)/.PKGINFO ; \
	 echo "license=$(FAAC_PKG_LICENSE)"                         >> $(FAAC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FAAC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
