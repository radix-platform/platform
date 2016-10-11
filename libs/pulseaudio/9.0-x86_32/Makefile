
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/pulseaudio

ENABLE_X11_SUPPORT = yes

REQUIRES           = libs/pulseaudio/9.0
REQUIRES          += net/bluez/5.42-x86_32
REQUIRES          += net/avahi-daemon/0.6.31-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32
REQUIRES          += libs/pcre/8.38-x86_32
REQUIRES          += libs/libasyncns/0.8-x86_32
REQUIRES          += libs/json-c/0.12-x86_32
REQUIRES          += libs/sbc/1.3-x86_32
REQUIRES          += libs/libsndfile/1.0.26-x86_32
REQUIRES          += libs/libsoxr/0.1.2-x86_32
REQUIRES          += libs/speex/1.2rc2-x86_32
REQUIRES          += libs/fftw/3.3.5-x86_32
REQUIRES          += app/jack/0.125.0-x86_32

ifeq ($(ENABLE_X11_SUPPORT),yes)
REQUIRES          += X11/X.org/lib/libSM/1.2.2-x86_32
REQUIRES          += X11/X.org/lib/libXtst/1.2.2-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 9.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/pulseaudio/pulseaudio-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pulseaudio-$(version)
src_dir_name       = pulseaudio-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PAUDIO_32_PKG_NAME                = pulseaudio-x32
PAUDIO_32_PKG_VERSION             = 9.0
PAUDIO_32_PKG_ARCH                = $(TOOLCHAIN)
PAUDIO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PAUDIO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PAUDIO_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
PAUDIO_32_PKG_SHORT_DESCRIPTION   = PulseAudio sound server
PAUDIO_32_PKG_URL                 = $(BUG_URL)
PAUDIO_32_PKG_LICENSE             = GPLv2
PAUDIO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PAUDIO_32_PKG_NAME)-pkg-description
PAUDIO_32_PKG_DESCRIPTION_FILE_IN = $(PAUDIO_32_PKG_NAME)-pkg-description.in
PAUDIO_32_PKG_INSTALL_SCRIPT      = $(PAUDIO_32_PKG_NAME)-pkg-install.sh

PAUDIO_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PAUDIO_32_PKG_NAME)-package

pkg_basename     = $(PAUDIO_32_PKG_NAME)-$(PAUDIO_32_PKG_VERSION)-$(PAUDIO_32_PKG_ARCH)-$(PAUDIO_32_PKG_DISTRO_NAME)-$(PAUDIO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PAUDIO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32


extra_configure_switches += --with-system-user=pulse
extra_configure_switches += --with-system-group=pulse
extra_configure_switches += --with-access-group=audio
extra_configure_switches += --with-bash-completion-dir=/usr/share/bash-completion/completions

extra_configure_switches += --with-fftw

extra_configure_switches += --disable-orc
extra_configure_switches += --disable-tcpwrap
extra_configure_switches += --disable-hal-compat
extra_configure_switches += --disable-bluez4

ifneq ($(ENABLE_X11_SUPPORT),yes)
extra_configure_switches += --disable-x11
endif
extra_configure_switches += --disable-gtk3
extra_configure_switches += --disable-gconf
extra_configure_switches += --disable-lirc
extra_configure_switches += --disable-tests
extra_configure_switches += --disable-systemd-daemon


extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)/pulseaudio
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)/pulseaudio

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i -e '/@PA_BINARY@/ imkdir -p $$HOME/.config/pulse' src/daemon/start-pulseaudio-x11.in ; \
	   sed -i    's/; flat-volumes = yes/flat-volumes = no/g'   src/daemon/daemon.conf.in          ; \
	   echo "X-MATE-Autostart-Phase=Initialization"          >> src/daemon/pulseaudio.desktop.in   ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PAUDIO_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PAUDIO_32_PKG)/etc
	@rm -rf $(PAUDIO_32_PKG)/lib
	@rm -rf $(PAUDIO_32_PKG)/usr/include
	@rm -rf $(PAUDIO_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PAUDIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpulse-mainloop-glib.la        \
	                                    libpulse-simple.la libpulse.la ; \
	   sed -i "s,lib3232,lib32,g" libpulse-mainloop-glib.la        \
	                              libpulse-simple.la libpulse.la ; \
	 )
	@( cd $(PAUDIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pulseaudio ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpulsecommon-9.0.la  \
	                                    libpulsecore-9.0.la    \
	                                    libpulsedsp.la       ; \
	   sed -i "s,lib3232,lib32,g" libpulsecommon-9.0.la  \
	                              libpulsecore-9.0.la    \
	                              libpulsedsp.la       ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PAUDIO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulse-mainloop-glib.la        \
	                                            libpulse-simple.la libpulse.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpulse-mainloop-glib.la        \
	                                              libpulse-simple.la libpulse.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pulseaudio ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulsecommon-9.0.la  \
	                                            libpulsecore-9.0.la    \
	                                            libpulsedsp.la       ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpulsecommon-9.0.la  \
	                                              libpulsecore-9.0.la    \
	                                              libpulsedsp.la       ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulse-mainloop-glib.pc        \
	                                            libpulse-simple.pc libpulse.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PAUDIO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(PAUDIO_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PAUDIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PAUDIO_32_PKG_DESCRIPTION_FILE): $(PAUDIO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PAUDIO_32_PKG_DESCRIPTION_FILE) $(PAUDIO_32_PKG_INSTALL_SCRIPT)
	@cp $(PAUDIO_32_PKG_DESCRIPTION_FILE) $(PAUDIO_32_PKG)/.DESCRIPTION
	@cp $(PAUDIO_32_PKG_INSTALL_SCRIPT) $(PAUDIO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PAUDIO_32_PKG)/.REQUIRES
	@echo "pkgname=$(PAUDIO_32_PKG_NAME)"                            >  $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PAUDIO_32_PKG_VERSION)"                          >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PAUDIO_32_PKG_ARCH)"                               >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PAUDIO_32_PKG_DISTRO_NAME)"                  >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PAUDIO_32_PKG_DISTRO_VERSION)"                >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "group=$(PAUDIO_32_PKG_GROUP)"                             >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PAUDIO_32_PKG_SHORT_DESCRIPTION)\"" >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "url=$(PAUDIO_32_PKG_URL)"                                 >> $(PAUDIO_32_PKG)/.PKGINFO ; \
	 echo "license=$(PAUDIO_32_PKG_LICENSE)"                         >> $(PAUDIO_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PAUDIO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
