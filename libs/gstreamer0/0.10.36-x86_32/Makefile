
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/gstreamer

REQUIRES           = libs/gstreamer0/0.10.36
REQUIRES          += libs/glib2/2.63.0-x86_32
REQUIRES          += libs/libxml2/2.9.9-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.10.36
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/gstreamer/gstreamer-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gstreamer-$(version)
src_dir_name       = gstreamer-$(version)
doc_dir_name       = gstreamer0-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

BISON_MAJOR_VERSION = $(shell bison --version | grep ^bison | sed 's/^.* //g' | cut -f 1 -d'.' )

ifeq ($(BISON_MAJOR_VERSION),3)
OPT_PATCHES = PATCHES.bison3
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GSTREAMER_32_PKG_NAME                = gstreamer0-x32
GSTREAMER_32_PKG_VERSION             = 0.10.36
GSTREAMER_32_PKG_ARCH                = $(TOOLCHAIN)
GSTREAMER_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GSTREAMER_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GSTREAMER_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
GSTREAMER_32_PKG_SHORT_DESCRIPTION   = streaming multimedia framework
GSTREAMER_32_PKG_URL                 = $(BUG_URL)
GSTREAMER_32_PKG_LICENSE             = LGPLv2
GSTREAMER_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GSTREAMER_32_PKG_NAME)-pkg-description
GSTREAMER_32_PKG_DESCRIPTION_FILE_IN = $(GSTREAMER_32_PKG_NAME)-pkg-description.in
GSTREAMER_32_PKG_INSTALL_SCRIPT      = $(GSTREAMER_32_PKG_NAME)-pkg-install.sh

GSTREAMER_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GSTREAMER_32_PKG_NAME)-package

pkg_basename     = $(GSTREAMER_32_PKG_NAME)-$(GSTREAMER_32_PKG_VERSION)-$(GSTREAMER_32_PKG_ARCH)-$(GSTREAMER_32_PKG_DISTRO_NAME)-$(GSTREAMER_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GSTREAMER_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32
extra_configure_switches += --libexecdir=/usr/libexec/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-debug
extra_configure_switches += --disable-gst-debug
extra_configure_switches += --enable-glib-asserts=no
extra_configure_switches += --with-package-name='gstreamer'
extra_configure_switches += --with-package-origin='http://gstreamer.freedesktop.org'

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifeq ($(BISON_MAJOR_VERSION),3)
	$(call apply-opt-patches, $(SRC_DIR))
endif
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GSTREAMER_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GSTREAMER_32_PKG)/usr/include
	@rm -rf $(GSTREAMER_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GSTREAMER_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                    libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                    libgstnet-?.??.la libgstreamer-?.??.la             ; \
	 )
	@( cd $(GSTREAMER_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstcoreelements.la libgstcoreindexers.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GSTREAMER_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                            libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                            libgstnet-?.??.la libgstreamer-?.??.la             ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                              libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                              libgstnet-?.??.la libgstreamer-?.??.la             ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstcoreelements.la libgstcoreindexers.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstcoreelements.la libgstcoreindexers.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gstreamer-?.??.pc gstreamer-base-?.??.pc               \
	                                            gstreamer-check-?.??.pc gstreamer-controller-?.??.pc   \
	                                            gstreamer-dataprotocol-?.??.pc gstreamer-net-?.??.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GSTREAMER_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GSTREAMER_32_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GSTREAMER_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GSTREAMER_32_PKG_DESCRIPTION_FILE): $(GSTREAMER_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GSTREAMER_32_PKG_DESCRIPTION_FILE) $(GSTREAMER_32_PKG_INSTALL_SCRIPT)
	@cp $(GSTREAMER_32_PKG_DESCRIPTION_FILE) $(GSTREAMER_32_PKG)/.DESCRIPTION
	@cp $(GSTREAMER_32_PKG_INSTALL_SCRIPT) $(GSTREAMER_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GSTREAMER_32_PKG)/.REQUIRES
	@echo "pkgname=$(GSTREAMER_32_PKG_NAME)"                            >  $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GSTREAMER_32_PKG_VERSION)"                          >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GSTREAMER_32_PKG_ARCH)"                               >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GSTREAMER_32_PKG_DISTRO_NAME)"                  >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GSTREAMER_32_PKG_DISTRO_VERSION)"                >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "group=$(GSTREAMER_32_PKG_GROUP)"                             >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GSTREAMER_32_PKG_SHORT_DESCRIPTION)\"" >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "url=$(GSTREAMER_32_PKG_URL)"                                 >> $(GSTREAMER_32_PKG)/.PKGINFO ; \
	 echo "license=$(GSTREAMER_32_PKG_LICENSE)"                         >> $(GSTREAMER_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GSTREAMER_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
