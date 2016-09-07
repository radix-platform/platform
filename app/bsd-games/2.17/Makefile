
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


SOURCE_REQUIRES    = sources/packages/y/bsd-games

REQUIRES           = libs/libtermcap/1.2.3
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += dev/flex/2.6.0

# ======= __END_OF_REQUIRES__ =======


version            = 2.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/y/bsd-games/bsd-games-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bsd-games-$(version)
src_dir_name       = bsd-games-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

etc_profile_d      = $(CURDIR)/etc/profile.d
datfiles_dir       = $(CURDIR)/datfiles

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BSD_GAMES_PKG_NAME                = bsd-games
BSD_GAMES_PKG_VERSION             = 2.17
BSD_GAMES_PKG_ARCH                = $(TOOLCHAIN)
BSD_GAMES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BSD_GAMES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BSD_GAMES_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
BSD_GAMES_PKG_SHORT_DESCRIPTION   = Classic BSD text games collection
BSD_GAMES_PKG_URL                 = $(BUG_URL)
BSD_GAMES_PKG_LICENSE             = BSD
BSD_GAMES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BSD_GAMES_PKG_NAME)-pkg-description
BSD_GAMES_PKG_DESCRIPTION_FILE_IN = $(BSD_GAMES_PKG_NAME)-pkg-description.in
BSD_GAMES_PKG_INSTALL_SCRIPT      = $(BSD_GAMES_PKG_NAME)-pkg-install.sh

BSD_GAMES_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BSD_GAMES_PKG_NAME)-package

pkg_basename     = $(BSD_GAMES_PKG_NAME)-$(BSD_GAMES_PKG_VERSION)-$(BSD_GAMES_PKG_ARCH)-$(BSD_GAMES_PKG_DISTRO_NAME)-$(BSD_GAMES_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BSD_GAMES_PKG)


environment  = BUILD_CC=gcc
environment += BUILD_CXX=g++


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   sed -i "s,@BSD_GAMES_PKG@,$(BSD_GAMES_PKG),g"            config.params ; \
	   sed -i 's,@CC@,"$(CC) --sysroot=$(TARGET_DEST_DIR)",g'   config.params ; \
	   sed -i 's,@CXX@,"$(CXX) --sysroot=$(TARGET_DEST_DIR)",g' config.params ; \
	   sed -i 's,@OPTIMIZE_FLAGS@,\"$(OPTIMIZATION_FLAGS)\",g'  config.params ; \
	   sed -i 's,@NCURSES_LIB@,-lncursesw,g'                    config.params ; \
	   sed -i 's,@OPENSSL_LIB@,-lcrypto,g'                      config.params ; \
	   sed -i 's,@CFLAGS@,\"$(CFLAGS)\",g'                      config.params ; \
	   sed -i 's,@LDFLAGS@,\"$(LDFLAGS)\",g'                    config.params ; \
	   $(BUILD_ENVIRONMENT) $(environment) ./configure ; \
	 )
	@( cd $(SRC_DIR) ; \
	   $(environment) $(MAKE) fortune/strfile/strfile_build ; \
	 )
	@( cd $(SRC_DIR)/fortune/datfiles ;           \
	   if [ -x ../strfile/strfile_build ] ; then  \
	     cp unamerican-o.real unamerican-o.fake ; \
	     cp unamerican-o.real unamerican-o      ; \
	     ../strfile/strfile_build unamerican-o unamerican-o.dat  ; \
	   fi ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BSD_GAMES_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install
	# ======= Add profile scripts =======
	@( cd $(BSD_GAMES_PKG) ; \
	   mkdir -p etc/profile.d ; \
	   cat $(etc_profile_d)/bsd-games-login-fortune.sh  > etc/profile.d/bsd-games-login-fortune.sh  ; \
	   cat $(etc_profile_d)/bsd-games-login-fortune.csh > etc/profile.d/bsd-games-login-fortune.csh ; \
	   chmod 755 etc/profile.d/bsd-games-login-fortune.*  ; \
	 )
	@rm -f $(BSD_GAMES_PKG)/usr/share/games/fortune/limerick*
	@( cd $(BSD_GAMES_PKG)/var/lib/bsdgames ; \
	   for file in atc_score battlestar.log cfscores criblog robots_roll \
	               saillog snake.log snakerawscores tetris-bsd.scores ; do \
	     mv $$file $$file.new ; \
	     chmod 0666 $$file.new ; \
	   done ; \
	 )
	@chmod 0777 $(BSD_GAMES_PKG)/var/lib/bsdgames/hack
	@( cd $(BSD_GAMES_PKG)/var/lib/bsdgames/hack ; \
	   mv record record.new ; \
	   chmod 0666 record.new ; \
	 )
	@( cd $(BSD_GAMES_PKG)/var/lib/bsdgames/phantasia ; \
	   for file in characs gold lastdead mess monsters motd scoreboard void ; do \
	     mv $$file $$file.new ; \
	     chmod 0666 $$file.new ; \
	   done ; \
	 )
	@( cd $(BSD_GAMES_PKG)/usr/share/games/fortune ; \
	   for fl in $(datfiles_dir)/* ; do \
	     file=`basename $$fl` ; \
	     cp $(datfiles_dir)/$$file . ; \
	     $(CURDIR)/$(SRC_DIR)/fortune/strfile/strfile_build -rs $$file $$file.dat ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@( cd $(BSD_GAMES_PKG)/usr/share/man/man6 ; \
	   rm -f cfscores.6.gz    ; ln -sf canfield.6.gz   cfscores.6.gz    ; \
	   rm -f morse.6.gz       ; ln -sf bcd.6.gz        morse.6.gz       ; \
	   rm -f ppt.6.gz         ; ln -sf bcd.6.gz        ppt.6.gz         ; \
	   rm -f rot13.6.gz       ; ln -sf caesar.6.gz     rot13.6.gz       ; \
	   rm -f snscore.6.gz     ; ln -sf snake.6.gz      snscore.6.gz     ; \
	   rm -f teachgammon.6.gz ; ln -sf backgammon.6.gz teachgammon.6.gz ; \
	 )
	@( cd $(BSD_GAMES_PKG)/usr/share/doc ; rm -rf bsd-games )
	@mkdir -p $(BSD_GAMES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(BSD_GAMES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/{fortune,hunt,phantasia,trek}
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING INSTALL NEWS PACKAGING README SECURITY THANKS TODO YEAR2000 \
	         $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a fortune/README       $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/fortune   ; \
	   cp -a hunt/README          $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/hunt      ; \
	   cp -a phantasia/COPYRIGHT  $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/phantasia ; \
	   cp -a phantasia/OWNER      $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/phantasia ; \
	   cp -a phantasia/README     $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/phantasia ; \
	   cp -a trek/USD.doc/trek.me $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/trek      ; \
	   cp -a trek/DOC             $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)/trek      ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BSD_GAMES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BSD_GAMES_PKG))
	# ======= Strip binaries =======
	@( cd $(BSD_GAMES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(BSD_GAMES_PKG_DESCRIPTION_FILE): $(BSD_GAMES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BSD_GAMES_PKG_DESCRIPTION_FILE) $(BSD_GAMES_PKG_INSTALL_SCRIPT)
	@cp $(BSD_GAMES_PKG_DESCRIPTION_FILE) $(BSD_GAMES_PKG)/.DESCRIPTION
	@cp $(BSD_GAMES_PKG_INSTALL_SCRIPT) $(BSD_GAMES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BSD_GAMES_PKG)/.REQUIRES
	@echo "pkgname=$(BSD_GAMES_PKG_NAME)"                            >  $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BSD_GAMES_PKG_VERSION)"                          >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "arch=$(BSD_GAMES_PKG_ARCH)"                               >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "distroname=$(BSD_GAMES_PKG_DISTRO_NAME)"                  >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "distrover=$(BSD_GAMES_PKG_DISTRO_VERSION)"                >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "group=$(BSD_GAMES_PKG_GROUP)"                             >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BSD_GAMES_PKG_SHORT_DESCRIPTION)\"" >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "url=$(BSD_GAMES_PKG_URL)"                                 >> $(BSD_GAMES_PKG)/.PKGINFO ; \
	 echo "license=$(BSD_GAMES_PKG_LICENSE)"                         >> $(BSD_GAMES_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BSD_GAMES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
