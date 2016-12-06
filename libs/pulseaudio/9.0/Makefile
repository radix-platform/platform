
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


SOURCE_REQUIRES    = sources/packages/m/pulseaudio

ENABLE_X11_SUPPORT = yes

REQUIRES           = net/bluez/5.42
REQUIRES          += net/avahi-daemon/0.6.31
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += libs/pcre/8.38
REQUIRES          += libs/libasyncns/0.8
REQUIRES          += libs/json-c/0.12
REQUIRES          += libs/sbc/1.3
REQUIRES          += libs/libsndfile/1.0.26
REQUIRES          += libs/libsoxr/0.1.2
REQUIRES          += libs/speex/1.2rc2
REQUIRES          += libs/fftw/3.3.5
REQUIRES          += app/jack/0.125.0

ifeq ($(ENABLE_X11_SUPPORT),yes)
REQUIRES          += X11/X.org/lib/libSM/1.2.2
REQUIRES          += X11/X.org/lib/libXtst/1.2.2
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


rc_pulseaudio      = $(CURDIR)/etc/rc.d/rc.pulseaudio


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PAUDIO_PKG_NAME                = pulseaudio
PAUDIO_PKG_VERSION             = 9.0
PAUDIO_PKG_ARCH                = $(TOOLCHAIN)
PAUDIO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PAUDIO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PAUDIO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PAUDIO_PKG_SHORT_DESCRIPTION   = PulseAudio sound server
PAUDIO_PKG_URL                 = $(BUG_URL)
PAUDIO_PKG_LICENSE             = GPLv2
PAUDIO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PAUDIO_PKG_NAME)-pkg-description
PAUDIO_PKG_DESCRIPTION_FILE_IN = $(PAUDIO_PKG_NAME)-pkg-description.in
PAUDIO_PKG_INSTALL_SCRIPT      = $(PAUDIO_PKG_NAME)-pkg-install.sh

PAUDIO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PAUDIO_PKG_NAME)-package

pkg_basename     = $(PAUDIO_PKG_NAME)-$(PAUDIO_PKG_VERSION)-$(PAUDIO_PKG_ARCH)-$(PAUDIO_PKG_DISTRO_NAME)-$(PAUDIO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PAUDIO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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

extra_configure_switches += --enable-webrtc-aec=no
extra_configure_switches += --enable-adrian-aec=no


extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC))
extra_environment  = LIBS="-lrt -lpthread -lgomp -lm -lstdc++"
endif


CFLAGS += -Wno-cast-align -Wno-cpp


TARGET_BIN_RPATH = /usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/pulseaudio
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/pulseaudio

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
	  $(BUILD_ENVIRONMENT) $(extra_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PAUDIO_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install system scripts =======
	@mkdir -p $(PAUDIO_PKG)/etc/rc.d
	@cp -a $(rc_pulseaudio) $(PAUDIO_PKG)/etc/rc.d/rc.pulseaudio.new
	@chmod 644 $(PAUDIO_PKG)/etc/rc.d/rc.pulseaudio.new
	@mv $(PAUDIO_PKG)/etc/pulse/client.conf $(PAUDIO_PKG)/etc/pulse/client.conf.new
	@mv $(PAUDIO_PKG)/etc/pulse/daemon.conf $(PAUDIO_PKG)/etc/pulse/daemon.conf.new
	@mv $(PAUDIO_PKG)/etc/pulse/default.pa  $(PAUDIO_PKG)/etc/pulse/default.pa.new
	@mv $(PAUDIO_PKG)/etc/pulse/system.pa   $(PAUDIO_PKG)/etc/pulse/system.pa.new
	@mv $(PAUDIO_PKG)/etc/dbus-1/system.d/pulseaudio-system.conf $(PAUDIO_PKG)/etc/dbus-1/system.d/pulseaudio-system.conf.new
	# ======= Install Documentation =======
	@if [ -d $(PAUDIO_PKG)/usr/share/man ]; then \
	  ( cd $(PAUDIO_PKG)/usr/share/man ; \
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
	@mkdir -p $(PAUDIO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/GPL $(SRC_DIR)/LGPL $(SRC_DIR)/LICENSE \
	       $(PAUDIO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PAUDIO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a GPL LGPL LICENSE NEWS PROTOCOL README \
	         $(PAUDIO_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PAUDIO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PAUDIO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpulse-mainloop-glib.la        \
	                                    libpulse-simple.la libpulse.la ; \
	 )
	@( cd $(PAUDIO_PKG)/usr/lib$(LIBSUFFIX)/pulseaudio ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpulsecommon-9.0.la  \
	                                    libpulsecore-9.0.la    \
	                                    libpulsedsp.la       ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PAUDIO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulse-mainloop-glib.la        \
	                                            libpulse-simple.la libpulse.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpulse-mainloop-glib.la        \
	                                              libpulse-simple.la libpulse.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pulseaudio ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulsecommon-9.0.la  \
	                                            libpulsecore-9.0.la    \
	                                            libpulsedsp.la       ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpulsecommon-9.0.la  \
	                                              libpulsecore-9.0.la    \
	                                              libpulsedsp.la       ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpulse-mainloop-glib.pc        \
	                                            libpulse-simple.pc libpulse.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PAUDIO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(PAUDIO_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PAUDIO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PAUDIO_PKG_DESCRIPTION_FILE): $(PAUDIO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PAUDIO_PKG_DESCRIPTION_FILE) $(PAUDIO_PKG_INSTALL_SCRIPT)
	@cp $(PAUDIO_PKG_DESCRIPTION_FILE) $(PAUDIO_PKG)/.DESCRIPTION
	@cp $(PAUDIO_PKG_INSTALL_SCRIPT) $(PAUDIO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PAUDIO_PKG)/.REQUIRES
	@echo "pkgname=$(PAUDIO_PKG_NAME)"                            >  $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PAUDIO_PKG_VERSION)"                          >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "arch=$(PAUDIO_PKG_ARCH)"                               >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "distroname=$(PAUDIO_PKG_DISTRO_NAME)"                  >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "distrover=$(PAUDIO_PKG_DISTRO_VERSION)"                >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "group=$(PAUDIO_PKG_GROUP)"                             >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PAUDIO_PKG_SHORT_DESCRIPTION)\"" >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "url=$(PAUDIO_PKG_URL)"                                 >> $(PAUDIO_PKG)/.PKGINFO ; \
	 echo "license=$(PAUDIO_PKG_LICENSE)"                         >> $(PAUDIO_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PAUDIO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
