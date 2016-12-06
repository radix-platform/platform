
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


REQUIRES           = base/pkgtool

# ======= __END_OF_REQUIRES__ =======


version            = $(shell $(CC) -dumpversion)

build_gcc_rt_pkg   = $(TARGET_BUILD_DIR)/.gcc_rt_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GCC_RT_DEV_PKG_NAME                = gcc-runtime
GCC_RT_DEV_PKG_VERSION             = 5.3.0
GCC_RT_DEV_PKG_ARCH                = $(TOOLCHAIN)
GCC_RT_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GCC_RT_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GCC_RT_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GCC_RT_DEV_PKG_SHORT_DESCRIPTION   = GNU Compiler Runtime Libraries
GCC_RT_DEV_PKG_URL                 = $(BUG_URL)
GCC_RT_DEV_PKG_LICENSE             = GPLv2
GCC_RT_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCC_RT_DEV_PKG_NAME)-pkg-description
GCC_RT_DEV_PKG_DESCRIPTION_FILE_IN = $(GCC_RT_DEV_PKG_NAME)-pkg-description.in
GCC_RT_DEV_PKG_INSTALL_SCRIPT      = $(GCC_RT_DEV_PKG_NAME)-pkg-install.sh

GCC_RT_DEV_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCC_RT_DEV_PKG_NAME)-package

pkg_basename     = $(GCC_RT_DEV_PKG_NAME)-$(GCC_RT_DEV_PKG_VERSION)-$(GCC_RT_DEV_PKG_ARCH)-$(GCC_RT_DEV_PKG_DISTRO_NAME)-$(GCC_RT_DEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_gcc_rt_pkg)

PRODUCT_TARGETS  = $(products)
#
# Do not install 'gcc-runtime' to the target root filesystem
#
# ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


src_dir      = $(TOOLCHAIN_PATH)/$(TARGET)

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
lib_compat   = yes
else
lib_compat   = no
endif


$(build_gcc_rt_pkg):
	@mkdir -p $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(src_dir)/lib$(LIBSUFFIX) && \
	   if [ "" != "`find -iname 'libgcc*'       -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*       $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libstdc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libasan*'      -exec echo '{}' \; -quit`" ] ; then cp -a libasan*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libatomic*'    -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*    $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libcilkrts*'   -exec echo '{}' \; -quit`" ] ; then cp -a libcilkrts*   $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libgomp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libitm*'       -exec echo '{}' \; -quit`" ] ; then cp -a libitm*       $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libsanitizer*' -exec echo '{}' \; -quit`" ] ; then cp -a libsanitizer* $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'logging*'      -exec echo '{}' \; -quit`" ] ; then cp -a logging*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'liblsan*'      -exec echo '{}' \; -quit`" ] ; then cp -a liblsan*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libmudflap*'   -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*   $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libquadmath*'  -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath*  $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libssp*'       -exec echo '{}' \; -quit`" ] ; then cp -a libssp*       $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libsupc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libtsan*'      -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libubsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libubsan*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libvtv*'       -exec echo '{}' \; -quit`" ] ; then cp -a libvtv*       $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi    \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  mkdir  -p $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  ( cd $(src_dir)/lib$(MULTILIB_X86_32_SUFFIX) && \
	    if [ "" != "`find -iname 'libgcc*'       -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*       $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libstdc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libasan*'      -exec echo '{}' \; -quit`" ] ; then cp -a libasan*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libatomic*'    -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*    $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libcilkrts*'   -exec echo '{}' \; -quit`" ] ; then cp -a libcilkrts*   $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libgomp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libitm*'       -exec echo '{}' \; -quit`" ] ; then cp -a libitm*       $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libsanitizer*' -exec echo '{}' \; -quit`" ] ; then cp -a libsanitizer* $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'logging*'      -exec echo '{}' \; -quit`" ] ; then cp -a logging*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'liblsan*'      -exec echo '{}' \; -quit`" ] ; then cp -a liblsan*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libmudflap*'   -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*   $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libquadmath*'  -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath*  $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libssp*'       -exec echo '{}' \; -quit`" ] ; then cp -a libssp*       $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libsupc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libtsan*'      -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libubsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libubsan*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libvtv*'       -exec echo '{}' \; -quit`" ] ; then cp -a libvtv*       $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi    \
	  ) ; \
	 fi
	@rm -f $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX)/*gdb.py
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
	@rm -f $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*gdb.py
endif
	# ======= tune linker *.la files =======
	@( cd $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(src_dir)/lib,$(TARGET_DEST_DIR)/usr/lib,g" *.la \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  ( cd $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	    sed -i "s,$(src_dir)/lib,$(TARGET_DEST_DIR)/usr/lib,g" *.la  \
	 ) ; \
	 fi
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GCC_RT_DEV_PKG))
	# ======= tune target libtool *.la scripts =======
	@( cd $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la ; \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  ( cd $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	    sed -i "s,$(TARGET_DEST_DIR),,g" *.la ; \
	  ) ; \
	 fi
	# ======= Strip binaries =======
	@( cd $(GCC_RT_DEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(GCC_RT_DEV_PKG_DESCRIPTION_FILE): $(GCC_RT_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_gcc_rt_pkg) $(GCC_RT_DEV_PKG_DESCRIPTION_FILE) $(GCC_RT_DEV_PKG_INSTALL_SCRIPT)
	@cp $(GCC_RT_DEV_PKG_DESCRIPTION_FILE) $(GCC_RT_DEV_PKG)/.DESCRIPTION
	@cp $(GCC_RT_DEV_PKG_INSTALL_SCRIPT) $(GCC_RT_DEV_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(GCC_RT_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(GCC_RT_DEV_PKG_NAME)"                            >  $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GCC_RT_DEV_PKG_VERSION)"                          >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(GCC_RT_DEV_PKG_ARCH)"                               >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(GCC_RT_DEV_PKG_DISTRO_NAME)"                  >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(GCC_RT_DEV_PKG_DISTRO_VERSION)"                >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(GCC_RT_DEV_PKG_GROUP)"                             >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GCC_RT_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(GCC_RT_DEV_PKG_URL)"                                 >> $(GCC_RT_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(GCC_RT_DEV_PKG_LICENSE)"                         >> $(GCC_RT_DEV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GCC_RT_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
