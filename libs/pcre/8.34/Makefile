
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/pcre

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/zlib/1.2.8
else
REQUIRES           = libs/zlib/1.2.8-x86_32
endif
endif
REQUIRES          += app/bzip2/1.0.6
REQUIRES          += libs/readline/6.3

# ======= __END_OF_REQUIRES__ =======


version            = 8.34
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/pcre/pcre-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pcre-$(version)
src_dir_name       = pcre-$(version)
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
PCRE_PKG_NAME                = pcre
PCRE_PKG_VERSION             = 8.34
PCRE_PKG_ARCH                = $(TOOLCHAIN)
PCRE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PCRE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PCRE_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
PCRE_PKG_SHORT_DESCRIPTION   = Perl-compatible regular expression library
PCRE_PKG_URL                 = $(BUG_URL)
PCRE_PKG_LICENSE             = GPLv2
PCRE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCRE_PKG_NAME)-pkg-description
PCRE_PKG_DESCRIPTION_FILE_IN = $(PCRE_PKG_NAME)-pkg-description.in
PCRE_PKG_INSTALL_SCRIPT      = $(PCRE_PKG_NAME)-pkg-install.sh

PCRE_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCRE_PKG_NAME)-package

pkg_basename     = $(PCRE_PKG_NAME)-$(PCRE_PKG_VERSION)-$(PCRE_PKG_ARCH)-$(PCRE_PKG_DISTRO_NAME)-$(PCRE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PCRE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-utf8
extra_configure_switches += --enable-pcre16
extra_configure_switches += --enable-pcre32
extra_configure_switches += --enable-unicode-properties

extra_configure_switches += --enable-pcregrep-libz
extra_configure_switches += --enable-pcregrep-libbz2
extra_configure_switches += --enable-pcretest-libreadline

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(PCRE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ====== Install Documentation =======
	@if [ -d $(PCRE_PKG)/usr/share/man ]; then \
	  ( cd $(PCRE_PKG)/usr/share/man ; \
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
	@mkdir -p $(PCRE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENCE $(SRC_DIR)/AUTHORS \
	       $(PCRE_PKG)/usr/doc/$(src_dir_name)
	@rm -f $(PCRE_PKG)/usr/share/doc/$(src_dir_name)/ChangeLog
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PCRE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PCRE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PCRE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.pc libpcre16.pc libpcre32.pc libpcrecpp.pc libpcreposix.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PCRE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PCRE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PCRE_PKG_DESCRIPTION_FILE): $(PCRE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PCRE_PKG_DESCRIPTION_FILE) $(PCRE_PKG_INSTALL_SCRIPT)
	@cp $(PCRE_PKG_DESCRIPTION_FILE) $(PCRE_PKG)/.DESCRIPTION
	@cp $(PCRE_PKG_INSTALL_SCRIPT) $(PCRE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCRE_PKG)/.REQUIRES
	@echo "pkgname=$(PCRE_PKG_NAME)"                            >  $(PCRE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCRE_PKG_VERSION)"                          >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "arch=$(PCRE_PKG_ARCH)"                               >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCRE_PKG_DISTRO_NAME)"                  >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCRE_PKG_DISTRO_VERSION)"                >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "group=$(PCRE_PKG_GROUP)"                             >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCRE_PKG_SHORT_DESCRIPTION)\"" >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "url=$(PCRE_PKG_URL)"                                 >> $(PCRE_PKG)/.PKGINFO ; \
	 echo "license=$(PCRE_PKG_LICENSE)"                         >> $(PCRE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PCRE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
