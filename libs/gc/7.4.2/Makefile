
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


SOURCE_REQUIRES    = sources/packages/l/gc
SOURCE_REQUIRES   += sources/packages/l/libatomic_ops

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.24
else
REQUIRES           = libs/glibc/2.24-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 7.4.2
libatomic_version  = 7.4.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/gc/gc-$(version).tar.gz
tar_gz_archive_ops = $(SRC_PACKAGE_PATH)/packages/l/libatomic_ops/libatomic_ops-$(libatomic_version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gc-$(version)
src_dir_name       = gc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done
ops_src_done       = $(TARGET_BUILD_DIR)/.ops-source-done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GC_PKG_NAME                = gc
GC_PKG_VERSION             = 7.4.2
GC_PKG_ARCH                = $(TOOLCHAIN)
GC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GC_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
GC_PKG_SHORT_DESCRIPTION   = garbage collector library
GC_PKG_URL                 = $(BUG_URL)
GC_PKG_LICENSE             = GPLv2
GC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GC_PKG_NAME)-pkg-description
GC_PKG_DESCRIPTION_FILE_IN = $(GC_PKG_NAME)-pkg-description.in
GC_PKG_INSTALL_SCRIPT      = $(GC_PKG_NAME)-pkg-install.sh

GC_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GC_PKG_NAME)-package

pkg_basename     = $(GC_PKG_NAME)-$(GC_PKG_VERSION)-$(GC_PKG_ARCH)-$(GC_PKG_DISTRO_NAME)-$(GC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-cplusplus
extra_configure_switches += --enable-large-config
extra_configure_switches += --enable-parallel-mark
extra_configure_switches += --enable-threads=posix
extra_configure_switches += --with-libatomic-ops=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

CFLAGS += -DUSE_GET_STACKBASE_FOR_MAIN


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(ops_src_done): $(src_done)
	@echo "Expanding $(tar_gz_archive_ops)"
	@tar xzf $(tar_gz_archive_ops) -C $(TARGET_BUILD_DIR)
	@cd $(SRC_DIR) ; ln -sf ../libatomic_ops-$(libatomic_version) libatomic_ops
	@( cd $(SRC_DIR) ; \
	   sed -i 's#pkgdata#doc#' doc/doc.am                    ; \
	   sed -i 's#pkgdata#doc#' libatomic_ops/Makefile.am     ; \
	   sed -i 's#pkgdata#doc#' libatomic_ops/doc/Makefile.am ; \
	   autoreconf -vif        ; \
	   automake --add-missing ; \
	 )
	@touch $@

$(build_target): $(ops_src_done)
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
	@mkdir -p $(GC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(build_dir)/libatomic_ops && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(GC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/README.QUICK \
	       $(GC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GC_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/README.QUICK \
	       $(GC_PKG)/usr/share/doc/$(src_dir_name)
	@rm -f $(GC_PKG)/usr/share/doc/$(src_dir_name)/gc.man
	@mkdir -p $(GC_PKG)/usr/share/man/man3
	@( cd $(SRC_DIR) ; \
	   sed -i -e 's/GC_MALLOC 1L/gc 3/' doc/gc.man      ; \
	   install -m 644 doc/gc.man $(GC_PKG)/usr/share/man/man3/gc.3 ; \
	 )
	@if [ -d $(GC_PKG)/usr/share/man ]; then \
	  ( cd $(GC_PKG)/usr/share/man ; \
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
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                    libcord.la libgc.la libgccpp.la      ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                            libcord.la libgc.la libgccpp.la      ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libatomic_ops.la libatomic_ops_gpl.la  \
	                                              libcord.la libgc.la libgccpp.la      ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" atomic_ops.pc bdw-gc.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GC_PKG_DESCRIPTION_FILE): $(GC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)$(version_suffix)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GC_PKG_DESCRIPTION_FILE) $(GC_PKG_INSTALL_SCRIPT)
	@cp $(GC_PKG_DESCRIPTION_FILE) $(GC_PKG)/.DESCRIPTION
	@cp $(GC_PKG_INSTALL_SCRIPT) $(GC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GC_PKG)/.REQUIRES
	@echo "pkgname=$(GC_PKG_NAME)"                            >  $(GC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GC_PKG_VERSION)"                          >> $(GC_PKG)/.PKGINFO ; \
	 echo "arch=$(GC_PKG_ARCH)"                               >> $(GC_PKG)/.PKGINFO ; \
	 echo "distroname=$(GC_PKG_DISTRO_NAME)"                  >> $(GC_PKG)/.PKGINFO ; \
	 echo "distrover=$(GC_PKG_DISTRO_VERSION)"                >> $(GC_PKG)/.PKGINFO ; \
	 echo "group=$(GC_PKG_GROUP)"                             >> $(GC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GC_PKG_SHORT_DESCRIPTION)\"" >> $(GC_PKG)/.PKGINFO ; \
	 echo "url=$(GC_PKG_URL)"                                 >> $(GC_PKG)/.PKGINFO ; \
	 echo "license=$(GC_PKG_LICENSE)"                         >> $(GC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
