
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


SOURCE_REQUIRES    = sources/packages/n/libnetfilter_log

REQUIRES           = net/libnfnetlink/1.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libnetfilter_log/libnetfilter_log-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnetfilter_log-$(version)
src_dir_name       = libnetfilter_log-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNF_LOG_PKG_NAME                = libnetfilter_log
LIBNF_LOG_PKG_VERSION             = 1.0.1
LIBNF_LOG_PKG_ARCH                = $(TOOLCHAIN)
LIBNF_LOG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNF_LOG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNF_LOG_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBNF_LOG_PKG_SHORT_DESCRIPTION   = packet logging library
LIBNF_LOG_PKG_URL                 = $(BUG_URL)
LIBNF_LOG_PKG_LICENSE             = GPLv2
LIBNF_LOG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNF_LOG_PKG_NAME)-pkg-description
LIBNF_LOG_PKG_DESCRIPTION_FILE_IN = $(LIBNF_LOG_PKG_NAME)-pkg-description.in
LIBNF_LOG_PKG_INSTALL_SCRIPT      = $(LIBNF_LOG_PKG_NAME)-pkg-install.sh

LIBNF_LOG_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNF_LOG_PKG_NAME)-package

pkg_basename           = $(LIBNF_LOG_PKG_NAME)-$(LIBNF_LOG_PKG_VERSION)-$(LIBNF_LOG_PKG_ARCH)-$(LIBNF_LOG_PKG_DISTRO_NAME)-$(LIBNF_LOG_PKG_DISTRO_VERSION)

pkg_archive            = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature          = $(call sign-name,$(pkg_archive))
pkg_description        = $(call desc-name,$(pkg_archive))
products               = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS          = $(build_target)
BUILD_TARGETS         += $(install_target)

PRODUCT_TARGETS        = $(products)

ROOTFS_TARGETS         = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNF_LOG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBNF_LOG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBNF_LOG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBNF_LOG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBNF_LOG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBNF_LOG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBNF_LOG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(LIBNF_LOG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBNF_LOG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNF_LOG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnetfilter_log.la libnetfilter_log_libipulog.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNF_LOG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnetfilter_log.la libnetfilter_log_libipulog.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnetfilter_log.la libnetfilter_log_libipulog.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnetfilter_log.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNF_LOG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBNF_LOG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBNF_LOG_PKG_DESCRIPTION_FILE): $(LIBNF_LOG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNF_LOG_PKG_DESCRIPTION_FILE) $(LIBNF_LOG_PKG_INSTALL_SCRIPT)
	@cp $(LIBNF_LOG_PKG_DESCRIPTION_FILE) $(LIBNF_LOG_PKG)/.DESCRIPTION
	@cp $(LIBNF_LOG_PKG_INSTALL_SCRIPT) $(LIBNF_LOG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNF_LOG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNF_LOG_PKG_NAME)"                            >  $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNF_LOG_PKG_VERSION)"                          >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNF_LOG_PKG_ARCH)"                               >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNF_LOG_PKG_DISTRO_NAME)"                  >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNF_LOG_PKG_DISTRO_VERSION)"                >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNF_LOG_PKG_GROUP)"                             >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNF_LOG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNF_LOG_PKG_URL)"                                 >> $(LIBNF_LOG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNF_LOG_PKG_LICENSE)"                         >> $(LIBNF_LOG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBNF_LOG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
