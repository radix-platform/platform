
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/pcre

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += app/bzip2/1.0.6
REQUIRES          += libs/libtermcap/1.2.3


version            = 8.34
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/pcre/pcre-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pcre-$(version)
src_dir_name       = pcre-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_pcre32_pkg   = $(TARGET_BUILD_DIR)/.pcre32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PCRE32_PKG_NAME                = pcre32
PCRE32_PKG_VERSION             = 8.34
ifeq ($(HARDWARE),$(TARGET_HOST))
PCRE32_PKG_ARCH                = $(shell uname -m)
else
PCRE32_PKG_ARCH                = $(TOOLCHAIN)
endif
PCRE32_PKG_DISTRO_NAME         = kxLab
PCRE32_PKG_DISTRO_VERSION      = 1.0
PCRE32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PCRE32_PKG_SHORT_DESCRIPTION   = pcre32 $(version)
PCRE32_PKG_URL                 = http://www.kxLab.com
PCRE32_PKG_LICENSE             = GPLv2
PCRE32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCRE32_PKG_NAME)-pkg-description
PCRE32_PKG_DESCRIPTION_FILE_IN = $(PCRE32_PKG_NAME)-pkg-description.in
PCRE32_PKG_INSTALL_SCRIPT      = $(PCRE32_PKG_NAME)-pkg-install.sh

PCRE32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCRE32_PKG_NAME)-package

pkg_basename     = $(PCRE32_PKG_NAME)-$(PCRE32_PKG_VERSION)-$(PCRE32_PKG_ARCH)-$(PCRE32_PKG_DISTRO_NAME)-$(PCRE32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(PCRE32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_pcre32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(PCRE32_PKG)


OPTIMIZATION_FLAGS = -O3

CC                += -m32
CXX               += -m32

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
else
LIBSUFFIX          =
endif

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-utf8
extra_configure_switches += --enable-pcre16
extra_configure_switches += --enable-pcre32
extra_configure_switches += --enable-unicode-properties

extra_configure_switches += --enable-pcregrep-libz
extra_configure_switches += --enable-pcregrep-libbz2

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	@mkdir -p $(PCRE32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(PCRE32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv pcre* 32 \
	 )
	@rm -rf $(PCRE32_PKG)/usr/include
	@rm -rf $(PCRE32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(PCRE32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PCRE32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpcre.la libpcre16.la libpcre32.la libpcrecpp.la libpcreposix.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpcre.pc libpcre16.pc libpcre32.pc libpcrecpp.pc libpcreposix.pc \
	 )
	@(cd $(PCRE32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PCRE32_PKG_DESCRIPTION_FILE): $(PCRE32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_pcre32_pkg): $(install_target) $(PCRE32_PKG_DESCRIPTION_FILE)
	@cp $(PCRE32_PKG_DESCRIPTION_FILE) $(PCRE32_PKG)/.DESCRIPTION
	@cp $(PCRE32_PKG_INSTALL_SCRIPT) $(PCRE32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCRE32_PKG)/.REQUIRES
	@echo "pkgname=$(PCRE32_PKG_NAME)"                            >  $(PCRE32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCRE32_PKG_VERSION)"                          >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "arch=$(PCRE32_PKG_ARCH)"                               >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCRE32_PKG_DISTRO_NAME)"                  >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCRE32_PKG_DISTRO_VERSION)"                >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "group=$(PCRE32_PKG_GROUP)"                             >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCRE32_PKG_SHORT_DESCRIPTION)\"" >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "url=$(PCRE32_PKG_URL)"                                 >> $(PCRE32_PKG)/.PKGINFO ; \
	 echo "license=$(PCRE32_PKG_LICENSE)"                         >> $(PCRE32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PCRE32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
