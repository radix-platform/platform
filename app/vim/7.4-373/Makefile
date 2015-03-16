
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/vim

REQUIRES           = app/ctags/5.8
REQUIRES          += libs/ncurses/5.9
REQUIRES          += app/acl/2.2.52
REQUIRES          += app/attr/2.4.47
REQUIRES          += app/gawk/4.1.1
REQUIRES          += dev/perl/5.18.2
REQUIRES          += dev/python2/2.7.6

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 7.4-373
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/vim/vim-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vim-$(version)
src_dir_name       = vim-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(SRC_DIR)/src/auto/config.cache

crontab_cmd_text   = $(CURDIR)/config/crontab.command


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
VIM_PKG_NAME                = vim
VIM_PKG_VERSION             = 7.4-373
VIM_PKG_ARCH                = $(TOOLCHAIN)
VIM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VIM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VIM_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
VIM_PKG_SHORT_DESCRIPTION   = Vi IMproved
VIM_PKG_URL                 = $(BUG_URL)
VIM_PKG_LICENSE             = vim
VIM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VIM_PKG_NAME)-pkg-description
VIM_PKG_DESCRIPTION_FILE_IN = $(VIM_PKG_NAME)-pkg-description.in
VIM_PKG_INSTALL_SCRIPT      = $(VIM_PKG_NAME)-pkg-install.sh

VIM_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VIM_PKG_NAME)-package

pkg_basename     = $(VIM_PKG_NAME)-$(VIM_PKG_VERSION)-$(VIM_PKG_ARCH)-$(VIM_PKG_DISTRO_NAME)-$(VIM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(VIM_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --without-x
extra_configure_switches += --enable-gui=no
extra_configure_switches += --disable-gtktest
extra_configure_switches += --disable-xim
extra_configure_switches += --disable-netbeans
extra_configure_switches += --with-tlib=ncurses
extra_configure_switches += --enable-pythoninterp=yes
extra_configure_switches += --with-python-config-dir=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config
extra_configure_switches += --enable-perlinterp
extra_configure_switches += --disable-tclinterp
extra_configure_switches += --enable-multibyte
extra_configure_switches += --enable-cscope
extra_configure_switches += --with-features=huge
extra_configure_switches += --with-compiledby="<kosteltsev@gmail.com>"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	cat $(hw_cache_in) | sed -e 's,@LIBSUFFIX@,$(LIBSUFFIX),g' > $(hw_cache)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VIM_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Create Legacy Binary Links =======
	@( cd $(VIM_PKG)/usr/bin ; \
	   rm -rf eview     ; \
	   ln -sf vim eview ; \
	   rm -rf evim      ; \
	   ln -sf vim evim  ; \
	 )
	# ======= Add patched vimrc to the package =======
	@( cd $(SRC_DIR)/runtime ; \
	   cp vimrc_example.vim vimrc.new ; \
	   sed -i "/^endif \" has(\"autocmd\")/ r $(crontab_cmd_text)" vimrc.new ; \
	   cat vimrc.new > $(VIM_PKG)/usr/share/vim/vimrc.new ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(VIM_PKG)/usr/share/man ]; then \
	  ( cd $(VIM_PKG)/usr/share/man ; \
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
	@mkdir -p $(VIM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/README.txt \
	       $(VIM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(VIM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a README.txt src/INSTALLx.txt \
	         $(VIM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(VIM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../vim/vim$(shell echo $(version) | cut -f 1 -d '-' | sed -e "s,\.,,")/doc doc ; \
	 )
	@cp -a $(SRC_DIR)/.hg_archival.txt \
	       $(VIM_PKG)/usr/share/doc/$(src_dir_name)/hg-revision.txt
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(VIM_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(VIM_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(VIM_PKG_DESCRIPTION_FILE): $(VIM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VIM_PKG_DESCRIPTION_FILE) $(VIM_PKG_INSTALL_SCRIPT)
	@cp $(VIM_PKG_DESCRIPTION_FILE) $(VIM_PKG)/.DESCRIPTION
	@cp $(VIM_PKG_INSTALL_SCRIPT) $(VIM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VIM_PKG)/.REQUIRES
	@echo "pkgname=$(VIM_PKG_NAME)"                            >  $(VIM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VIM_PKG_VERSION)"                          >> $(VIM_PKG)/.PKGINFO ; \
	 echo "arch=$(VIM_PKG_ARCH)"                               >> $(VIM_PKG)/.PKGINFO ; \
	 echo "distroname=$(VIM_PKG_DISTRO_NAME)"                  >> $(VIM_PKG)/.PKGINFO ; \
	 echo "distrover=$(VIM_PKG_DISTRO_VERSION)"                >> $(VIM_PKG)/.PKGINFO ; \
	 echo "group=$(VIM_PKG_GROUP)"                             >> $(VIM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VIM_PKG_SHORT_DESCRIPTION)\"" >> $(VIM_PKG)/.PKGINFO ; \
	 echo "url=$(VIM_PKG_URL)"                                 >> $(VIM_PKG)/.PKGINFO ; \
	 echo "license=$(VIM_PKG_LICENSE)"                         >> $(VIM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(VIM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
