
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


SOURCE_REQUIRES    = sources/packages/l/unidata/netcdf-c

REQUIRES           = net/curl/7.47.0
REQUIRES          += net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 4.4.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/unidata/netcdf-c/netcdf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netcdf-$(version)
src_dir_name       = netcdf-$(version)
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
NETCDF_PKG_NAME                = netcdf
NETCDF_PKG_VERSION             = 4.4.1
NETCDF_PKG_ARCH                = $(TOOLCHAIN)
NETCDF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETCDF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETCDF_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
NETCDF_PKG_SHORT_DESCRIPTION   = network Common Data Form
NETCDF_PKG_URL                 = $(BUG_URL)
NETCDF_PKG_LICENSE             = custom
NETCDF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETCDF_PKG_NAME)-pkg-description
NETCDF_PKG_DESCRIPTION_FILE_IN = $(NETCDF_PKG_NAME)-pkg-description.in
NETCDF_PKG_INSTALL_SCRIPT      = $(NETCDF_PKG_NAME)-pkg-install.sh

NETCDF_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETCDF_PKG_NAME)-package

pkg_basename     = $(NETCDF_PKG_NAME)-$(NETCDF_PKG_VERSION)-$(NETCDF_PKG_ARCH)-$(NETCDF_PKG_DISTRO_NAME)-$(NETCDF_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(NETCDF_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-dap-netcdf
extra_configure_switches += --enable-mmap
extra_configure_switches += --enable-jna

extra_configure_switches += --enable-netcdf-4=no
extra_configure_switches += --enable-hdf4=no
extra_configure_switches += --enable-parallel-tests=no
extra_configure_switches += --enable-valgrind-tests=no
extra_configure_switches += --enable-extra-tests=no

extra_configure_switches += --enable-large-file-tests=no
extra_configure_switches += --enable-benchmarks=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(NETCDF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(NETCDF_PKG)/usr/lib$(LIBSUFFIX)/libnetcdf.settings
	# ======= Install Documentation =======
	@if [ -d $(NETCDF_PKG)/usr/share/man ]; then \
	  ( cd $(NETCDF_PKG)/usr/share/man ; \
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
	@mkdir -p $(NETCDF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(NETCDF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NETCDF_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT INSTALL.md README.md \
	         $(NETCDF_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NETCDF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(NETCDF_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnetcdf.la ; \
	 )
	# ======= tune nc-config prefix to the target destination for development =======
	@( cd $(NETCDF_PKG)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" nc-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETCDF_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnetcdf.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnetcdf.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" netcdf.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" netcdf.pc ; \
	 )
	# ======= tune pkg-config *.pc search path to the target machine =======
	@( cd $(NETCDF_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,^\(ccompiler=\).*,\1/usr/bin/gcc,g" netcdf.pc ; \
	 )
	# ======= tune nc-config prefix to the target machine =======
	@( cd $(NETCDF_PKG)/usr/bin ; \
	   sed -i "s,prefix=$(TARGET_DEST_DIR)/usr,prefix=/usr,g" nc-config ; \
	   sed -i "s,^\(cc=\).*,\1\"/usr/bin/gcc\",g"             nc-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(NETCDF_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(NETCDF_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH" | cut -f2 -d'='` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       rpath=`echo $$rpath | sed "s,$(TARGET_DEST_DIR),,g"` ; \
	       $(CHRPATH) -r $$rpath $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(NETCDF_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH" | cut -f2 -d'='` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       rpath=`echo $$rpath | sed "s,$(TARGET_DEST_DIR),,g"` ; \
	       $(CHRPATH) -r $$rpath $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(NETCDF_PKG_DESCRIPTION_FILE): $(NETCDF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETCDF_PKG_DESCRIPTION_FILE) $(NETCDF_PKG_INSTALL_SCRIPT)
	@cp $(NETCDF_PKG_DESCRIPTION_FILE) $(NETCDF_PKG)/.DESCRIPTION
	@cp $(NETCDF_PKG_INSTALL_SCRIPT) $(NETCDF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETCDF_PKG)/.REQUIRES
	@echo "pkgname=$(NETCDF_PKG_NAME)"                            >  $(NETCDF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETCDF_PKG_VERSION)"                          >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "arch=$(NETCDF_PKG_ARCH)"                               >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETCDF_PKG_DISTRO_NAME)"                  >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETCDF_PKG_DISTRO_VERSION)"                >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "group=$(NETCDF_PKG_GROUP)"                             >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETCDF_PKG_SHORT_DESCRIPTION)\"" >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "url=$(NETCDF_PKG_URL)"                                 >> $(NETCDF_PKG)/.PKGINFO ; \
	 echo "license=$(NETCDF_PKG_LICENSE)"                         >> $(NETCDF_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETCDF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
