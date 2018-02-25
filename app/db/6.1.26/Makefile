
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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


SOURCE_REQUIRES    = sources/packages/a/db

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.26
else
REQUIRES           = libs/glibc/2.26-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 6.1.26
major_version      = $(shell echo $(version) | cut -f 1 -d '.' )
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.' )
pack_version       = $(shell echo $(version) | cut -f 1,2 -d '.' | sed -e 's/\.//' )
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/db/db-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/db-$(version)
src_dir_name       = db-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DB_PKG_NAME                = db
DB_PKG_VERSION             = 6.1.26
DB_PKG_ARCH                = $(TOOLCHAIN)
DB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DB_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
DB_PKG_SHORT_DESCRIPTION   = Berkeley DB
DB_PKG_URL                 = $(BUG_URL)
DB_PKG_LICENSE             = AGPLv3
DB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DB_PKG_NAME)-pkg-description
DB_PKG_DESCRIPTION_FILE_IN = $(DB_PKG_NAME)-pkg-description.in
DB_PKG_INSTALL_SCRIPT      = $(DB_PKG_NAME)-pkg-install.sh

DB_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DB_PKG_NAME)-package

pkg_basename     = $(DB_PKG_NAME)-$(DB_PKG_VERSION)-$(DB_PKG_ARCH)-$(DB_PKG_DISTRO_NAME)-$(DB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DB_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --enable-compat185
extra_configure_switches += --enable-cxx
extra_configure_switches += --enable-dbm
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-static

#
# NOTE:
# ====
#  Following LDFLAG sets the correct RPATH and prevent potencial mistake related
#  to chamge RPATH by chrpath utility in case when the size of RPATH string in the
#  object file is less then  required.
#
LDFLAGS += -Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/build_unix &&  \
	  $(BUILD_ENVIRONMENT) ../dist/configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) LIBSO_LIBS=-lpthread
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DB_PKG)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(DB_PKG)/usr/include ; \
	   mkdir -p db$(pack_version) ; \
	   mv *.h db$(pack_version)   ; \
	   for hf in db$(pack_version)/* ; do \
	     ln -sf $$hf . ; \
	   done ; \
	   ln -sf db$(pack_version) db$(major_version) ; \
	 )
	@mkdir -p $(DB_PKG)/lib$(LIBSUFFIX)
	@( cd $(DB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   mv libdb-$(short_version).so     ../../lib$(LIBSUFFIX)             ; \
	   mv libdb_cxx-$(short_version).so ../../lib$(LIBSUFFIX)             ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libdb-$(short_version).so     .       ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libdb_cxx-$(short_version).so .       ; \
	   rm -f libdb.a                                                      ; \
	   ln -sf libdb-$(short_version).a libdb-$(major_version).a           ; \
	   ln -sf libdb-$(short_version).a libdb$(major_version).a            ; \
	   ln -sf libdb-$(short_version).a libdb.a                            ; \
	   rm -f libdb_cxx.a                                                  ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx-$(major_version).a   ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx$(major_version).a    ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx.a                    ; \
	   ln -sf libdb-$(short_version).so libdb-$(major_version).so         ; \
	   ln -sf libdb-$(short_version).so libdb$(major_version).so          ; \
	   ln -sf libdb-$(short_version).so libdb.so                          ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx-$(major_version).so ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx$(major_version).so  ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx.so                  ; \
	 )
	@( cd $(DB_PKG)/usr/bin ; \
	   for file in db_* ; do \
	     mv $$file `echo $$file | sed -e 's/_/$(pack_version)_/'` ; \
	     ln -sf `echo $$file | sed -e 's/_/$(pack_version)_/'` $$file ; \
	   done ; \
	 )
	# ====== Install Documentation =======
	@mkdir -p $(DB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(DB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DB_PKG)/usr/share/doc/$(src_dir_name)
	@mv $(DB_PKG)/usr/docs $(DB_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README \
	         $(DB_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(DB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	   chmod 0755 *.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdb-?.?.la libdb_cxx-?.?.la \
	 )
	# ======= Strip binaries =======
	@( cd $(DB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DB_PKG)/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DB_PKG_DESCRIPTION_FILE): $(DB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DB_PKG_DESCRIPTION_FILE) $(DB_PKG_INSTALL_SCRIPT)
	@cp $(DB_PKG_DESCRIPTION_FILE) $(DB_PKG)/.DESCRIPTION
	@cp $(DB_PKG_INSTALL_SCRIPT) $(DB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DB_PKG)/.REQUIRES
	@echo "pkgname=$(DB_PKG_NAME)"                            >  $(DB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DB_PKG_VERSION)"                          >> $(DB_PKG)/.PKGINFO ; \
	 echo "arch=$(DB_PKG_ARCH)"                               >> $(DB_PKG)/.PKGINFO ; \
	 echo "distroname=$(DB_PKG_DISTRO_NAME)"                  >> $(DB_PKG)/.PKGINFO ; \
	 echo "distrover=$(DB_PKG_DISTRO_VERSION)"                >> $(DB_PKG)/.PKGINFO ; \
	 echo "group=$(DB_PKG_GROUP)"                             >> $(DB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DB_PKG_SHORT_DESCRIPTION)\"" >> $(DB_PKG)/.PKGINFO ; \
	 echo "url=$(DB_PKG_URL)"                                 >> $(DB_PKG)/.PKGINFO ; \
	 echo "license=$(DB_PKG_LICENSE)"                         >> $(DB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
