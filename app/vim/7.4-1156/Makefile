
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/a/vim

REQUIRES           = app/ctags/5.8
REQUIRES          += libs/ncurses/6.0
REQUIRES          += app/acl/2.2.52
REQUIRES          += app/gawk/4.1.1
REQUIRES          += dev/python2/2.7.11
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += dev/perl/5.22.1
else
REQUIRES          += dev/perl/5.22.1-x86_32
endif

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 7.4-1156
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/vim/vim-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
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
VIM_PKG_VERSION             = 7.4-1156
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
extra_configure_switches += --enable-perlinterp=dynamic
extra_configure_switches += --disable-tclinterp
extra_configure_switches += --enable-multibyte
extra_configure_switches += --enable-cscope
extra_configure_switches += --with-features=huge
extra_configure_switches += --with-compiledby="<kosteltsev@gmail.com>"


#######
####### Perl5 architectures (see: dev/perl)
#######
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH = x86_32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_OMAP5UEVM)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
ARCH = mips32r2
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
ARCH = mips32r5
endif

PERL_TARGET_CORE = /usr/lib$(LIBSUFFIX)/perl5/$(ARCH)-linux/CORE

CFLAGS  += -I$(TARGET_DEST_DIR)$(PERL_TARGET_CORE)
LDFLAGS += -Wl,-E -Wl,-rpath,$(PERL_TARGET_CORE) -L$(TARGET_DEST_DIR)$(PERL_TARGET_CORE)

#
# NOTE: file scr/auto/config.mk should contents somethink like follow:
#
# PERL_LIBS     = -Wl,-E -Wl,-rpath,$(PERL_TARGET_CORE)  -fstack-protector  -L$(TARGET_DEST_DIR)$(PERL_TARGET_CORE) -lperl -lnsl -ldl -lm -lcrypt -lutil -lpthread -lc
# PERL_SRC      = auto/if_perl.c if_perlsfio.c
# PERL_OBJ      = objects/if_perl.o objects/if_perlsfio.o
# PERL_PRO      = if_perl.pro if_perlsfio.pro
# ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
# __LARGEFILE_SRC__  =  -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
# endif
# PERL_CFLAGS   = -DDYNAMIC_PERL_DLL=\"libperl.so\"  -D_REENTRANT -D_GNU_SOURCE  -fstack-protector $(__LARGEFILE_SRC__) -I$(TARGET_DEST_DIR)$(PERL_TARGET_CORE)


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
	@( cd $(SRC_DIR)/src/auto ; \
	   sed -i "s,-I/usr/include,-I$(TARGET_DEST_DIR)/usr/include,g" config.mk ; \
	   sed -i "s,-I/usr/lib[a-z/0-9]*/CORE,-I$(TARGET_DEST_DIR)$(PERL_TARGET_CORE),g" config.mk ; \
	   sed -i "s,-L/usr/lib[a-z/0-9]*/CORE,-L$(TARGET_DEST_DIR)$(PERL_TARGET_CORE),g" config.mk ; \
	   sed -i "s,rpath\,/usr/lib[a-z/0-9]*/CORE,rpath\,$(PERL_TARGET_CORE),g" config.mk ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VIM_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
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
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VIM_PKG))
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
	@$(PSEUDO) sh -c "cd $(VIM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
