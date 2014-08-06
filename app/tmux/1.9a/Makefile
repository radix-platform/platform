
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/tmux

REQUIRES           = libs/ncurses/5.9
REQUIRES          += libs/libevent/2.0.21
REQUIRES          += app/util-linux/2.24.1


version            = 1.9a
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/tmux/tmux-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tmux-$(version)
src_dir_name       = tmux-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TMUX_PKG_NAME                = tmux
TMUX_PKG_VERSION             = 1.9a
TMUX_PKG_ARCH                = $(TOOLCHAIN)
TMUX_PKG_DISTRO_NAME         = kxLab
TMUX_PKG_DISTRO_VERSION      = 1.0
TMUX_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
TMUX_PKG_SHORT_DESCRIPTION   = tmux $(version)
TMUX_PKG_URL                 = $(BUG_URL)
TMUX_PKG_LICENSE             = BSD
TMUX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TMUX_PKG_NAME)-pkg-description
TMUX_PKG_DESCRIPTION_FILE_IN = $(TMUX_PKG_NAME)-pkg-description.in
TMUX_PKG_INSTALL_SCRIPT      = $(TMUX_PKG_NAME)-pkg-install.sh

TMUX_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TMUX_PKG_NAME)-package

pkg_basename     = $(TMUX_PKG_NAME)-$(TMUX_PKG_VERSION)-$(TMUX_PKG_ARCH)-$(TMUX_PKG_DISTRO_NAME)-$(TMUX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(TMUX_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man


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
	@mkdir -p $(TMUX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(TMUX_PKG)/usr/share/vim/vim74/syntax
	@cp -a $(SRC_DIR)/examples/tmux.vim $(TMUX_PKG)/usr/share/vim/vim74/syntax
	@mkdir -p $(TMUX_PKG)/usr/share/bash-completion/completions
	@cp -a $(SRC_DIR)/examples/bash_completion_tmux.sh $(TMUX_PKG)/usr/share/bash-completion/completions/tmux
	# ======= Install Documentation =======
	@if [ -d $(TMUX_PKG)/usr/share/man ]; then \
	  ( cd $(TMUX_PKG)/usr/share/man ; \
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
	@mkdir -p $(TMUX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(TMUX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TMUX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING FAQ README TODO examples \
	         $(TMUX_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(TMUX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(TMUX_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(TMUX_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(TMUX_PKG_DESCRIPTION_FILE): $(TMUX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TMUX_PKG_DESCRIPTION_FILE) $(TMUX_PKG_INSTALL_SCRIPT)
	@cp $(TMUX_PKG_DESCRIPTION_FILE) $(TMUX_PKG)/.DESCRIPTION
	@cp $(TMUX_PKG_INSTALL_SCRIPT) $(TMUX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TMUX_PKG)/.REQUIRES
	@echo "pkgname=$(TMUX_PKG_NAME)"                            >  $(TMUX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TMUX_PKG_VERSION)"                          >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "arch=$(TMUX_PKG_ARCH)"                               >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "distroname=$(TMUX_PKG_DISTRO_NAME)"                  >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "distrover=$(TMUX_PKG_DISTRO_VERSION)"                >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "group=$(TMUX_PKG_GROUP)"                             >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TMUX_PKG_SHORT_DESCRIPTION)\"" >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "url=$(TMUX_PKG_URL)"                                 >> $(TMUX_PKG)/.PKGINFO ; \
	 echo "license=$(TMUX_PKG_LICENSE)"                         >> $(TMUX_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TMUX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
