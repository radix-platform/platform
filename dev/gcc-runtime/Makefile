
COMPONENT_TARGETS += $(TARGET_HOST)
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


ifneq ($(filter $(HARDWARE),$(TARGET_HOST) $(TARGET_PC32) $(TARGET_PC64)),)
REQUIRES           = dev/kernel/x86/3.10.17-headers
endif

ifeq ($(HARDWARE),$(TARGET_CB1X))
REQUIRES           = dev/kernel/a1x/3.0.52-r2-headers
endif

ifeq ($(HARDWARE),$(TARGET_VIP1830))
REQUIRES           = dev/kernel/dm644x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_BEAGLE))
REQUIRES           = dev/kernel/omap35x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_OMAP5UEVM))
REQUIRES           = dev/kernel/omap543x/3.8.y-20140222-headers
endif

ifeq ($(HARDWARE),$(TARGET_B74))
REQUIRES           = dev/kernel/bcm74x/2.6.36-headers
endif


install_target = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS  = $(install_target)


include ../../build-system/core.mk

#
# NOTE:
#   Code for BUILD_TOOLCHAIN_NAME works only on x86_64 systems where
#   native x86_64 libs are placed in /usr/lib64 directory and compat
#   x86_32 libs are placed in /usr/lib system directory.
#

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
src_dir  = /usr/lib
else
src_dir  = $(TOOLCHAIN_PATH)/$(TARGET)/lib
endif

dest_dir = $(TARGET_DEST_DIR)/usr/lib

LIBSUFFIX =

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX = 64
endif
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX = 32
endif

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
lib_compat = yes
else
lib_compat = no
endif


$(install_target):
	@mkdir -p $(dest_dir)
	@( cd $(src_dir) && \
	   if [ "" != "`find -iname 'libasan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libasan*     $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libatomic*'   -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*   $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libgcc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*      $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libgomp*'     -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*     $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libitm*'      -exec echo '{}' \; -quit`" ] ; then cp -a libitm*      $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libmudflap*'  -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*  $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libquadmath*' -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath* $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libssp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libssp*      $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libstdc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*     $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libsupc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*     $(dest_dir) ; fi && \
	   if [ "" != "`find -iname 'libtsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*     $(dest_dir) ; fi && \
	   if [ -d ldscripts ] ; then cp -rf ldscripts $(dest_dir) ; fi )
	@if test "$(lib_compat)" == "yes" ; then \
	  mkdir  -p $(dest_dir)$(LIBSUFFIX) ; \
	  ( cd $(src_dir)$(LIBSUFFIX) && \
	    if [ "" != "`find -iname 'libasan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libasan*     $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libatomic*'   -exec echo '{}' \; -quit`" ] ; then cp -a libatomic*   $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libgcc*'      -exec echo '{}' \; -quit`" ] ; then cp -a libgcc*      $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libgomp*'     -exec echo '{}' \; -quit`" ] ; then cp -a libgomp*     $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libitm*'      -exec echo '{}' \; -quit`" ] ; then cp -a libitm*      $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libmudflap*'  -exec echo '{}' \; -quit`" ] ; then cp -a libmudflap*  $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libquadmath*' -exec echo '{}' \; -quit`" ] ; then cp -a libquadmath* $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libssp*'      -exec echo '{}' \; -quit`" ] ; then cp -a libssp*      $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libstdc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libstdc*     $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libsupc*'     -exec echo '{}' \; -quit`" ] ; then cp -a libsupc*     $(dest_dir)$(LIBSUFFIX) ; fi && \
	    if [ "" != "`find -iname 'libtsan*'     -exec echo '{}' \; -quit`" ] ; then cp -a libtsan*     $(dest_dir)$(LIBSUFFIX) ; fi ; \
	    if [ -d ldscripts ] ; then cp -rf ldscripts $(dest_dir)$(LIBSUFFIX) ; fi ) ; \
	 fi
	@( cd $(dest_dir) ; \
	   if [ -f libasan.la ]          ; then sed -i "s,$(src_dir),$(dest_dir),g" libasan.la ; fi ; \
	   if [ -f libatomic.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libatomic.la ; fi ; \
	   if [ -f libgomp.la ]          ; then sed -i 's,$(src_dir),$(dest_dir),g' libgomp.la ; fi ; \
	   if [ -f libitm.la ]           ; then sed -i 's,$(src_dir),$(dest_dir),g' libitm.la ; fi ; \
	   if [ -f libmudflap.la ]       ; then sed -i 's,$(src_dir),$(dest_dir),g' libmudflap.la ; fi ; \
	   if [ -f libmudflapth.la ]     ; then sed -i 's,$(src_dir),$(dest_dir),g' libmudflapth.la ; fi ; \
	   if [ -f libquadmath.la ]      ; then sed -i 's,$(src_dir),$(dest_dir),g' libquadmath.la ; fi ; \
	   if [ -f libssp.la ]           ; then sed -i 's,$(src_dir),$(dest_dir),g' libssp.la ; fi ; \
	   if [ -f libssp_nonshared.la ] ; then sed -i 's,$(src_dir),$(dest_dir),g' libssp_nonshared.la ; fi ; \
	   if [ -f libstdc++.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libstdc++.la ; fi ; \
	   if [ -f libsupc++.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libsupc++.la ; fi ; \
	   if [ -f libtsan.la ]          ; then sed -i 's,$(src_dir),$(dest_dir),g' libtsan.la ; fi \
	 )
	@if test "$(lib_compat)" == "yes" ; then \
	  ( cd $(dest_dir)$(LIBSUFFIX) ; \
	   if [ -f libasan.la ]          ; then sed -i "s,$(src_dir),$(dest_dir),g" libasan.la ; fi ; \
	   if [ -f libatomic.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libatomic.la ; fi ; \
	   if [ -f libgomp.la ]          ; then sed -i 's,$(src_dir),$(dest_dir),g' libgomp.la ; fi ; \
	   if [ -f libitm.la ]           ; then sed -i 's,$(src_dir),$(dest_dir),g' libitm.la ; fi ; \
	   if [ -f libmudflap.la ]       ; then sed -i 's,$(src_dir),$(dest_dir),g' libmudflap.la ; fi ; \
	   if [ -f libmudflapth.la ]     ; then sed -i 's,$(src_dir),$(dest_dir),g' libmudflapth.la ; fi ; \
	   if [ -f libquadmath.la ]      ; then sed -i 's,$(src_dir),$(dest_dir),g' libquadmath.la ; fi ; \
	   if [ -f libssp.la ]           ; then sed -i 's,$(src_dir),$(dest_dir),g' libssp.la ; fi ; \
	   if [ -f libssp_nonshared.la ] ; then sed -i 's,$(src_dir),$(dest_dir),g' libssp_nonshared.la ; fi ; \
	   if [ -f libstdc++.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libstdc++.la ; fi ; \
	   if [ -f libsupc++.la ]        ; then sed -i 's,$(src_dir),$(dest_dir),g' libsupc++.la ; fi ; \
	   if [ -f libtsan.la ]          ; then sed -i 's,$(src_dir),$(dest_dir),g' libtsan.la ; fi \
	 ) ; \
	 fi
	@touch $@
