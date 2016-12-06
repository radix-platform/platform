
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


SOURCE_REQUIRES    = sources/packages/m/xiph/cdparanoia

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


version            = 10.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/cdparanoia/cdparanoia-III-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cdparanoia-III-$(version)
src_dir_name       = cdparanoia-III-$(version)
doc_dir_name       = cdparanoia-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PARANOIA_PKG_NAME                = cdparanoia
PARANOIA_PKG_VERSION             = 10.2
PARANOIA_PKG_ARCH                = $(TOOLCHAIN)
PARANOIA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PARANOIA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PARANOIA_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PARANOIA_PKG_SHORT_DESCRIPTION   = digital audio extraction tool
PARANOIA_PKG_URL                 = $(BUG_URL)
PARANOIA_PKG_LICENSE             = GPLv2
PARANOIA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PARANOIA_PKG_NAME)-pkg-description
PARANOIA_PKG_DESCRIPTION_FILE_IN = $(PARANOIA_PKG_NAME)-pkg-description.in
PARANOIA_PKG_INSTALL_SCRIPT      = $(PARANOIA_PKG_NAME)-pkg-install.sh

PARANOIA_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PARANOIA_PKG_NAME)-package

pkg_basename     = $(PARANOIA_PKG_NAME)-$(PARANOIA_PKG_VERSION)-$(PARANOIA_PKG_ARCH)-$(PARANOIA_PKG_DISTRO_NAME)-$(PARANOIA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --includedir=/usr/include/cdda

environment  = FLAGS="-g -O2"
environment += OPT="-O2 -fsigned-char $(FLAGS) -I$(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)"
environment += DEBUG="-g -Wall -fsigned-char $(FLAGS)"
environment += CC="$(CC)"
environment += LD="$(CC)"
environment += LDFLAGS="$(FLAGS)"
environment += AR="$(AR)"
environment += RANLIB="$(RANLIB)"
environment += INSTALL=install
environment += prefix=/usr
environment += exec_prefix=${prefix}
environment += BINDIR=${exec_prefix}/bin
environment += MANDIR=${prefix}/share/man
environment += INCLUDEDIR=${prefix}/include/cdda
environment += LIBDIR=${exec_prefix}/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(environment)
	@touch $@

$(install_target): $(build_target)
	@install -d $(PARANOIA_PKG)/usr/bin
	@install -d $(PARANOIA_PKG)/usr/include/cdda
	@install -d $(PARANOIA_PKG)/usr/lib$(LIBSUFFIX)
	@install -d $(PARANOIA_PKG)/usr/share/man/man1
	@( cd $(SRC_DIR) ; \
	   install -m 0755 cdparanoia $(PARANOIA_PKG)/usr/bin ; \
	   install -m 0644 cdparanoia.1 $(PARANOIA_PKG)/usr/share/man/man1 ; \
	   install -m 0644 utils.h paranoia/cdda_paranoia.h interface/cdda_interface.h \
	                   $(PARANOIA_PKG)/usr/include/cdda ; \
	   install -m 0755 paranoia/libcdda_paranoia.so.0.10.? \
	                   interface/libcdda_interface.so.0.10.? \
	                   $(PARANOIA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   install -m 0644 paranoia/libcdda_paranoia.a interface/libcdda_interface.a \
	                   $(PARANOIA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   cp -a paranoia/libcdda_paranoia.so paranoia/libcdda_paranoia.so.0 \
	         interface/libcdda_interface.so interface/libcdda_interface.so.0 \
	         $(PARANOIA_PKG)/usr/lib$(LIBSUFFIX) ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(PARANOIA_PKG)/usr/share/man ]; then \
	  ( cd $(PARANOIA_PKG)/usr/share/man ; \
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
	@mkdir -p $(PARANOIA_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(PARANOIA_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PARANOIA_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* README \
	         $(PARANOIA_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@rm -f $(PARANOIA_PKG)/usr/share/doc/$(doc_dir_name)/FLAC.tag
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PARANOIA_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PARANOIA_PKG))
	# ======= Strip binaries =======
	@( cd $(PARANOIA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PARANOIA_PKG_DESCRIPTION_FILE): $(PARANOIA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PARANOIA_PKG_DESCRIPTION_FILE) $(PARANOIA_PKG_INSTALL_SCRIPT)
	@cp $(PARANOIA_PKG_DESCRIPTION_FILE) $(PARANOIA_PKG)/.DESCRIPTION
	@cp $(PARANOIA_PKG_INSTALL_SCRIPT) $(PARANOIA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PARANOIA_PKG)/.REQUIRES
	@echo "pkgname=$(PARANOIA_PKG_NAME)"                            >  $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PARANOIA_PKG_VERSION)"                          >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "arch=$(PARANOIA_PKG_ARCH)"                               >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "distroname=$(PARANOIA_PKG_DISTRO_NAME)"                  >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "distrover=$(PARANOIA_PKG_DISTRO_VERSION)"                >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "group=$(PARANOIA_PKG_GROUP)"                             >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PARANOIA_PKG_SHORT_DESCRIPTION)\"" >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "url=$(PARANOIA_PKG_URL)"                                 >> $(PARANOIA_PKG)/.PKGINFO ; \
	 echo "license=$(PARANOIA_PKG_LICENSE)"                         >> $(PARANOIA_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PARANOIA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
