
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/jackaudio/jack

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += app/db/6.1.26
REQUIRES          += libs/libsamplerate/0.1.8
REQUIRES          += libs/zita-alsa-pcmi/0.2.0
REQUIRES          += libs/zita-resampler/1.3.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.125.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/jackaudio/jack/jack-audio-connection-kit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/jack-audio-connection-kit-$(version)
src_dir_name       = jack-audio-connection-kit-$(version)
doc_dir_name       = jack-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

udev_rules         = $(CURDIR)/udev/rules.d
security_limits    = $(CURDIR)/security/limits.d


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JACK_PKG_NAME                = jack
JACK_PKG_VERSION             = 0.125.0
JACK_PKG_ARCH                = $(TOOLCHAIN)
JACK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JACK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JACK_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
JACK_PKG_SHORT_DESCRIPTION   = Low-latency audio server
JACK_PKG_URL                 = $(BUG_URL)
JACK_PKG_LICENSE             = GPLv2
JACK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JACK_PKG_NAME)-pkg-description
JACK_PKG_DESCRIPTION_FILE_IN = $(JACK_PKG_NAME)-pkg-description.in
JACK_PKG_INSTALL_SCRIPT      = $(JACK_PKG_NAME)-pkg-install.sh

JACK_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JACK_PKG_NAME)-package

pkg_basename     = $(JACK_PKG_NAME)-$(JACK_PKG_VERSION)-$(JACK_PKG_ARCH)-$(JACK_PKG_DISTRO_NAME)-$(JACK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(JACK_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-alsa
extra_configure_switches += --enable-cell
extra_configure_switches += --enable-zalsa
extra_configure_switches += --disable-portaudio
extra_configure_switches += --disable-coreaudio
extra_configure_switches += --disable-sun
extra_configure_switches += --disable-sndio
extra_configure_switches += --disable-freebob
extra_configure_switches += --disable-firewire

extra_configure_switches += --enable-stripped-jackd=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CFLAGS += -Wno-maybe-uninitialized -Wno-deprecated-declarations
CFLAGS += -Wno-discarded-qualifiers -Wno-int-conversion
CFLAGS += -Wno-unused-but-set-variable -Wno-unused-function
CFLAGS += -Wno-incompatible-pointer-types

TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JACK_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(JACK_PKG)/lib/udev/rules.d
	@cp -a $(udev_rules)/40-hpet-permissions.rules $(JACK_PKG)/lib/udev/rules.d/40-hpet-permissions.rules.new
	@mkdir -p $(JACK_PKG)/etc/security/limits.d
	@cp -a $(security_limits)/99-audio.conf $(JACK_PKG)/etc/security/limits.d/99-audio.conf.new
	# ======= Install Documentation =======
	@if [ -d $(JACK_PKG)/usr/share/man ]; then \
	  ( cd $(JACK_PKG)/usr/share/man ; \
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
	@mkdir -p $(JACK_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(JACK_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(JACK_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* README TODO \
	         $(JACK_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@cp -ar $(JACK_PKG)/usr/share/jack-audio-connection-kit/reference/html \
	        $(JACK_PKG)/usr/share/doc/$(doc_dir_name)
	@rm -rf $(JACK_PKG)/usr/share/jack-audio-connection-kit
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(JACK_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(JACK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libjack.la libjackserver.la ; \
	 )
	@( cd $(JACK_PKG)/usr/lib$(LIBSUFFIX)/jack ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" inprocess.la intime.la                 \
	                                    jack_alsa.la jack_alsa_midi.la         \
	                                    jack_dummy.la jack_net.la              \
	                                    jack_oss.la zalsa_in.la zalsa_out.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JACK_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libjack.la libjackserver.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libjack.la libjackserver.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/jack ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" inprocess.la intime.la                 \
	                                            jack_alsa.la jack_alsa_midi.la         \
	                                            jack_dummy.la jack_net.la              \
	                                            jack_oss.la zalsa_in.la zalsa_out.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" inprocess.la intime.la                 \
	                                              jack_alsa.la jack_alsa_midi.la         \
	                                              jack_dummy.la jack_net.la              \
	                                              jack_oss.la zalsa_in.la zalsa_out.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" jack.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(JACK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(JACK_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(JACK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(JACK_PKG_DESCRIPTION_FILE): $(JACK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JACK_PKG_DESCRIPTION_FILE) $(JACK_PKG_INSTALL_SCRIPT)
	@cp $(JACK_PKG_DESCRIPTION_FILE) $(JACK_PKG)/.DESCRIPTION
	@cp $(JACK_PKG_INSTALL_SCRIPT) $(JACK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JACK_PKG)/.REQUIRES
	@echo "pkgname=$(JACK_PKG_NAME)"                            >  $(JACK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JACK_PKG_VERSION)"                          >> $(JACK_PKG)/.PKGINFO ; \
	 echo "arch=$(JACK_PKG_ARCH)"                               >> $(JACK_PKG)/.PKGINFO ; \
	 echo "distroname=$(JACK_PKG_DISTRO_NAME)"                  >> $(JACK_PKG)/.PKGINFO ; \
	 echo "distrover=$(JACK_PKG_DISTRO_VERSION)"                >> $(JACK_PKG)/.PKGINFO ; \
	 echo "group=$(JACK_PKG_GROUP)"                             >> $(JACK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JACK_PKG_SHORT_DESCRIPTION)\"" >> $(JACK_PKG)/.PKGINFO ; \
	 echo "url=$(JACK_PKG_URL)"                                 >> $(JACK_PKG)/.PKGINFO ; \
	 echo "license=$(JACK_PKG_LICENSE)"                         >> $(JACK_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(JACK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
