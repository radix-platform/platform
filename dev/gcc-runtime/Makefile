
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



install_target = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS = $(install_target)


include ../../build-system/core.mk


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
	@touch $@
