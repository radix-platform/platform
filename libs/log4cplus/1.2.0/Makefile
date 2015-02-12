
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/log4cplus

REQUIRES           = dev/gcc/4.9.1
REQUIRES          += X11/libs/qt4/4.8.6
REQUIRES          += dev/python2/2.7.6

PYTHON_VERSION = 2.7


version            = 1.2.0
candidate          = rc3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/log4cplus/log4cplus-$(version)-$(candidate).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/log4cplus-$(version)-$(candidate)
src_dir_name       = log4cplus-$(version)-$(candidate)
doc_dir_name       = log4cplus-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LOG4CPLUS_PKG_NAME                = log4cplus
LOG4CPLUS_PKG_VERSION             = 1.2.0
LOG4CPLUS_PKG_ARCH                = $(TOOLCHAIN)
LOG4CPLUS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LOG4CPLUS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LOG4CPLUS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LOG4CPLUS_PKG_SHORT_DESCRIPTION   = log management library
LOG4CPLUS_PKG_URL                 = $(BUG_URL)
LOG4CPLUS_PKG_LICENSE             = BSD
LOG4CPLUS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LOG4CPLUS_PKG_NAME)-pkg-description
LOG4CPLUS_PKG_DESCRIPTION_FILE_IN = $(LOG4CPLUS_PKG_NAME)-pkg-description.in
LOG4CPLUS_PKG_INSTALL_SCRIPT      = $(LOG4CPLUS_PKG_NAME)-pkg-install.sh

LOG4CPLUS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LOG4CPLUS_PKG_NAME)-package

pkg_basename     = $(LOG4CPLUS_PKG_NAME)-$(LOG4CPLUS_PKG_VERSION)-$(LOG4CPLUS_PKG_ARCH)-$(LOG4CPLUS_PKG_DISTRO_NAME)-$(LOG4CPLUS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LOG4CPLUS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-qt
extra_configure_switches += --with-python

extra_configure_switches += --without-c++11-threads
extra_configure_switches += --without-qt5

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PKG=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_CPPFLAGS=-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LDFLAGS="-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lpython$(PYTHON_VERSION)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LOG4CPLUS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@if [ -d $(LOG4CPLUS_PKG)/usr/share/man ]; then \
	  ( cd $(LOG4CPLUS_PKG)/usr/share/man ; \
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
	@mkdir -p $(LOG4CPLUS_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE \
	       $(LOG4CPLUS_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LOG4CPLUS_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL LICENSE NEWS README.md REVISION TODO simpleserver \
	         $(LOG4CPLUS_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LOG4CPLUS_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LOG4CPLUS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblog4cplus.la liblog4cplusqt4debugappender.la \
	 )
	@( cd $(LOG4CPLUS_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/log4cplus ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _log4cplus.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LOG4CPLUS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblog4cplus.la liblog4cplusqt4debugappender.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblog4cplus.la liblog4cplusqt4debugappender.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/log4cplus ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _log4cplus.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _log4cplus.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" log4cplus.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LOG4CPLUS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LOG4CPLUS_PKG_DESCRIPTION_FILE): $(LOG4CPLUS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LOG4CPLUS_PKG_DESCRIPTION_FILE) $(LOG4CPLUS_PKG_INSTALL_SCRIPT)
	@cp $(LOG4CPLUS_PKG_DESCRIPTION_FILE) $(LOG4CPLUS_PKG)/.DESCRIPTION
	@cp $(LOG4CPLUS_PKG_INSTALL_SCRIPT) $(LOG4CPLUS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LOG4CPLUS_PKG)/.REQUIRES
	@echo "pkgname=$(LOG4CPLUS_PKG_NAME)"                            >  $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LOG4CPLUS_PKG_VERSION)"                          >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "arch=$(LOG4CPLUS_PKG_ARCH)"                               >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "distroname=$(LOG4CPLUS_PKG_DISTRO_NAME)"                  >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "distrover=$(LOG4CPLUS_PKG_DISTRO_VERSION)"                >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "group=$(LOG4CPLUS_PKG_GROUP)"                             >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LOG4CPLUS_PKG_SHORT_DESCRIPTION)\"" >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "url=$(LOG4CPLUS_PKG_URL)"                                 >> $(LOG4CPLUS_PKG)/.PKGINFO ; \
	 echo "license=$(LOG4CPLUS_PKG_LICENSE)"                         >> $(LOG4CPLUS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LOG4CPLUS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."