
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/boost

REQUIRES           = libs/boost/1.57.0
REQUIRES          += libs/icu4c/55.1-x86_32
REQUIRES          += app/bzip2/1.0.6-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += libs/openmpi/1.8.8-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.57.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/boost/boost-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/boost-$(version)
src_dir_name       = boost-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BOOST_32_PKG_NAME                = boost-x32
BOOST_32_PKG_VERSION             = 1.57.0
BOOST_32_PKG_ARCH                = $(TOOLCHAIN)
BOOST_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BOOST_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BOOST_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BOOST_32_PKG_SHORT_DESCRIPTION   = Boost C++ Libraries
BOOST_32_PKG_URL                 = $(BUG_URL)
BOOST_32_PKG_LICENSE             = custom
BOOST_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BOOST_32_PKG_NAME)-pkg-description
BOOST_32_PKG_DESCRIPTION_FILE_IN = $(BOOST_32_PKG_NAME)-pkg-description.in
BOOST_32_PKG_INSTALL_SCRIPT      = $(BOOST_32_PKG_NAME)-pkg-install.sh

BOOST_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BOOST_32_PKG_NAME)-package

pkg_basename     = $(BOOST_32_PKG_NAME)-$(BOOST_32_PKG_VERSION)-$(BOOST_32_PKG_ARCH)-$(BOOST_32_PKG_DISTRO_NAME)-$(BOOST_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


ARCH          = x86
ABI           = sysv
BINARY_FORMAT = elf
ADDRESS_MODEL = 32


PYTHON_VERSION = 2.7

build_libs = atomic chrono container context coroutine \
             date_time exception filesystem graph      \
             graph_parallel iostreams locale log math  \
             mpi                                       \
             program_options python random regex       \
             serialization signals system test thread  \
             timer wave

BJAM = $(CURDIR)/$(SRC_DIR)/tools/build/src/engine/bin.linuxx86_64/bjam

build_home = $(CURDIR)/$(SRC_DIR)/build


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR)/tools/build/src/engine && ./build.sh gcc )
	@mkdir -p $(build_home)
	@echo "using gcc : : $(CXX)"                                        > $(build_home)/user-config.jam
	@echo "  : <cflags>\"--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)\""     >> $(build_home)/user-config.jam
	@echo "    <cxxflags>\"--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)\""   >> $(build_home)/user-config.jam
	@echo "    <linkflags>\"--sysroot=$(TARGET_DEST_DIR) $(LDFLAGS)\"" >> $(build_home)/user-config.jam
	@echo "    <root>\"$(TOOLCHAIN_PATH)/bin\""                        >> $(build_home)/user-config.jam
	@echo "  ;"                                                        >> $(build_home)/user-config.jam
	@echo ""                                                           >> $(build_home)/user-config.jam
	@echo "using python : 2.7 : : "                                                                >> $(build_home)/user-config.jam
	@echo "    $(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)"                             >> $(build_home)/user-config.jam
	@echo "  : $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/config" >> $(build_home)/user-config.jam
	@echo "  :"                                                                                    >> $(build_home)/user-config.jam
	@echo "  ;"                                                                                    >> $(build_home)/user-config.jam
	@echo ""                                                                                       >> $(build_home)/user-config.jam
	@echo "path-constant ICU_PATH "       >> $(build_home)/user-config.jam
	@echo "  : $(TARGET_DEST_DIR)/usr"    >> $(build_home)/user-config.jam
	@echo "  ;"                           >> $(build_home)/user-config.jam
	@echo ""                              >> $(build_home)/user-config.jam
	@echo "using mpi : : <find-shared-library>mpi"  >> $(build_home)/user-config.jam
	@echo "              <find-shared-library>dl ;" >> $(build_home)/user-config.jam
	@echo ""                                        >> $(build_home)/user-config.jam
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) BOOST_BUILD_PATH=$(build_home) \
	  $(BJAM)                                             \
	  release                                             \
	  --user-config=$(build_home)/user-config.jam         \
	  --layout-system     \
	  --prefix=/usr       \
	  --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX) \
	  $(foreach lib,$(build_libs),--with-$(lib)) \
	  toolset=gcc         \
	  variant=release     \
	  threading=multi     \
	  link=shared         \
	  runtime-link=shared \
	  target-os=linux     \
	  abi=$(ABI)                     \
	  architecture=$(ARCH)           \
	  binary-format=$(BINARY_FORMAT) \
	  address-model=$(ADDRESS_MODEL) \
	  stage
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BOOST_32_PKG)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) BOOST_BUILD_PATH=$(build_home) \
	  $(BJAM)                                             \
	  release                                             \
	  --user-config=$(build_home)/user-config.jam         \
	  --layout-system     \
	  --prefix=$(BOOST_32_PKG)/usr                              \
	  --libdir=$(BOOST_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) \
	  $(foreach lib,$(build_libs),--with-$(lib)) \
	  toolset=gcc         \
	  variant=release     \
	  threading=multi     \
	  link=shared         \
	  runtime-link=shared \
	  target-os=linux     \
	  abi=$(ABI)                     \
	  architecture=$(ARCH)           \
	  binary-format=$(BINARY_FORMAT) \
	  address-model=$(ADDRESS_MODEL) \
	  install
	@rm -rf $(BOOST_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BOOST_32_PKG))
	# ======= Strip binaries =======
	@( cd $(BOOST_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BOOST_32_PKG_DESCRIPTION_FILE): $(BOOST_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BOOST_32_PKG_DESCRIPTION_FILE) $(BOOST_32_PKG_INSTALL_SCRIPT)
	@cp $(BOOST_32_PKG_DESCRIPTION_FILE) $(BOOST_32_PKG)/.DESCRIPTION
	@cp $(BOOST_32_PKG_INSTALL_SCRIPT) $(BOOST_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BOOST_32_PKG)/.REQUIRES
	@echo "pkgname=$(BOOST_32_PKG_NAME)"                            >  $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BOOST_32_PKG_VERSION)"                          >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BOOST_32_PKG_ARCH)"                               >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BOOST_32_PKG_DISTRO_NAME)"                  >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BOOST_32_PKG_DISTRO_VERSION)"                >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "group=$(BOOST_32_PKG_GROUP)"                             >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BOOST_32_PKG_SHORT_DESCRIPTION)\"" >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "url=$(BOOST_32_PKG_URL)"                                 >> $(BOOST_32_PKG)/.PKGINFO ; \
	 echo "license=$(BOOST_32_PKG_LICENSE)"                         >> $(BOOST_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(BOOST_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
