
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly and not requires gcc runtime libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../build-system/constants.mk


REQUIRES           = dev/kernel-headers
REQUIRES          += base/pkgtool


install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gcc_rt_pkg   = $(TARGET_BUILD_DIR)/.gcc_rt_pkg_done


version            = $(shell $(CC) -dumpversion)


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GCC_RT_DEV_PKG_NAME                = gcc-runtime
GCC_RT_DEV_PKG_VERSION             = 4.8.2
GCC_RT_DEV_PKG_ARCH                = $(TOOLCHAIN)
GCC_RT_DEV_PKG_DISTRO_NAME         = kxLab
GCC_RT_DEV_PKG_DISTRO_VERSION      = 1.0
GCC_RT_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GCC_RT_DEV_PKG_SHORT_DESCRIPTION   = GCC $(version) runtime libraries
GCC_RT_DEV_PKG_URL                 = http://www.kxLab.com
GCC_RT_DEV_PKG_LICENSE             = GPLv2
GCC_RT_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCC_RT_DEV_PKG_NAME)-pkg-description
GCC_RT_DEV_PKG_DESCRIPTION_FILE_IN = $(GCC_RT_DEV_PKG_NAME)-pkg-description.in
GCC_RT_DEV_PKG_INSTALL_SCRIPT      = $(GCC_RT_DEV_PKG_NAME)-pkg-install.sh

GCC_RT_DEV_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCC_RT_DEV_PKG_NAME)-package

pkg_basename     = $(GCC_RT_DEV_PKG_NAME)-$(GCC_RT_DEV_PKG_VERSION)-$(GCC_RT_DEV_PKG_ARCH)-$(GCC_RT_DEV_PKG_DISTRO_NAME)-$(GCC_RT_DEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GCC_RT_DEV_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gcc_rt_pkg)

#
# Do not install 'gcc-runtime' to the target root filesystem
#
# ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../build-system/core.mk


src_dir      = $(TOOLCHAIN_PATH)/$(TARGET)

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
lib_compat   = yes
else
lib_compat   = no
endif


$(install_target):
	@mkdir -p $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(src_dir)/lib$(LIBSUFFIX) && \
	   if [ "" != "`find -iname 'libasan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libasan*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libatomic*'   -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*   $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libgcc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libgomp*'     -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libitm*'      -exec echo '{}' \; -quit`" ] ; then cp -a libitm*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libmudflap*'  -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*  $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libquadmath*' -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath* $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libssp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libssp*      $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libstdc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libsupc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ "" != "`find -iname 'libtsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*     $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi && \
	   if [ -d ldscripts ] ; then cp -rf ldscripts $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; fi )
	@if test "$(lib_compat)" == "yes" ; then \
	  mkdir  -p $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  ( cd $(src_dir)/lib$(MULTILIB_X86_32_SUFFIX) && \
	    if [ "" != "`find -iname 'libasan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libasan*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libatomic*'   -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*   $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libgcc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libgomp*'     -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libitm*'      -exec echo '{}' \; -quit`" ] ; then cp -a libitm*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libmudflap*'  -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*  $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libquadmath*' -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath* $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libssp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libssp*      $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libstdc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libsupc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libtsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*     $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi ; \
	    if [ -d ldscripts ] ; then cp -rf ldscripts $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; fi ) ; \
	 fi
	@rm -f $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX)/*gdb.py
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	@rm -f $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*gdb.py
endif
	@( cd $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(src_dir)/lib,$(TARGET_DEST_DIR)/usr/lib,g" *.la \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  ( cd $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	    sed -i "s,$(src_dir)/lib,$(TARGET_DEST_DIR)/usr/lib,g" *.la  \
	 ) ; \
	 fi
	# copy lib/gcc
	@mkdir -p $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(TOOLCHAIN_PATH) && \
	   cp -r lib$(LIBSUFFIX)/gcc $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) \
	 )
	# copy libexec/gcc
	@mkdir -p $(GCC_RT_DEV_PKG)/usr/libexec
	@( cd $(TOOLCHAIN_PATH) && \
	   cp -r libexec/gcc $(GCC_RT_DEV_PKG)/usr/libexec \
	 )
	@( cd $(GCC_RT_DEV_PKG)/usr/libexec/gcc/$(TARGET)/$(version) && \
	   sed -i "s,$(TOOLCHAIN_PATH),$(TARGET_DEST_DIR)/usr,g" *.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GCC_RT_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la scripts =======
	@( cd $(GCC_RT_DEV_PKG)/usr/libexec/gcc/$(TARGET)/$(version) && \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la \
	 )
	@( cd $(GCC_RT_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  ( cd $(GCC_RT_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la \
	 ) ; \
	 fi
	@touch $@

$(GCC_RT_DEV_PKG_DESCRIPTION_FILE): $(GCC_RT_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gcc_rt_pkg): $(install_target) $(GCC_RT_DEV_PKG_DESCRIPTION_FILE)
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
	@$(FAKEROOT) sh -c "cd $(GCC_RT_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
