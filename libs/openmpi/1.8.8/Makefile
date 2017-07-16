
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


SOURCE_REQUIRES    = sources/packages/l/openmpi

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += libs/hwloc/1.11.3
REQUIRES          += dev/libtool/2.4.6

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.8
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/openmpi/openmpi-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openmpi-$(version)
src_dir_name       = openmpi-$(version)
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
OMPI_PKG_NAME                = openmpi
OMPI_PKG_VERSION             = 1.8.8
OMPI_PKG_ARCH                = $(TOOLCHAIN)
OMPI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OMPI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OMPI_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
OMPI_PKG_SHORT_DESCRIPTION   = Message Passing Interface
OMPI_PKG_URL                 = $(BUG_URL)
OMPI_PKG_LICENSE             = custom
OMPI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OMPI_PKG_NAME)-pkg-description
OMPI_PKG_DESCRIPTION_FILE_IN = $(OMPI_PKG_NAME)-pkg-description.in
OMPI_PKG_INSTALL_SCRIPT      = $(OMPI_PKG_NAME)-pkg-install.sh

OMPI_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OMPI_PKG_NAME)-package

pkg_basename     = $(OMPI_PKG_NAME)-$(OMPI_PKG_VERSION)-$(OMPI_PKG_ARCH)-$(OMPI_PKG_DISTRO_NAME)-$(OMPI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(OMPI_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc/openmpi
extra_configure_switches += --with-threads=posix
extra_configure_switches += --enable-smp-locks
extra_configure_switches += --enable-pretty-print-stacktrace
extra_configure_switches += --disable-mpi-fortran
extra_configure_switches += --enable-java=no
extra_configure_switches += --disable-memchecker
extra_configure_switches += --without-valgrind
extra_configure_switches += --without-slurm
extra_configure_switches += --with-hwloc=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-libltdl=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

LDFLAGS += -Wl,-z,noexecstack


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(OMPI_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Openmpi's otfinfo conflicts with the one from texlive =======
	@mv $(OMPI_PKG)/usr/bin/otfinfo{,-mpi}
	# ======= Remove dangling symlink and useless file =======
	@rm $(OMPI_PKG)/usr/share/vampirtrace/config.log
	# ======= Install Documentation =======
	@( cd $(OMPI_PKG)/usr/share/man/man3 ; \
	   sed -i '/nroff/d' MPI_File_f2c.3 ; \
	 )
	@( cd $(OMPI_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(OMPI_PKG)/usr/share/man ]; then \
	  ( cd $(OMPI_PKG)/usr/share/man ; \
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
	@mkdir -p $(OMPI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE \
	       $(OMPI_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OMPI_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS INSTALL NEWS README* VERSION \
	         $(OMPI_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OMPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmpi.la libmpi_cxx.la                 \
	                                    libompitrace.la libopen-pal.la          \
	                                    libopen-rte.la libopen-trace-format.la  \
	                                    liboshmem.la libotfaux.la libvt-hyb.la  \
	                                    libvt-mpi-unify.la libvt-mpi.la         \
	                                    libvt-mt.la libvt-pomp.la libvt.la    ; \
	 )
	@( cd $(OMPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s, -L$(CURDIR)/$(TARGET_BUILD_DIR).*\.libs,,g" libopen-trace-format.la              \
	                                                          libotfaux.la libvt-hyb.la            \
	                                                          libvt-mpi-unify.la libvt-mpi.la      \
	                                                          libvt-mt.la libvt-pomp.la libvt.la ; \
	 )
	@( cd $(OMPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" libvt-hyb.la libvt-mpi-unify.la libvt-mpi.la ; \
	 )
	@( cd $(OMPI_PKG)/usr/lib$(LIBSUFFIX)/openmpi ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libompi_dbg_msgq.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OMPI_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpi.la libmpi_cxx.la                 \
	                                            libompitrace.la libopen-pal.la          \
	                                            libopen-rte.la libopen-trace-format.la  \
	                                            liboshmem.la libotfaux.la libvt-hyb.la  \
	                                            libvt-mpi-unify.la libvt-mpi.la         \
	                                            libvt-mt.la libvt-pomp.la libvt.la    ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpi.la libmpi_cxx.la                 \
	                                              libompitrace.la libopen-pal.la          \
	                                              libopen-rte.la libopen-trace-format.la  \
	                                              liboshmem.la libotfaux.la libvt-hyb.la  \
	                                              libvt-mpi-unify.la libvt-mpi.la         \
	                                              libvt-mt.la libvt-pomp.la libvt.la    ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/openmpi ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libompi_dbg_msgq.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libompi_dbg_msgq.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ompi-c.pc ompi-cxx.pc  \
	                                            ompi-fort.pc ompi.pc   \
	                                            orte.pc              ; \
	 )
	# ======= Strip binaries =======
	@( cd $(OMPI_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(OMPI_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(OMPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(OMPI_PKG_DESCRIPTION_FILE): $(OMPI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OMPI_PKG_DESCRIPTION_FILE) $(OMPI_PKG_INSTALL_SCRIPT)
	@cp $(OMPI_PKG_DESCRIPTION_FILE) $(OMPI_PKG)/.DESCRIPTION
	@cp $(OMPI_PKG_INSTALL_SCRIPT) $(OMPI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OMPI_PKG)/.REQUIRES
	@echo "pkgname=$(OMPI_PKG_NAME)"                            >  $(OMPI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OMPI_PKG_VERSION)"                          >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "arch=$(OMPI_PKG_ARCH)"                               >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "distroname=$(OMPI_PKG_DISTRO_NAME)"                  >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "distrover=$(OMPI_PKG_DISTRO_VERSION)"                >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "group=$(OMPI_PKG_GROUP)"                             >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OMPI_PKG_SHORT_DESCRIPTION)\"" >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "url=$(OMPI_PKG_URL)"                                 >> $(OMPI_PKG)/.PKGINFO ; \
	 echo "license=$(OMPI_PKG_LICENSE)"                         >> $(OMPI_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OMPI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
