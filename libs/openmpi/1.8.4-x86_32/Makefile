
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/openmpi

REQUIRES           = libs/openmpi/1.8.4
REQUIRES          += libs/hwloc/1.11.3-x86_32
REQUIRES          += dev/libtool/2.4.6-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.4
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
OMPI_32_PKG_NAME                = openmpi-x32
OMPI_32_PKG_VERSION             = 1.8.4
OMPI_32_PKG_ARCH                = $(TOOLCHAIN)
OMPI_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OMPI_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OMPI_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
OMPI_32_PKG_SHORT_DESCRIPTION   = Message Passing Interface
OMPI_32_PKG_URL                 = $(BUG_URL)
OMPI_32_PKG_LICENSE             = custom
OMPI_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OMPI_32_PKG_NAME)-pkg-description
OMPI_32_PKG_DESCRIPTION_FILE_IN = $(OMPI_32_PKG_NAME)-pkg-description.in
OMPI_32_PKG_INSTALL_SCRIPT      = $(OMPI_32_PKG_NAME)-pkg-install.sh

OMPI_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OMPI_32_PKG_NAME)-package

pkg_basename     = $(OMPI_32_PKG_NAME)-$(OMPI_32_PKG_VERSION)-$(OMPI_32_PKG_ARCH)-$(OMPI_32_PKG_DISTRO_NAME)-$(OMPI_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(OMPI_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc/openmpi
extra_configure_switches += --with-threads=posix
extra_configure_switches += --enable-smp-locks
extra_configure_switches += --enable-pretty-print-stacktrace
extra_configure_switches += --disable-mpi-fortran
extra_configure_switches += --disable-memchecker
extra_configure_switches += --without-valgrind
extra_configure_switches += --without-slurm
extra_configure_switches += --with-hwloc=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-hwloc-libdir=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --with-libltdl=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-libltdl-libdir=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

LDFLAGS += -Wl,-z,noexecstack


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   rm -rf opal/libltdl ; \
	 )
	@touch -t 201401010000.00 $(SRC_DIR)/*
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OMPI_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(OMPI_32_PKG)/etc
	@rm -rf $(OMPI_32_PKG)/usr/include
	@rm -rf $(OMPI_32_PKG)/usr/share
	# ======= Openmpi's otfinfo conflicts with the one from texlive =======
	@mv $(OMPI_32_PKG)/usr/bin/32/otfinfo{,-mpi}
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OMPI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmpi.la libmpi_cxx.la                 \
	                                    libompitrace.la libopen-pal.la          \
	                                    libopen-rte.la libopen-trace-format.la  \
	                                    liboshmem.la libotfaux.la               \
	                                    libvt-hyb.la libvt-mpi-unify.la         \
	                                    libvt-mpi.la libvt-mt.la                \
	                                    libvt-pomp.la libvt.la                ; \
	 )
	@( cd $(OMPI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/openmpi ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libompi_dbg_msgq.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OMPI_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpi.la libmpi_cxx.la                 \
	                                            libompitrace.la libopen-pal.la          \
	                                            libopen-rte.la libopen-trace-format.la  \
	                                            liboshmem.la libotfaux.la               \
	                                            libvt-hyb.la libvt-mpi-unify.la         \
	                                            libvt-mpi.la libvt-mt.la                \
	                                            libvt-pomp.la libvt.la                ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpi.la libmpi_cxx.la                 \
	                                              libompitrace.la libopen-pal.la          \
	                                              libopen-rte.la libopen-trace-format.la  \
	                                              liboshmem.la libotfaux.la               \
	                                              libvt-hyb.la libvt-mpi-unify.la         \
	                                              libvt-mpi.la libvt-mt.la                \
	                                              libvt-pomp.la libvt.la                ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/openmpi ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libompi_dbg_msgq.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libompi_dbg_msgq.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ompi-c.pc ompi-cxx.pc  \
	                                            ompi-fort.pc ompi.pc   \
	                                            orte.pc              ; \
	 )
	# ======= Strip binaries =======
	@( cd $(OMPI_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(OMPI_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(OMPI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(OMPI_32_PKG_DESCRIPTION_FILE): $(OMPI_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OMPI_32_PKG_DESCRIPTION_FILE) $(OMPI_32_PKG_INSTALL_SCRIPT)
	@cp $(OMPI_32_PKG_DESCRIPTION_FILE) $(OMPI_32_PKG)/.DESCRIPTION
	@cp $(OMPI_32_PKG_INSTALL_SCRIPT) $(OMPI_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OMPI_32_PKG)/.REQUIRES
	@echo "pkgname=$(OMPI_32_PKG_NAME)"                            >  $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OMPI_32_PKG_VERSION)"                          >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "arch=$(OMPI_32_PKG_ARCH)"                               >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(OMPI_32_PKG_DISTRO_NAME)"                  >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(OMPI_32_PKG_DISTRO_VERSION)"                >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "group=$(OMPI_32_PKG_GROUP)"                             >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OMPI_32_PKG_SHORT_DESCRIPTION)\"" >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "url=$(OMPI_32_PKG_URL)"                                 >> $(OMPI_32_PKG)/.PKGINFO ; \
	 echo "license=$(OMPI_32_PKG_LICENSE)"                         >> $(OMPI_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OMPI_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
