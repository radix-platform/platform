
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)

NEED_ABS_PATH      = true

FLAVOURS = de fr

include ../../../build-system/constants.mk


REQUIRES = libs/glibc/2.24


# ======= __END_OF_REQUIRES__ =======


version        = 1.0.0

bin_srcs       = hello.c

SRCS           = $(bin_srcs)

bin_objs       = $(addprefix $(TARGET_BUILD_DIR)/,$(bin_srcs:.c=.o))
bin_target     = $(TARGET_BUILD_DIR)/libhello.so.$(version)

install_target = $(TARGET_BUILD_DIR)/.install_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
HELLO_PKG_NAME                = hello-dll
HELLO_PKG_VERSION             = 1.0.0
HELLO_PKG_ARCH                = $(TOOLCHAIN)
HELLO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HELLO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HELLO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
HELLO_PKG_SHORT_DESCRIPTION   = Example Shared Library
HELLO_PKG_URL                 = $(BUG_URL)
HELLO_PKG_LICENSE             = BSD
HELLO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HELLO_PKG_NAME)-pkg-description
HELLO_PKG_DESCRIPTION_FILE_IN = $(HELLO_PKG_NAME)-pkg-description.in
HELLO_PKG_INSTALL_SCRIPT      = $(HELLO_PKG_NAME)-pkg-install.sh

HELLO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HELLO_PKG_NAME)-package

pkg_basename     = $(HELLO_PKG_NAME)-$(HELLO_PKG_VERSION)-$(HELLO_PKG_ARCH)-$(HELLO_PKG_DISTRO_NAME)-$(HELLO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)$(if $(FLAVOUR),/$(FLAVOUR))/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(bin_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

#
# NOTE: especially for ROOTFS TARGETS !!!
#
# FLAVOUR ia a HARDWARE variant only. I think you do not want to have
# to install one variant of HARDWARE target over other variant already
# installed into same ROOT file system. I can suggest two solution for
# you:
#  - first one:
#                Do not build such sources without fixed FLAVOUR by
#                command line arguments. For example, to build this
#                program you can make use only one of following
#                command lines:
#                       $ make FLAVOUR=
#                       $ make FLAVOUR=de
#                       $ make FLAVOUR=fr
#
#  - second one:
#                You can forbid to install all FLAVOURS into ROOTFS and
#                allow only one using conditianal directives like following.
#
ifeq ($(FLAVOUR),fr)
ROOTFS_TARGETS   = $(pkg_archive)
endif



include ../../../build-system/core.mk

ifneq ($(FLAVOUR),)
CFLAGS += -fPIC -I$(CURDIR) -D__FLAVOUR__=\"$(FLAVOUR)\"
else
CFLAGS += -fPIC -I$(CURDIR)
endif

BASIC_LDOPTS += -ldl


$(bin_target): $(bin_objs)
	$(LINK_SO)
#
# Directly use $(CC) and $(LINKER):
# ==================================
#
#	$(CC) $(CFLAGS) -c -o $(TARGET_BUILD_DIR)/hello.o hello.c
#	$(LINKER) $(LDFLAGS) -o $(TARGET_BUILD_DIR)/libhello.so.$(version) $(TARGET_BUILD_DIR)/hello.o -ldl

$(install_target): $(bin_target)
	@mkdir -p $(HELLO_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(HELLO_PKG)/usr/include/hello-dll
	@cp -a $(bin_target) $(HELLO_PKG)/usr/lib$(LIBSUFFIX)
	# ======= made symbolic links =======
	@( cd $(HELLO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf libhello.so.$(version) libhello.so.1 ; \
	   ln -sf libhello.so.1 libhello.so            ; \
	 )
	# ======= Install Documentation =======
	@cp -a $(CURDIR)/hello.h $(HELLO_PKG)/usr/include/hello-dll
	@mkdir -p $(HELLO_PKG)/usr/share/doc/hello-dll-$(version)
	@cp -a $(CURDIR)/README $(HELLO_PKG)/usr/share/doc/hello-dll-$(version)
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HELLO_PKG))
	# ======= Strip binaries =======
	@( cd $(HELLO_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(HELLO_PKG_DESCRIPTION_FILE): $(HELLO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HELLO_PKG_DESCRIPTION_FILE) $(HELLO_PKG_INSTALL_SCRIPT)
	@cp $(HELLO_PKG_DESCRIPTION_FILE) $(HELLO_PKG)/.DESCRIPTION
	@cp $(HELLO_PKG_INSTALL_SCRIPT) $(HELLO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HELLO_PKG)/.REQUIRES
	@echo "pkgname=$(HELLO_PKG_NAME)"                            >  $(HELLO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HELLO_PKG_VERSION)"                          >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "arch=$(HELLO_PKG_ARCH)"                               >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "distroname=$(HELLO_PKG_DISTRO_NAME)"                  >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "distrover=$(HELLO_PKG_DISTRO_VERSION)"                >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "group=$(HELLO_PKG_GROUP)"                             >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HELLO_PKG_SHORT_DESCRIPTION)\"" >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "url=$(HELLO_PKG_URL)"                                 >> $(HELLO_PKG)/.PKGINFO ; \
	 echo "license=$(HELLO_PKG_LICENSE)"                         >> $(HELLO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(HELLO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --flavour=$(FLAVOUR) --linkadd yes .."
