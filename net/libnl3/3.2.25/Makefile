
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


SOURCE_REQUIRES    = sources/packages/n/libnl3

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


version            = 3.2.25
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/libnl3/libnl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnl-$(version)
src_dir_name       = libnl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNL3_PKG_NAME                = libnl3
LIBNL3_PKG_VERSION             = 3.2.25
LIBNL3_PKG_ARCH                = $(TOOLCHAIN)
LIBNL3_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNL3_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNL3_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBNL3_PKG_SHORT_DESCRIPTION   = Netlink Protocol Library Suite version 3
LIBNL3_PKG_URL                 = $(BUG_URL)
LIBNL3_PKG_LICENSE             = LGPLv2.1
LIBNL3_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNL3_PKG_NAME)-pkg-description
LIBNL3_PKG_DESCRIPTION_FILE_IN = $(LIBNL3_PKG_NAME)-pkg-description.in
LIBNL3_PKG_INSTALL_SCRIPT      = $(LIBNL3_PKG_NAME)-pkg-install.sh

LIBNL3_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNL3_PKG_NAME)-package

pkg_basename     = $(LIBNL3_PKG_NAME)-$(LIBNL3_PKG_VERSION)-$(LIBNL3_PKG_ARCH)-$(LIBNL3_PKG_DISTRO_NAME)-$(LIBNL3_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNL3_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBNL3_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mv $(LIBNL3_PKG)/etc/libnl/classid{,.new}
	@mv $(LIBNL3_PKG)/etc/libnl/pktloc{,.new}
	@( cd $(LIBNL3_PKG)/usr/share/man/man8 ; \
	   rm -f nl-qdisc-delete.8 nl-qdisc-list.8 ; \
	   ln -sf nl-qdisc-add.8 nl-qdisc-delete.8 ; \
	   ln -sf nl-qdisc-add.8 nl-qdisc-list.8   ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(LIBNL3_PKG)/usr/share/man ]; then \
	  ( cd $(LIBNL3_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBNL3_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBNL3_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBNL3_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(LIBNL3_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBNL3_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNL3_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnl-3.la libnl-cli-3.la libnl-genl-3.la \
	                                    libnl-idiag-3.la libnl-nf-3.la libnl-route-3.la ; \
	 )
	@( cd $(LIBNL3_PKG)/usr/lib$(LIBSUFFIX)/libnl/cli/cls ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" basic.la cgroup.la ; \
	 )
	@( cd $(LIBNL3_PKG)/usr/lib$(LIBSUFFIX)/libnl/cli/qdisc ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" bfifo.la blackhole.la fq_codel.la \
	                                    htb.la ingress.la pfifo.la plug.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNL3_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnl-3.la libnl-cli-3.la libnl-genl-3.la \
	                                           libnl-idiag-3.la libnl-nf-3.la libnl-route-3.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnl-3.la libnl-cli-3.la libnl-genl-3.la \
	                                             libnl-idiag-3.la libnl-nf-3.la libnl-route-3.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libnl/cli/cls ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" basic.la cgroup.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" basic.la cgroup.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libnl/cli/qdisc ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" bfifo.la blackhole.la fq_codel.la \
	                                           htb.la ingress.la pfifo.la plug.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" bfifo.la blackhole.la fq_codel.la \
	                                             htb.la ingress.la pfifo.la plug.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnl-3.0.pc libnl-cli-3.0.pc     \
	                                            libnl-genl-3.0.pc libnl-nf-3.0.pc \
	                                            libnl-route-3.0.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNL3_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBNL3_PKG_DESCRIPTION_FILE): $(LIBNL3_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNL3_PKG_DESCRIPTION_FILE) $(LIBNL3_PKG_INSTALL_SCRIPT)
	@cp $(LIBNL3_PKG_DESCRIPTION_FILE) $(LIBNL3_PKG)/.DESCRIPTION
	@cp $(LIBNL3_PKG_INSTALL_SCRIPT) $(LIBNL3_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNL3_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNL3_PKG_NAME)"                            >  $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNL3_PKG_VERSION)"                          >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNL3_PKG_ARCH)"                               >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNL3_PKG_DISTRO_NAME)"                  >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNL3_PKG_DISTRO_VERSION)"                >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNL3_PKG_GROUP)"                             >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNL3_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNL3_PKG_URL)"                                 >> $(LIBNL3_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNL3_PKG_LICENSE)"                         >> $(LIBNL3_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBNL3_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
