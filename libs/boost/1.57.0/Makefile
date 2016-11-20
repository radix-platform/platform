
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/boost

REQUIRES           = libs/icu4c/55.1
REQUIRES          += app/bzip2/1.0.6
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += libs/openmpi/1.8.8

# ======= __END_OF_REQUIRES__ =======


version            = 1.57.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/boost/boost-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/boost-$(version)
src_dir_name       = boost-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
PATCHES = PATCHES.mips
else
PATCHES = PATCHES
endif

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BOOST_PKG_NAME                = boost
BOOST_PKG_VERSION             = 1.57.0
BOOST_PKG_ARCH                = $(TOOLCHAIN)
BOOST_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BOOST_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BOOST_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BOOST_PKG_SHORT_DESCRIPTION   = Boost C++ Libraries
BOOST_PKG_URL                 = $(BUG_URL)
BOOST_PKG_LICENSE             = custom
BOOST_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BOOST_PKG_NAME)-pkg-description
BOOST_PKG_DESCRIPTION_FILE_IN = $(BOOST_PKG_NAME)-pkg-description.in
BOOST_PKG_INSTALL_SCRIPT      = $(BOOST_PKG_NAME)-pkg-install.sh

BOOST_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BOOST_PKG_NAME)-package

pkg_basename     = $(BOOST_PKG_NAME)-$(BOOST_PKG_VERSION)-$(BOOST_PKG_ARCH)-$(BOOST_PKG_DISTRO_NAME)-$(BOOST_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


#
# See: $(SRC_DIR)/libs/context/build/Jamfile.v2
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201)      \
                            $(HARDWARE_MXV)       \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
ARCH          = arm
ABI           = aapcs
BINARY_FORMAT = elf
ADDRESS_MODEL = 32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH          = x86
ABI           = sysv
BINARY_FORMAT = elf
ADDRESS_MODEL = 32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH          = x86
ABI           = sysv
BINARY_FORMAT = elf
ADDRESS_MODEL = 64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
ARCH          = mips1
ABI           = o32
BINARY_FORMAT = elf
ADDRESS_MODEL = 32
endif


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
	@echo "using python : 2.7 : : "                                                   >> $(build_home)/user-config.jam
	@echo "    $(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)"                >> $(build_home)/user-config.jam
	@echo "  : $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config" >> $(build_home)/user-config.jam
	@echo "  :"                                                                       >> $(build_home)/user-config.jam
	@echo "  ;"                                                                       >> $(build_home)/user-config.jam
	@echo ""                                                                          >> $(build_home)/user-config.jam
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
	  --libdir=/usr/lib$(LIBSUFFIX)              \
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
	@mkdir -p $(BOOST_PKG)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) BOOST_BUILD_PATH=$(build_home) \
	  $(BJAM)                                             \
	  release                                             \
	  --user-config=$(build_home)/user-config.jam         \
	  --layout-system     \
	  --prefix=$(BOOST_PKG)/usr                  \
	  --libdir=$(BOOST_PKG)/usr/lib$(LIBSUFFIX)  \
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
	# ======= Install License =======
	@mkdir -p $(BOOST_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE_1_0.txt \
	       $(BOOST_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BOOST_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE_1_0.txt index.html *.css *.png \
	         $(BOOST_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BOOST_PKG))
	# ======= Strip binaries =======
	@( cd $(BOOST_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BOOST_PKG_DESCRIPTION_FILE): $(BOOST_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BOOST_PKG_DESCRIPTION_FILE) $(BOOST_PKG_INSTALL_SCRIPT)
	@cp $(BOOST_PKG_DESCRIPTION_FILE) $(BOOST_PKG)/.DESCRIPTION
	@cp $(BOOST_PKG_INSTALL_SCRIPT) $(BOOST_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BOOST_PKG)/.REQUIRES
	@echo "pkgname=$(BOOST_PKG_NAME)"                            >  $(BOOST_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BOOST_PKG_VERSION)"                          >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "arch=$(BOOST_PKG_ARCH)"                               >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "distroname=$(BOOST_PKG_DISTRO_NAME)"                  >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "distrover=$(BOOST_PKG_DISTRO_VERSION)"                >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "group=$(BOOST_PKG_GROUP)"                             >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BOOST_PKG_SHORT_DESCRIPTION)\"" >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "url=$(BOOST_PKG_URL)"                                 >> $(BOOST_PKG)/.PKGINFO ; \
	 echo "license=$(BOOST_PKG_LICENSE)"                         >> $(BOOST_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BOOST_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
