
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/libao

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
endif
REQUIRES          += libs/alsa-oss/1.0.28
REQUIRES          += app/esound/0.2.41

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/libao/libao-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libao-$(version)
src_dir_name       = libao-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBAO_PKG_NAME                = libao
LIBAO_PKG_VERSION             = 1.2.0
LIBAO_PKG_ARCH                = $(TOOLCHAIN)
LIBAO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBAO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBAO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
LIBAO_PKG_SHORT_DESCRIPTION   = Audio Output library
LIBAO_PKG_URL                 = $(BUG_URL)
LIBAO_PKG_LICENSE             = GPLv2
LIBAO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBAO_PKG_NAME)-pkg-description
LIBAO_PKG_DESCRIPTION_FILE_IN = $(LIBAO_PKG_NAME)-pkg-description.in
LIBAO_PKG_INSTALL_SCRIPT      = $(LIBAO_PKG_NAME)-pkg-install.sh

LIBAO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBAO_PKG_NAME)-package

pkg_basename     = $(LIBAO_PKG_NAME)-$(LIBAO_PKG_VERSION)-$(LIBAO_PKG_ARCH)-$(LIBAO_PKG_DISTRO_NAME)-$(LIBAO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBAO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-alsa
extra_configure_switches += --enable-alsa-mmap
extra_configure_switches += --enable-broken-oss
extra_configure_switches += --enable-esd
extra_configure_switches += --disable-esdtest
extra_configure_switches += --enable-pulse=no
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	@mkdir -p $(LIBAO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBAO_PKG)/usr/share/man ]; then \
	  ( cd $(LIBAO_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBAO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBAO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBAO_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(LIBAO_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv *.css *.html *.c html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README TODO \
	         $(LIBAO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBAO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBAO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libao.la  \
	 )
	@( cd $(LIBAO_PKG)/usr/lib$(LIBSUFFIX)/ao/plugins-4 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libalsa.la libesd.la liboss.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBAO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libao.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libao.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/ao/plugins-4 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libalsa.la libesd.la liboss.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libalsa.la libesd.la liboss.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ao.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBAO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared plugin objects =======
	@( cd $(LIBAO_PKG)/usr/lib$(LIBSUFFIX)/ao/plugins-4 ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBAO_PKG_DESCRIPTION_FILE): $(LIBAO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBAO_PKG_DESCRIPTION_FILE) $(LIBAO_PKG_INSTALL_SCRIPT)
	@cp $(LIBAO_PKG_DESCRIPTION_FILE) $(LIBAO_PKG)/.DESCRIPTION
	@cp $(LIBAO_PKG_INSTALL_SCRIPT) $(LIBAO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBAO_PKG)/.REQUIRES
	@echo "pkgname=$(LIBAO_PKG_NAME)"                            >  $(LIBAO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBAO_PKG_VERSION)"                          >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBAO_PKG_ARCH)"                               >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBAO_PKG_DISTRO_NAME)"                  >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBAO_PKG_DISTRO_VERSION)"                >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "group=$(LIBAO_PKG_GROUP)"                             >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBAO_PKG_SHORT_DESCRIPTION)\"" >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "url=$(LIBAO_PKG_URL)"                                 >> $(LIBAO_PKG)/.PKGINFO ; \
	 echo "license=$(LIBAO_PKG_LICENSE)"                         >> $(LIBAO_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBAO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
