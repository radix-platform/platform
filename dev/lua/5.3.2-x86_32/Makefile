
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/lua

REQUIRES           = dev/lua/5.3.2
REQUIRES          += libs/readline/6.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 5.3.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lua/lua-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lua-$(version)
src_dir_name       = lua-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LUA_32_PKG_NAME                = lua-x32
LUA_32_PKG_VERSION             = 5.3.2
LUA_32_PKG_ARCH                = $(TOOLCHAIN)
LUA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LUA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LUA_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LUA_32_PKG_SHORT_DESCRIPTION   = embeddable scripting language
LUA_32_PKG_URL                 = $(BUG_URL)
LUA_32_PKG_LICENSE             = MIT
LUA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LUA_32_PKG_NAME)-pkg-description
LUA_32_PKG_DESCRIPTION_FILE_IN = $(LUA_32_PKG_NAME)-pkg-description.in
LUA_32_PKG_INSTALL_SCRIPT      = $(LUA_32_PKG_NAME)-pkg-install.sh

LUA_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LUA_32_PKG_NAME)-package

pkg_basename     = $(LUA_32_PKG_NAME)-$(LUA_32_PKG_VERSION)-$(LUA_32_PKG_ARCH)-$(LUA_32_PKG_DISTRO_NAME)-$(LUA_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i "/#define LUA_CDIR/s:lib/lua/:lib$(MULTILIB_X86_32_SUFFIX)/lua/:" src/luaconf.h ; \
	   sed -i "/INSTALL_LIB/s:/lib:/lib$(MULTILIB_X86_32_SUFFIX):"  Makefile ; \
	   sed -i "/INSTALL_CMOD/s:/lib:/lib$(MULTILIB_X86_32_SUFFIX):" Makefile ; \
	   sed -i "/INSTALL_LIB/s:/lib:/lib$(MULTILIB_X86_32_SUFFIX):"  lua.pc ; \
	   sed -i "/INSTALL_CMOD/s:/lib:/lib$(MULTILIB_X86_32_SUFFIX):" lua.pc ; \
	   sed -i "/libdir/s:/lib:/lib$(MULTILIB_X86_32_SUFFIX):"       lua.pc ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) linux
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LUA_32_PKG)/usr/bin/32
	@mkdir -p $(LUA_32_PKG)/usr/include
	@mkdir -p $(LUA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	@mkdir -p $(LUA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/lua/`echo $(version) | sed 's/\([0-9][.0-9][0-9]*\)\([\.].*\)/\1/'`
	@( cd $(SRC_DIR)/src ; \
	   cp -a lua luac $(LUA_32_PKG)/usr/bin/32 ; \
	   cp -a liblua.a liblua.so* $(LUA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@cp -a $(SRC_DIR)/src/luaconf.h $(LUA_32_PKG)/usr/include/luaconf-32.h
	@cp -a $(SRC_DIR)/lua.pc $(LUA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LUA_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lua.pc ; \
	 )
	# ======= Strip bineries =======
	@( cd $(LUA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LUA_32_PKG_DESCRIPTION_FILE): $(LUA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LUA_32_PKG_DESCRIPTION_FILE) $(LUA_32_PKG_INSTALL_SCRIPT)
	@cp $(LUA_32_PKG_DESCRIPTION_FILE) $(LUA_32_PKG)/.DESCRIPTION
	@cp $(LUA_32_PKG_INSTALL_SCRIPT) $(LUA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LUA_32_PKG)/.REQUIRES
	@echo "pkgname=$(LUA_32_PKG_NAME)"                            >  $(LUA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LUA_32_PKG_VERSION)"                          >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LUA_32_PKG_ARCH)"                               >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LUA_32_PKG_DISTRO_NAME)"                  >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LUA_32_PKG_DISTRO_VERSION)"                >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "group=$(LUA_32_PKG_GROUP)"                             >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LUA_32_PKG_SHORT_DESCRIPTION)\"" >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "url=$(LUA_32_PKG_URL)"                                 >> $(LUA_32_PKG)/.PKGINFO ; \
	 echo "license=$(LUA_32_PKG_LICENSE)"                         >> $(LUA_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LUA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
