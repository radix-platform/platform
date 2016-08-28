
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/freetype

REQUIRES           = app/bzip2/1.0.6
REQUIRES          += libs/libpng/libpng14/1.4.19

# ======= __END_OF_REQUIRES__ =======


version            = 2.6.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/freetype/freetype-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/freetype-$(version)
src_dir_name       = freetype-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

FREETYPE_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/freetype-package

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FREETYPE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --without-harfbuzz
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FREETYPE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(FREETYPE_PKG)/usr/include ; ln -sf freetype2 freetype ; )
	# ======= Install Documentation =======
	@if [ -d $(FREETYPE_PKG)/usr/share/man ]; then \
	  ( cd $(FREETYPE_PKG)/usr/share/man ; \
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
	@mkdir -p $(FREETYPE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/docs/FTL.TXT $(SRC_DIR)/docs/GPLv2.TXT $(SRC_DIR)/docs/LICENSE.TXT \
	       $(FREETYPE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR)/docs ; \
	   cp -a ../README* \
	         CHANGES CUSTOMIZE DEBUG INSTALL* \
	         PROBLEMS TODO VERSION.DLL *.txt  \
	         FTL.TXT GPLv2.TXT LICENSE.TXT    \
	         $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/docs/reference ; \
	   cp -a *.html $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FREETYPE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfreetype.la ; \
	 )
	# ======= remove toolchain path from target freetype-config script =======
	@( cd $(FREETYPE_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" freetype-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FREETYPE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfreetype.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfreetype.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" freetype?.pc \
	 )
	# ======= tune freetype-config script search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i 's,="/usr,="$(TARGET_DEST_DIR)/usr,g' freetype-config ; \
	   sed -i 's,L/usr,L$(TARGET_DEST_DIR)/usr,g' freetype-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FREETYPE_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
