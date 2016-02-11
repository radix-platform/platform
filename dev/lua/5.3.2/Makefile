
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/lua

REQUIRES           = libs/readline/6.3

# ======= __END_OF_REQUIRES__ =======


version            = 5.3.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lua/lua-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lua-$(version)
src_dir_name       = lua-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

multilib_header    = $(CURDIR)/multilib-header/luaconf.h

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LUA_PKG_NAME                = lua
LUA_PKG_VERSION             = 5.3.2
LUA_PKG_ARCH                = $(TOOLCHAIN)
LUA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LUA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LUA_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
LUA_PKG_SHORT_DESCRIPTION   = embeddable scripting language
LUA_PKG_URL                 = $(BUG_URL)
LUA_PKG_LICENSE             = MIT
LUA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LUA_PKG_NAME)-pkg-description
LUA_PKG_DESCRIPTION_FILE_IN = $(LUA_PKG_NAME)-pkg-description.in
LUA_PKG_INSTALL_SCRIPT      = $(LUA_PKG_NAME)-pkg-install.sh

LUA_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LUA_PKG_NAME)-package

pkg_basename     = $(LUA_PKG_NAME)-$(LUA_PKG_VERSION)-$(LUA_PKG_ARCH)-$(LUA_PKG_DISTRO_NAME)-$(LUA_PKG_DISTRO_VERSION)

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
	   sed -i "/#define LUA_CDIR/s:lib/lua/:lib$(LIBSUFFIX)/lua/:" src/luaconf.h \
	   sed -i "/INSTALL_LIB/s:/lib:/lib$(LIBSUFFIX):"  Makefile ; \
	   sed -i "/INSTALL_CMOD/s:/lib:/lib$(LIBSUFFIX):" Makefile ; \
	   sed -i "/INSTALL_LIB/s:/lib:/lib$(LIBSUFFIX):"  lua.pc ; \
	   sed -i "/INSTALL_CMOD/s:/lib:/lib$(LIBSUFFIX):" lua.pc ; \
	   sed -i "/libdir/s:/lib:/lib$(LIBSUFFIX):"       lua.pc ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) linux
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LUA_PKG)/usr/bin
	@mkdir -p $(LUA_PKG)/usr/include
	@mkdir -p $(LUA_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@mkdir -p $(LUA_PKG)/usr/share/man/man1
	@mkdir -p $(LUA_PKG)/usr/share/lua/`echo $(version) | sed 's/\([0-9][.0-9][0-9]*\)\([\.].*\)/\1/'`
	@mkdir -p $(LUA_PKG)/usr/lib$(LIBSUFFIX)/lua/`echo $(version) | sed 's/\([0-9][.0-9][0-9]*\)\([\.].*\)/\1/'`
	@( cd $(SRC_DIR)/src ; \
	   cp -a lua luac $(LUA_PKG)/usr/bin ; \
	   cp -a liblua.a liblua.so* $(LUA_PKG)/usr/lib$(LIBSUFFIX) ; \
	 )
	@( cd $(SRC_DIR)/src ; \
	   cp -a lauxlib.h lua.h lua.hpp lualib.h $(LUA_PKG)/usr/include ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@cp -a $(SRC_DIR)/src/luaconf.h $(LUA_PKG)/usr/include/luaconf-64.h
	@cp -a $(multilib_header) $(LUA_PKG)/usr/include
else
	@cp -a $(SRC_DIR)/src/luaconf.h $(LUA_PKG)/usr/include
endif
	@cp -a $(SRC_DIR)/lua.pc $(LUA_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	# ======= Install Documentation =======
	@( cd $(SRC_DIR)/doc ; \
	   cp -a *.1 \
	         $(LUA_PKG)/usr/share/man/man1 ; \
	 )
	@if [ -d $(LUA_PKG)/usr/share/man ]; then \
	  ( cd $(LUA_PKG)/usr/share/man ; \
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
	@mkdir -p $(LUA_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   sed -i "s:doc/:html/:" README ; \
	   cp -a README \
	         $(LUA_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a *.html *.gif *.png *.css \
	         $(LUA_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LUA_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lua.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LUA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LUA_PKG_DESCRIPTION_FILE): $(LUA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LUA_PKG_DESCRIPTION_FILE) $(LUA_PKG_INSTALL_SCRIPT)
	@cp $(LUA_PKG_DESCRIPTION_FILE) $(LUA_PKG)/.DESCRIPTION
	@cp $(LUA_PKG_INSTALL_SCRIPT) $(LUA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LUA_PKG)/.REQUIRES
	@echo "pkgname=$(LUA_PKG_NAME)"                            >  $(LUA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LUA_PKG_VERSION)"                          >> $(LUA_PKG)/.PKGINFO ; \
	 echo "arch=$(LUA_PKG_ARCH)"                               >> $(LUA_PKG)/.PKGINFO ; \
	 echo "distroname=$(LUA_PKG_DISTRO_NAME)"                  >> $(LUA_PKG)/.PKGINFO ; \
	 echo "distrover=$(LUA_PKG_DISTRO_VERSION)"                >> $(LUA_PKG)/.PKGINFO ; \
	 echo "group=$(LUA_PKG_GROUP)"                             >> $(LUA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LUA_PKG_SHORT_DESCRIPTION)\"" >> $(LUA_PKG)/.PKGINFO ; \
	 echo "url=$(LUA_PKG_URL)"                                 >> $(LUA_PKG)/.PKGINFO ; \
	 echo "license=$(LUA_PKG_LICENSE)"                         >> $(LUA_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LUA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
