
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/bind

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = secure/libcap/2.24
REQUIRES          += libs/json-c/0.12
REQUIRES          += libs/libxml2/2.9.1
REQUIRES          += net/idnkit/1.0
else
REQUIRES           = secure/libcap/2.24-x86_32
REQUIRES          += libs/json-c/0.12-x86_32
REQUIRES          += libs/libxml2/2.9.1-x86_32
REQUIRES          += net/idnkit/1.0-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 9.10.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/bind/bind-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bind-$(version)
src_dir_name       = bind-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

caching_dir        = $(CURDIR)/caching-example
rc_bind            = $(CURDIR)/etc/rc.d/rc.bind


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BIND_PKG_NAME                = bind
BIND_PKG_VERSION             = 9.10.1
BIND_PKG_ARCH                = $(TOOLCHAIN)
BIND_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BIND_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BIND_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
BIND_PKG_SHORT_DESCRIPTION   = DNS server and utilities
BIND_PKG_URL                 = $(BUG_URL)
BIND_PKG_LICENSE             = custom
BIND_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BIND_PKG_NAME)-pkg-description
BIND_PKG_DESCRIPTION_FILE_IN = $(BIND_PKG_NAME)-pkg-description.in
BIND_PKG_INSTALL_SCRIPT      = $(BIND_PKG_NAME)-pkg-install.sh

BIND_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BIND_PKG_NAME)-package

pkg_basename     = $(BIND_PKG_NAME)-$(BIND_PKG_VERSION)-$(BIND_PKG_ARCH)-$(BIND_PKG_DISTRO_NAME)-$(BIND_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(BIND_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-libtool
extra_configure_switches += --with-idn=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-libxml2=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-openssl=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-ecdsa=yes
extra_configure_switches += --with-gost=yes
extra_configure_switches += --with-libjson=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_configure_switches += --with-randomdev=/dev/random

dev_environment  = BUILD_CC=gcc


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(dev_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@( cd $(build_dir)/make ; \
	   sed -i "s,^\(STD_CINCLUDES =\).*,\1 -I${TARGET_DEST_DIR}/usr/include," rules ; \
	 )
	@( cd $(build_dir) ; \
	   for file in `find . -type f -name "Makefile*"` ; do \
	     sed -i "s,^\(STD_CINCLUDES =\).*,\1 -I${TARGET_DEST_DIR}/usr/include," $$file ; \
	   done ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BIND_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(BIND_PKG)/usr/bin ; \
	   rm -f bind9-config ; ln -sf isc-config.sh bind9-config ; \
	 )
	@mkdir -p $(BIND_PKG)/etc/rc.d
	@mkdir -p $(BIND_PKG)/etc/default
	@cp -a $(rc_bind) $(BIND_PKG)/etc/rc.d/rc.bind.new
	@chmod 0644 $(BIND_PKG)/etc/rc.d/rc.bind.new
	@mkdir -p $(BIND_PKG)/var/run/named
	# ======= Install Documentation =======
	@( cd $(BIND_PKG)/usr/share/man/man1 ; \
	   rm -f bind9-config.1 ; \
	   ln -sf isc-config.sh.1 bind9-config.1 ; \
	 )
	@( cd $(BIND_PKG)/usr/share/man/man8 ; \
	   rm -f named-compilezone.8 ; \
	   ln -sf named-checkzone.8 named-compilezone.8 ; \
	   rm -f tsig-keygen.8 ; \
	   ln -sf ddns-confgen.8 tsig-keygen.8 ; \
	 )
	@( cd $(BIND_PKG)/usr/share/man/man3 ; \
	   rm -f lwres_addr_parse.3            ; ln -sf lwres_resutil.3 lwres_addr_parse.3           ; \
	   rm -f lwres_buffer_add.3            ; ln -sf lwres_buffer.3 lwres_buffer_add.3            ; \
	   rm -f lwres_buffer_back.3           ; ln -sf lwres_buffer.3 lwres_buffer_back.3           ; \
	   rm -f lwres_buffer_clear.3          ; ln -sf lwres_buffer.3 lwres_buffer_clear.3          ; \
	   rm -f lwres_buffer_first.3          ; ln -sf lwres_buffer.3 lwres_buffer_first.3          ; \
	   rm -f lwres_buffer_forward.3        ; ln -sf lwres_buffer.3 lwres_buffer_forward.3        ; \
	   rm -f lwres_buffer_getmem.3         ; ln -sf lwres_buffer.3 lwres_buffer_getmem.3         ; \
	   rm -f lwres_buffer_getuint16.3      ; ln -sf lwres_buffer.3 lwres_buffer_getuint16.3      ; \
	   rm -f lwres_buffer_getuint32.3      ; ln -sf lwres_buffer.3 lwres_buffer_getuint32.3      ; \
	   rm -f lwres_buffer_getuint8.3       ; ln -sf lwres_buffer.3 lwres_buffer_getuint8.3       ; \
	   rm -f lwres_buffer_init.3           ; ln -sf lwres_buffer.3 lwres_buffer_init.3           ; \
	   rm -f lwres_buffer_invalidate.3     ; ln -sf lwres_buffer.3 lwres_buffer_invalidate.3     ; \
	   rm -f lwres_buffer_putmem.3         ; ln -sf lwres_buffer.3 lwres_buffer_putmem.3         ; \
	   rm -f lwres_buffer_putuint16.3      ; ln -sf lwres_buffer.3 lwres_buffer_putuint16.3      ; \
	   rm -f lwres_buffer_putuint32.3      ; ln -sf lwres_buffer.3 lwres_buffer_putuint32.3      ; \
	   rm -f lwres_buffer_putuint8.3       ; ln -sf lwres_buffer.3 lwres_buffer_putuint8.3       ; \
	   rm -f lwres_buffer_subtract.3       ; ln -sf lwres_buffer.3 lwres_buffer_subtract.3       ; \
	   rm -f lwres_conf_clear.3            ; ln -sf lwres_config.3 lwres_conf_clear.3            ; \
	   rm -f lwres_conf_get.3              ; ln -sf lwres_config.3 lwres_conf_get.3              ; \
	   rm -f lwres_conf_init.3             ; ln -sf lwres_config.3 lwres_conf_init.3             ; \
	   rm -f lwres_conf_parse.3            ; ln -sf lwres_config.3 lwres_conf_parse.3            ; \
	   rm -f lwres_conf_print.3            ; ln -sf lwres_config.3 lwres_conf_print.3            ; \
	   rm -f lwres_context_allocmem.3      ; ln -sf lwres_context.3 lwres_context_allocmem.3     ; \
	   rm -f lwres_context_create.3        ; ln -sf lwres_context.3 lwres_context_create.3       ; \
	   rm -f lwres_context_destroy.3       ; ln -sf lwres_context.3 lwres_context_destroy.3      ; \
	   rm -f lwres_context_freemem.3       ; ln -sf lwres_context.3 lwres_context_freemem.3      ; \
	   rm -f lwres_context_initserial.3    ; ln -sf lwres_context.3 lwres_context_initserial.3   ; \
	   rm -f lwres_context_nextserial.3    ; ln -sf lwres_context.3 lwres_context_nextserial.3   ; \
	   rm -f lwres_context_sendrecv.3      ; ln -sf lwres_context.3 lwres_context_sendrecv.3     ; \
	   rm -f lwres_endhostent.3            ; ln -sf lwres_gethostent.3 lwres_endhostent.3        ; \
	   rm -f lwres_endhostent_r.3          ; ln -sf lwres_gethostent.3 lwres_endhostent_r.3      ; \
	   rm -f lwres_freeaddrinfo.3          ; ln -sf lwres_getaddrinfo.3 lwres_freeaddrinfo.3     ; \
	   rm -f lwres_freehostent.3           ; ln -sf lwres_getipnode.3 lwres_freehostent.3        ; \
	   rm -f lwres_gabnrequest_free.3      ; ln -sf lwres_gabn.3 lwres_gabnrequest_free.3        ; \
	   rm -f lwres_gabnrequest_parse.3     ; ln -sf lwres_gabn.3 lwres_gabnrequest_parse.3       ; \
	   rm -f lwres_gabnrequest_render.3    ; ln -sf lwres_gabn.3 lwres_gabnrequest_render.3      ; \
	   rm -f lwres_gabnresponse_free.3     ; ln -sf lwres_gabn.3 lwres_gabnresponse_free.3       ; \
	   rm -f lwres_gabnresponse_parse.3    ; ln -sf lwres_gabn.3 lwres_gabnresponse_parse.3      ; \
	   rm -f lwres_gabnresponse_render.3   ; ln -sf lwres_gabn.3 lwres_gabnresponse_render.3     ; \
	   rm -f lwres_getaddrsbyname.3        ; ln -sf lwres_resutil.3 lwres_getaddrsbyname.3       ; \
	   rm -f lwres_gethostbyaddr.3         ; ln -sf lwres_gethostent.3 lwres_gethostbyaddr.3     ; \
	   rm -f lwres_gethostbyaddr_r.3       ; ln -sf lwres_gethostent.3 lwres_gethostbyaddr_r.3   ; \
	   rm -f lwres_gethostbyname.3         ; ln -sf lwres_gethostent.3 lwres_gethostbyname.3     ; \
	   rm -f lwres_gethostbyname2.3        ; ln -sf lwres_gethostent.3 lwres_gethostbyname2.3    ; \
	   rm -f lwres_gethostbyname_r.3       ; ln -sf lwres_gethostent.3 lwres_gethostbyname_r.3   ; \
	   rm -f lwres_gethostent_r.3          ; ln -sf lwres_gethostent.3 lwres_gethostent_r.3      ; \
	   rm -f lwres_getipnodebyaddr.3       ; ln -sf lwres_getipnode.3 lwres_getipnodebyaddr.3    ; \
	   rm -f lwres_getipnodebyname.3       ; ln -sf lwres_getipnode.3 lwres_getipnodebyname.3    ; \
	   rm -f lwres_getnamebyaddr.3         ; ln -sf lwres_resutil.3 lwres_getnamebyaddr.3        ; \
	   rm -f lwres_gnbarequest_free.3      ; ln -sf lwres_gnba.3 lwres_gnbarequest_free.3        ; \
	   rm -f lwres_gnbarequest_parse.3     ; ln -sf lwres_gnba.3 lwres_gnbarequest_parse.3       ; \
	   rm -f lwres_gnbarequest_render.3    ; ln -sf lwres_gnba.3 lwres_gnbarequest_render.3      ; \
	   rm -f lwres_gnbaresponse_free.3     ; ln -sf lwres_gnba.3 lwres_gnbaresponse_free.3       ; \
	   rm -f lwres_gnbaresponse_parse.3    ; ln -sf lwres_gnba.3 lwres_gnbaresponse_parse.3      ; \
	   rm -f lwres_gnbaresponse_render.3   ; ln -sf lwres_gnba.3 lwres_gnbaresponse_render.3     ; \
	   rm -f lwres_herror.3                ; ln -sf lwres_hstrerror.3 lwres_herror.3             ; \
	   rm -f lwres_lwpacket_parseheader.3  ; ln -sf lwres_packet.3 lwres_lwpacket_parseheader.3  ; \
	   rm -f lwres_lwpacket_renderheader.3 ; ln -sf lwres_packet.3 lwres_lwpacket_renderheader.3 ; \
	   rm -f lwres_net_ntop.3              ; ln -sf lwres_inetntop.3 lwres_net_ntop.3            ; \
	   rm -f lwres_nooprequest_free.3      ; ln -sf lwres_noop.3 lwres_nooprequest_free.3        ; \
	   rm -f lwres_nooprequest_parse.3     ; ln -sf lwres_noop.3 lwres_nooprequest_parse.3       ; \
	   rm -f lwres_nooprequest_render.3    ; ln -sf lwres_noop.3 lwres_nooprequest_render.3      ; \
	   rm -f lwres_noopresponse_free.3     ; ln -sf lwres_noop.3 lwres_noopresponse_free.3       ; \
	   rm -f lwres_noopresponse_parse.3    ; ln -sf lwres_noop.3 lwres_noopresponse_parse.3      ; \
	   rm -f lwres_noopresponse_render.3   ; ln -sf lwres_noop.3 lwres_noopresponse_render.3     ; \
	   rm -f lwres_sethostent.3            ; ln -sf lwres_gethostent.3 lwres_sethostent.3        ; \
	   rm -f lwres_sethostent_r.3          ; ln -sf lwres_gethostent.3 lwres_sethostent_r.3      ; \
	   rm -f lwres_string_parse.3          ; ln -sf lwres_resutil.3 lwres_string_parse.3         ; \
	 )
	@if [ -d $(BIND_PKG)/usr/share/man ]; then \
	  ( cd $(BIND_PKG)/usr/share/man ; \
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
	@mkdir -p $(BIND_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(BIND_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BIND_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT FAQ HISTORY README doc/arm doc/misc \
	         $(BIND_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(BIND_PKG)/usr/share/doc/$(src_dir_name)/arm ; \
	   rm -f Makefile* *.xml README-SGML latex-fixup.pl ; \
	 )
	@( cd $(BIND_PKG)/usr/share/doc/$(src_dir_name)/misc ; \
	   rm -f Makefile* ; \
	 )
	@mkdir -p $(BIND_PKG)/usr/share/doc/$(src_dir_name)/rndc
	@( cd $(SRC_DIR)/bin/rndc ; \
	   cp -a rndc.conf *.html \
	         $(BIND_PKG)/usr/share/doc/$(src_dir_name)/rndc ; \
	 )
	@( cd $(BIND_PKG)/usr/share/doc/$(src_dir_name)/rndc ; \
	   mv rndc.conf rndc.conf-example ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(BIND_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Add sample config files for a simple caching nameserver =======
	@mkdir -p $(BIND_PKG)/var/named/caching-example
	@cat $(caching_dir)/named.conf     > $(BIND_PKG)/etc/named.conf.new
	@cat $(caching_dir)/localhost.zone > $(BIND_PKG)/var/named/caching-example/localhost.zone
	@cat $(caching_dir)/named.local    > $(BIND_PKG)/var/named/caching-example/named.local
	@cat $(caching_dir)/named.root     > $(BIND_PKG)/var/named/caching-example/named.root
	# ------- add deprecated 'named.ca' sample for old configurations -------
	@cat $(caching_dir)/named.root     > $(BIND_PKG)/var/named/caching-example/named.ca
	# ======= remove toolchain path from /usr/bin/isc-config.sh file =======
	@( cd $(BIND_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" isc-config.sh ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(BIND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbind9.la libdns.la libirs.la \
	                                    libisc.la libisccc.la libisccfg.la liblwres.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BIND_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libbind9.la libdns.la libirs.la   \
	                                            libisc.la libisccc.la libisccfg.la liblwres.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libbind9.la libdns.la libirs.la \
	                                              libisc.la libisccc.la libisccfg.la liblwres.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr," isc-config.sh ; \
	 )
	# ======= Strip binaries =======
	@( cd $(BIND_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(BIND_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(BIND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(BIND_PKG_DESCRIPTION_FILE): $(BIND_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BIND_PKG_DESCRIPTION_FILE) $(BIND_PKG_INSTALL_SCRIPT)
	@cp $(BIND_PKG_DESCRIPTION_FILE) $(BIND_PKG)/.DESCRIPTION
	@cp $(BIND_PKG_INSTALL_SCRIPT) $(BIND_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BIND_PKG)/.REQUIRES
	@echo "pkgname=$(BIND_PKG_NAME)"                            >  $(BIND_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BIND_PKG_VERSION)"                          >> $(BIND_PKG)/.PKGINFO ; \
	 echo "arch=$(BIND_PKG_ARCH)"                               >> $(BIND_PKG)/.PKGINFO ; \
	 echo "distroname=$(BIND_PKG_DISTRO_NAME)"                  >> $(BIND_PKG)/.PKGINFO ; \
	 echo "distrover=$(BIND_PKG_DISTRO_VERSION)"                >> $(BIND_PKG)/.PKGINFO ; \
	 echo "group=$(BIND_PKG_GROUP)"                             >> $(BIND_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BIND_PKG_SHORT_DESCRIPTION)\"" >> $(BIND_PKG)/.PKGINFO ; \
	 echo "url=$(BIND_PKG_URL)"                                 >> $(BIND_PKG)/.PKGINFO ; \
	 echo "license=$(BIND_PKG_LICENSE)"                         >> $(BIND_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BIND_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
