
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/db

REQUIRES           = app/db/6.1.19

# ======= __END_OF_REQUIRES__ =======


version            = 6.1.19
major_version      = $(shell echo $(version) | cut -f 1 -d '.' )
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.' )
pack_version       = $(shell echo $(version) | cut -f 1,2 -d '.' | sed -e 's/\.//' )
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/db/db-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/db-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DB_32_PKG_NAME                = db-x32
DB_32_PKG_VERSION             = 6.1.19
DB_32_PKG_ARCH                = $(TOOLCHAIN)
DB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DB_32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
DB_32_PKG_SHORT_DESCRIPTION   = Berkeley DB
DB_32_PKG_URL                 = $(BUG_URL)
DB_32_PKG_LICENSE             = AGPLv3
DB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DB_32_PKG_NAME)-pkg-description
DB_32_PKG_DESCRIPTION_FILE_IN = $(DB_32_PKG_NAME)-pkg-description.in
DB_32_PKG_INSTALL_SCRIPT      = $(DB_32_PKG_NAME)-pkg-install.sh

DB_32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DB_32_PKG_NAME)-package

pkg_basename     = $(DB_32_PKG_NAME)-$(DB_32_PKG_VERSION)-$(DB_32_PKG_ARCH)-$(DB_32_PKG_DISTRO_NAME)-$(DB_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DB_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --enable-compat185
extra_configure_switches += --enable-cxx
extra_configure_switches += --enable-dbm
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-static


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) LIBSO_LIBS=-lpthread
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DB_32_PKG)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(DB_32_PKG)/usr/docs
	@rm -rf $(DB_32_PKG)/usr/include
	@mkdir -p $(DB_32_PKG)/usr/bin/32
	@( cd $(DB_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(DB_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(DB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libdb-$(short_version).so     ../../lib$(MULTILIB_X86_32_SUFFIX)       ; \
	   mv libdb_cxx-$(short_version).so ../../lib$(MULTILIB_X86_32_SUFFIX)       ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libdb-$(short_version).so     . ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libdb_cxx-$(short_version).so . ; \
	   rm -f libdb.a                                                             ; \
	   ln -sf libdb-$(short_version).a libdb-$(major_version).a                  ; \
	   ln -sf libdb-$(short_version).a libdb$(major_version).a                   ; \
	   ln -sf libdb-$(short_version).a libdb.a                                   ; \
	   rm -f libdb_cxx.a                                                         ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx-$(major_version).a          ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx$(major_version).a           ; \
	   ln -sf libdb_cxx-$(short_version).a libdb_cxx.a                           ; \
	   ln -sf libdb-$(short_version).so libdb-$(major_version).so                ; \
	   ln -sf libdb-$(short_version).so libdb$(major_version).so                 ; \
	   ln -sf libdb-$(short_version).so libdb.so                                 ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx-$(major_version).so        ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx$(major_version).so         ; \
	   ln -sf libdb_cxx-$(short_version).so libdb_cxx.so                         ; \
	 )
	@( cd $(DB_32_PKG)/usr/bin/32 ; \
	   for file in db_* ; do \
	     mv $$file `echo $$file | sed -e 's/_/$(pack_version)_/'` ; \
	     ln -sf `echo $$file | sed -e 's/_/$(pack_version)_/'` $$file ; \
	   done ; \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(DB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	   chmod 0755 *.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DB_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdb-?.?.la libdb_cxx-?.?.la \
	 )
	# ======= Strip binaries =======
	@( cd $(DB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DB_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DB_32_PKG_DESCRIPTION_FILE): $(DB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DB_32_PKG_DESCRIPTION_FILE) $(DB_32_PKG_INSTALL_SCRIPT)
	@cp $(DB_32_PKG_DESCRIPTION_FILE) $(DB_32_PKG)/.DESCRIPTION
	@cp $(DB_32_PKG_INSTALL_SCRIPT) $(DB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DB_32_PKG)/.REQUIRES
	@echo "pkgname=$(DB_32_PKG_NAME)"                            >  $(DB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DB_32_PKG_VERSION)"                          >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DB_32_PKG_ARCH)"                               >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DB_32_PKG_DISTRO_NAME)"                  >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DB_32_PKG_DISTRO_VERSION)"                >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "group=$(DB_32_PKG_GROUP)"                             >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DB_32_PKG_SHORT_DESCRIPTION)\"" >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "url=$(DB_32_PKG_URL)"                                 >> $(DB_32_PKG)/.PKGINFO ; \
	 echo "license=$(DB_32_PKG_LICENSE)"                         >> $(DB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
