
# include once
ifndef CORE_MK

#######
####### Set up TOP_BUILD_DIR, TOP_BUILD_DIR_ABS and BUILDSYSTEM variables
#######

ifndef MAKEFILE_LIST

# Work-around for GNU make pre-3.80, which lacks MAKEFILE_LIST and $(eval ...)

TOP_BUILD_DIR := $(shell perl -e 'for ($$_ = "$(CURDIR)"; ! -d "$$_/build-system"; s!(.*)/(.*)!\1!) { $$q .= "../"; } chop $$q; print "$$q"')
ifeq ($(TOP_BUILD_DIR),)
TOP_BUILD_DIR=.
endif
export TOP_BUILD_DIR_ABS := $(shell perl -e 'for ($$_ = "$(CURDIR)"; ! -d "$$_/build-system"; s!(.*)/(.*)!\1!) { } print')
export BUILDSYSTEM := $(TOP_BUILD_DIR_ABS)/build-system

else

# Normal operation for GNU make 3.80 and above

__pop = $(patsubst %/,%,$(dir $(1)))
__tmp := $(call __pop,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
# Special case for build-system/Makefile
ifeq ($(__tmp),.)
__tmp := ../$(notdir $(CURDIR))
endif

ifndef TOP_BUILD_DIR
TOP_BUILD_DIR := $(call __pop,$(__tmp))
endif

ifndef TOP_BUILD_DIR_ABS
TOP_BUILD_DIR_ABS := $(CURDIR)
ifneq ($(TOP_BUILD_DIR),.)
$(foreach ,$(subst /, ,$(TOP_BUILD_DIR)),$(eval TOP_BUILD_DIR_ABS := $(call __pop,$(TOP_BUILD_DIR_ABS))))
endif
export TOP_BUILD_DIR_ABS
endif

ifndef BUILDSYSTEM
export BUILDSYSTEM := $(TOP_BUILD_DIR_ABS)/$(notdir $(__tmp))
endif

endif

#######
####### Set up SOURCE PACKAGE directory:
#######

export SRC_PACKAGE_DIR       := sources
export SRC_PACKAGE_PATH      := $(TOP_BUILD_DIR)/$(SRC_PACKAGE_DIR)
export SRC_PACKAGE_PATH_ABS  := $(TOP_BUILD_DIR_ABS)/$(SRC_PACKAGE_DIR)



#######
####### Set up targets etc
#######

ifdef TARGETS_MK
$(error Error: 'targets.mk' should not be included directly, include 'constants.mk' instead.)
endif

include $(BUILDSYSTEM)/targets.mk


#######
####### Silent make:
#######

ifeq ($(VERBOSE),)
ifeq ($(COMPONENT_IS_3PP),)
MAKEFLAGS += -s
endif
endif

ifeq ($(VERBOSE),)
guiet = @
else
quiet =
endif


#######
####### Parallel control:
#######

ifneq ($(NO_PARALLEL),)
MAKEFLAGS += -j1
.NOTPARALLEL:
endif



#######
####### Cleanup files:
#######

CLEANUP_FILES +=  $(addprefix ., $(TOOLCHAIN_NAMES))

CLEANUP_FILES +=  $(addsuffix /$(HARDWARE), $(addprefix ., $(TOOLCHAIN)))
CLEANUP_FILES +=  $(SRC_DIR)
CLEANUP_FILES +=  $(SRC_DIR).back.??????
CLEANUP_FILES +=  .*_requires*



#######
####### Build rules:
#######

all:
	@$(MAKE) BUILD_TREE=true local_all

clean:
	@$(MAKE) CLEAN_TREE=true FLAVOUR=dummy local_clean

dist_clean:
	@$(MAKE) CLEAN_TREE=true FLAVOUR=dummy local_dist_clean

rootfs_clean:
	@$(MAKE) CLEAN_TREE=false FLAVOUR=dummy local_rootfs_clean


ifeq ($(filter %_clean,$(MAKECMDGOALS)),)

__setup_targets = .src_requires_done $(SETUP_TARGETS)

#########################################
# -----------+----------+---------+-----
#  TOOLCHAIN | HARDWARE | FLAVOUR | REF
# -----------+----------+---------+-----
#    defined |  defined | defined | (1)
#    defined |  defined |    ~    | (2)
#    defined |     ~    | defined | (3)
#    defined |     ~    |    ~    | (4)
#       ~    |  defined | defined | (5)
#       ~    |  defined |    ~    | (6)
#       ~    |     ~    | defined | (7)
#       ~    |     ~    |    ~    | (8)
# -----------+----------+---------+-----
#########################################
ifeq ($(TOOLCHAIN),)
ifeq ($(HARDWARE),)
ifeq ($(FLAVOUR),)
# (8)
__targets = $(foreach arch,                                                                 \
                $(shell echo $(COMPONENT_TOOLCHAINS) | sed -e 's/x86_64/x86-64/g'),         \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    $(foreach hardware,                                                     \
                        $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),  \
                        $(if $($(shell echo ${hardware} | tr '[a-z]' '[A-Z]')_FLAVOURS),    \
                            $(foreach flavour,                                              \
                                $($(shell echo ${hardware} | tr '[a-z]' '[A-Z]')_FLAVOURS), \
                                .target_$(arch)_$(hardware)_$(flavour)                      \
                             ),                                                             \
                             $(if $(FLAVOURS),                                              \
                                 $(foreach flavour,                                         \
                                     $(FLAVOURS),                                           \
                                     .target_$(arch)_$(hardware)_$(flavour)                 \
                                  ),.target_$(arch)_$(hardware)                             \
                              )                                                             \
                         )                                                                  \
                     ),                                                                     \
                     $(if $(FLAVOURS),                                                      \
                         $(foreach flavour,                                                 \
                             $(FLAVOURS),                                                   \
                             .target_$(arch)_$(flavour)                                     \
                          ),.target_$(arch)                                                 \
                      )                                                                     \
                 )                                                                          \
             )
else
# (7)
__targets = $(foreach arch,                                                                 \
                $(shell echo $(COMPONENT_TOOLCHAINS) | sed -e 's/x86_64/x86-64/g'),         \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    $(foreach hardware,                                                     \
                        $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),  \
                        $(if $($(shell echo ${hardware} | tr '[a-z]' '[A-Z]')_FLAVOURS),    \
                                .target_$(arch)_$(hardware)_$(FLAVOUR),                     \
                             $(if $(FLAVOURS),                                              \
                                .target_$(arch)_$(hardware)_$(FLAVOUR),                     \
                                .target_$(arch)_$(hardware)                                 \
                              )                                                             \
                         )                                                                  \
                     ),                                                                     \
                     $(if $(FLAVOURS),                                                      \
                        .target_$(arch)_$(FLAVOUR),                                         \
                        .target_$(arch)                                                     \
                      )                                                                     \
                 )                                                                          \
             )
endif
else
ifeq ($(FLAVOUR),)
# (6)
__targets = $(foreach arch,                                                                 \
                $(shell echo $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_TOOLCHAIN) | sed -e 's/x86_64/x86-64/g'), \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    $(if $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS),        \
                         $(foreach flavour,                                                 \
                             $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS),    \
                             .target_$(arch)_$(HARDWARE)_$(flavour)                         \
                          ),                                                                \
                          $(if $(FLAVOURS),                                                 \
                              $(foreach flavour,                                            \
                                  $(FLAVOURS),                                              \
                                  .target_$(arch)_$(HARDWARE)_$(flavour)                    \
                               ),.target_$(arch)_$(HARDWARE)                                \
                           )                                                                \
                     ),                                                                     \
                     $(if $(FLAVOURS),                                                      \
                         $(foreach flavour,                                                 \
                             $(FLAVOURS),                                                   \
                             .target_$(arch)_$(flavour)                                     \
                          ),.target_$(arch)                                                 \
                      )                                                                     \
                 )                                                                          \
             )
else
# (5)
__targets = $(foreach arch,                                                                 \
                $(shell echo $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_TOOLCHAIN) | sed -e 's/x86_64/x86-64/g'), \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    .target_$(arch)_$(HARDWARE)_$(FLAVOUR),                                 \
                    .target_$(arch)_$(FLAVOUR)                                              \
                 )                                                                          \
             )
endif
endif
else
ifeq ($(HARDWARE),)
ifeq ($(FLAVOUR),)
# (4)
__targets = $(if $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),    \
                $(foreach hardware,                                                         \
                    $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS), \
                    $(if $($(shell echo ${hardware} | tr '[a-z]' '[A-Z]')_FLAVOURS),        \
                        $(foreach flavour,                                                  \
                            $($(shell echo ${hardware} | tr '[a-z]' '[A-Z]')_FLAVOURS),     \
                            .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(hardware)_$(flavour)      \
                         ),                                                                 \
                         $(if $(FLAVOURS),                                                  \
                             $(foreach flavour,                                             \
                                 $(FLAVOURS),                                               \
                                 .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(hardware)_$(flavour) \
                              ),.target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(hardware)             \
                          )                                                                 \
                     )                                                                      \
                 ),                                                                         \
                 $(if $(FLAVOURS),                                                          \
                     $(foreach flavour,                                                     \
                         $(FLAVOURS),                                                       \
                         .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(flavour) \
                      ),.target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')     \
                  )                                                                         \
             )
else
# (3)
__targets = $(if $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),    \
                $(foreach hardware,                                                         \
                    $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS), \
                    .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(hardware)_$(FLAVOUR) \
                 ),                                                                         \
                 .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(FLAVOUR) \
             )
endif
else
ifeq ($(FLAVOUR),)
# (2)
__targets = $(if $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),    \
                $(if $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS),            \
                    $(foreach flavour,                                                      \
                        $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS),         \
                        .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(HARDWARE)_$(flavour)      \
                     ),                                                                     \
                     $(if $(FLAVOURS),                                                      \
                         $(foreach flavour,                                                 \
                             $(FLAVOURS),                                                   \
                             .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(HARDWARE)_$(flavour) \
                          ),.target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(HARDWARE)             \
                      )                                                                     \
                 ),                                                                         \
                 $(if $(FLAVOURS),                                                          \
                     $(foreach flavour,                                                     \
                         $(FLAVOURS),                                                       \
                         .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(flavour) \
                      ),.target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')                                                \
                  )                                                                         \
             )

else
# (1) DO:
__illegal_toolchain = $(if $(filter $(TOOLCHAIN),$(TOOLCHAIN_NAMES)),false,true)

__illegal_hardware = $(if $(filter $(HARDWARE),$(TARGET_ALL)),false,true)

__illegal_flavour = true
ifneq ($($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS),)
__illegal_flavour = $(if $(filter $(FLAVOUR),$($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_FLAVOURS)),false,true)
else
ifneq ($(FLAVOURS),)
__illegal_flavour = $(if $(filter $(FLAVOUR),$(FLAVOURS)),false,true)
endif
endif


endif
endif
endif


# ifeq ($(filter %_clean,$(MAKECMDGOALS)),)
else


#########################################
# -----------+----------+---------+-----
#  TOOLCHAIN | HARDWARE | FLAVOUR | REF
# -----------+----------+---------+-----
#    defined |  defined |  dummy  | (1)
#    defined |     ~    |  dummy  | (2)
#       ~    |  defined |  dummy  | (3)
#       ~    |     ~    |  dummy  | (4)
# -----------+----------+---------+-----
#########################################
ifeq ($(TOOLCHAIN),)
ifeq ($(HARDWARE),)
# (4)
__targets = $(foreach arch,                                                                 \
                $(shell echo $(COMPONENT_TOOLCHAINS) | sed -e 's/x86_64/x86-64/g'),         \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    $(foreach hardware,                                                     \
                        $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),  \
                        .target_$(arch)_$(hardware)_dummy),                                 \
                    .target_$(arch)_dummy                                                   \
                 )                                                                          \
             )
else
# (3)
__targets = $(foreach arch,                                                                 \
                $(shell echo $($(shell echo $(HARDWARE) | tr '[a-z]' '[A-Z]')_TOOLCHAIN) | sed -e 's/x86_64/x86-64/g'), \
                $(if $($(shell echo ${arch} | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),     \
                    .target_$(arch)_$(HARDWARE)_dummy,                                      \
                    .target_$(arch)_dummy                                                   \
                 )                                                                          \
             )
endif
else
ifeq ($(HARDWARE),)
# (2)
__targets = $(if $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS),    \
                $(foreach hardware,                                                         \
                    $($(shell echo $(TOOLCHAIN) | tr '[a-z-]' '[A-Z_]')_HARDWARE_VARIANTS), \
                    .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_$(hardware)_dummy \
                 ),                                                                         \
                 .target_$(shell echo $(TOOLCHAIN) | sed -e 's/x86_64/x86-64/g')_dummy      \
             )
else
# (1) DO:
__illegal_toolchain = $(if $(filter $(TOOLCHAIN),$(TOOLCHAIN_NAMES)),false,true)

__illegal_hardware = $(if $(filter $(HARDWARE),$(TARGET_ALL)),false,true)

endif
endif

# ifeq ($(filter %_clean,$(MAKECMDGOALS)),)
endif


ifneq ($(__targets),)

# List of toolchains (without 'setup'):
__toolchains = $(sort $(foreach arch, \
                                $(__targets), \
                                $(shell echo $(word 2, $(subst _, , $(arch))) | sed -e 's/x86-64/x86_64/g')))

__hw_variants = $(sort $(foreach hw, \
                                $(__targets), \
                                $(if $(filter $(shell echo $(word 3, $(subst _, , $(hw)))),$(TARGET_ALL)), \
                                   $(word 3, $(subst _, , $(hw))))))

$(__targets): $(addprefix .target_setup_,$(__hw_variants))

local_all: $(__targets)

#
# Latest operations:
# 1. create .$(HARDWARE).dist
# 2. remove .$(HARDWARE)_requires* files too
#
local_all: $(__targets)
	@for hw in $(__hw_variants) ; do \
	  if [ "$$(echo .$$hw.dist*)" != ".$$hw.dist*" ]; then \
	    sort -o .$$hw.dist.tmp -u .$$hw.dist* && mv .$$hw.dist.tmp .$$hw.dist; \
	  fi ; \
	  rm -f .$$hw.dist.* ; \
	  rm -f .$${hw}_requires* ; \
	  rm -f .src_requires* ; \
	done

local_clean: $(__targets)

local_dist_clean: $(__targets)

local_rootfs_clean: $(__targets)


.target_%: _TOOLCHAIN = $(shell echo $(word 2, $(subst _, , $@)) | sed -e 's/x86-64/x86_64/g')
.target_%: _HARDWARE = $(if $(filter $(shell echo $(word 3, $(subst _, , $@))),$(TARGET_ALL)),$(word 3, $(subst _, , $@)))
.target_%: _FLAVOUR = $(if $(word 4, $(subst _, , $@)),$(word 4, $(subst _, , $@)),$(if $(filter $(shell echo $(word 3, $(subst _, , $@))),$(TARGET_ALL)),,$(word 3, $(subst _, , $@))))
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
.target_%: .makefile
else
.target_%:
endif
	@if [ "$(_TOOLCHAIN)" = "setup" ]; then \
	  $(MAKE) TOOLCHAIN=$(_TOOLCHAIN) HARDWARE=$(_HARDWARE) FLAVOUR=dummy $(MAKECMDGOALS) ; \
	elif [ "$(_FLAVOUR)" = "" -o "$(_FLAVOUR)" = "dummy" ]; then \
	  $(MAKE) TOOLCHAIN=$(_TOOLCHAIN) HARDWARE=$(_HARDWARE) FLAVOUR=dummy $(MAKECMDGOALS) ; \
	else \
	  $(MAKE) TOOLCHAIN=$(_TOOLCHAIN) HARDWARE=$(_HARDWARE) FLAVOUR=$(_FLAVOUR) $(MAKECMDGOALS) ; \
	fi


else

################################################################
# Target is selected, build it
#

.target:
	@echo ""
	@echo "======="
	@echo "======= TOOLCHAIN: $(TOOLCHAIN); HARDWARE = $(HARDWARE); FLAVOUR =$(if $(FLAVOUR), $(FLAVOUR));  ======="
	@echo "======="
ifeq ($(__illegal_flavour),true)
ifneq ($(FLAVOUR),dummy)
	@echo "======= Error: Illegal FLAVOUR: '$(FLAVOUR)'!"
	@echo "======="
	@false
endif
endif
ifeq ($(__illegal_toolchain),true)
	@echo "======= Error: Illegal TOOLCHAIN: '$(TOOLCHAIN)'!"
	@echo "======="
	@false
endif
ifeq ($(__illegal_hardware),true)
	@echo "======= Error: Illegal HARDWARE: '$(HARDWARE)'!"
	@echo "======="
	@false
endif


ifneq ($(NO_CREATE_DIST_FILES),true)
local_all: CREATE_DIST_FILES = 1
endif

ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
ifneq ($(findstring $(TOOLCHAIN),$(TOOLCHAIN_NAMES)),)

ifeq ($(filter %_clean,$(MAKECMDGOALS)),)

ifeq ($(FLAVOUR),dummy)
$(shell mkdir -p .$(TOOLCHAIN)/$(HARDWARE))
else
ifneq ($(__illegal_flavour),true)
$(shell mkdir -p .$(TOOLCHAIN)/$(HARDWARE)$(if $(FLAVOUR),/$(FLAVOUR)))
else
$(shell mkdir -p .$(TOOLCHAIN)/$(HARDWARE))
endif
endif

# ifeq ($(filter %_clean,$(MAKECMDGOALS)),)
endif

endif
endif

# TOOLCHAIN/FLAVOUR depended directories

ifeq ($(FLAVOUR),dummy)
targetflavour = .$(TOOLCHAIN)/$(HARDWARE)
else
ifneq ($(__illegal_flavour),true)
targetflavour = .$(TOOLCHAIN)/$(HARDWARE)$(if $(FLAVOUR),/$(FLAVOUR))
else
targetflavour = .$(TOOLCHAIN)/$(HARDWARE)
endif
endif
TARGET_BUILD_DIR = $(targetflavour)


ifeq ($(TOOLCHAIN),setup)

local_all: .setup

.setup: $(__setup_targets)

else

ifeq ($(filter %_clean,$(MAKECMDGOALS)),)

ifeq ($(MAKELEVEL),1)
#
# NOTE:
#   If TOOLCHAIN, HARDWARE, and FLAVOUR are defined by command line then
#   we should use this target for setup operations because in this case
#   the section ifneq ($(__targets),) ... endif of current Makefile
#   doesn't work. 
#
local_all: .setup

.setup: $(__setup_targets)

.PHONY: .setup
endif


ifeq ($(BUILD_TREE),true)
local_all: .target .$(HARDWARE)_requires_done
else
local_all: .target
endif

local_all: install

ifeq ($(MAKELEVEL),1)
#
# NOTE:
#   If TOOLCHAIN, HARDWARE, and FLAVOUR are defined by command line then
#   we should use this target for latest operations because in this case
#   the section ifneq ($(__targets),) ... endif of current Makefile
#   doesn't work. 
#
# DOUBLE of Latest operations:
# 1. create .$(HARDWARE).dist
# 2. remove .$(HARDWARE)_requires* files too
#
local_all: .latest

.latest:
	@for hw in $(HARDWARE) ; do \
	  if [ "$$(echo .$$hw.dist*)" != ".$$hw.dist*" ]; then \
	    sort -o .$$hw.dist.tmp -u .$$hw.dist* && mv .$$hw.dist.tmp .$$hw.dist; \
	  fi ; \
	  rm -f .$$hw.dist.* ; \
	  rm -f .$${hw}_requires* ; \
	  rm -f .src_requires* ; \
	done

.PHONY: .latest
endif


# ifeq ($(filter %_clean,$(MAKECMDGOALS)),)
else

ifeq ($(CLEAN_TREE),true)
local_clean: .target .local_clean .$(HARDWARE)_clean_done
else
local_clean: .target .local_clean
endif

ifeq ($(CLEAN_TREE),true)
local_dist_clean: .target .local_dist_clean .$(HARDWARE)_dist_clean_done
else
local_dist_clean: .target .local_dist_clean
endif

local_rootfs_clean: .target .local_rootfs_clean


# ifeq ($(filter %_clean,$(MAKECMDGOALS)),)
endif

# ifeq ($(TOOLCHAIN),setup)
endif

#
################################################################

# ifeq ($(TOOLCHAIN),)
endif



#######
####### Install:
#######

install: .install


.install: .install_scripts .install_builds .install_bins .install_pkgs .install_products

.install_%: DO_CREATE_DIST_FILES = $(CREATE_DIST_FILES)
export DO_CREATE_DIST_FILES


.install_scripts: $(SCRIPT_TARGETS)
ifdef SCRIPT_TARGETS
	@$(BUILDSYSTEM)/install_targets $^ $(TARGET_DEST_DIR)/bin $(HARDWARE)
endif

.install_builds: $(BUILD_TARGETS)
ifdef BUILD_TARGETS
# Do nothing
endif

.install_bins: $(BIN_TARGETS)
ifdef BIN_TARGETS
	@$(BUILDSYSTEM)/install_targets $^ $(TARGET_DEST_DIR)/bin $(HARDWARE)
endif

.install_pkgs: $(ROOTFS_TARGETS)
ifdef ROOTFS_TARGETS
	@INSTALL_PACKAGE="$(INSTALL_PACKAGE)" $(BUILDSYSTEM)/install_pkgs $^ $(ROOTFS_DEST_DIR) $(HARDWARE)
endif

.install_products: $(PRODUCT_TARGETS)
ifdef PRODUCT_TARGETS
	@$(BUILDSYSTEM)/install_targets $^ $(PRODUCTS_DEST_DIR) $(HARDWARE)
endif



# Check if Makefile has been changed:

__quick_targets := help local_clean build-config.mk $(HACK_TARGETS)

.makefile: Makefile
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
ifneq ($(if $(MAKECMDGOALS),$(filter-out $(__quick_targets),$(MAKECMDGOALS)),true),)
	@echo -e "\n======= New makefile ($(<F)), clean! ======="
	@touch $@
	@$(MAKE) local_dist_clean
	@if $(MAKE) local_clean; then true; else rm -f $@; fi
endif
endif


#######
####### Tree Build:
#######

.src_requires_done: .src_requires
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@if [ ! -s .src_requires ]; then \
	  echo -e "======= ... Nothing to be done (there are no source requires) ..." ; \
	fi
	@echo "======="
	@echo "======= End of building source requires for `pwd`."
	@echo "======="
	@touch $@
endif

.src_requires: Makefile
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@rm -f .src_requires
	@touch .src_requires
	@for part in $(SOURCE_REQUIRES) ; do \
	  echo $$part >> .src_requires ; \
	done
	@echo "======="
	@echo "======= Start of building source requires for: `pwd`:"
	@echo "=======" ; \
	export FLAVOUR= ; \
	$(foreach part,$(SOURCE_REQUIRES),\
	  $(MAKE) -C $(TOP_BUILD_DIR)/$(part) TOOLCHAIN=$(BUILD_TOOLCHAIN_NAME) HARDWARE=$(TARGET_HOST) FLAVOUR= local_all &&) true
endif


.$(HARDWARE)_requires_done: .$(HARDWARE)_requires
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@if [ ! -s .$(HARDWARE)_requires ]; then \
	  echo -e "======= ... Nothing to be done (there are no requires) ..." ; \
	fi
	@echo "======="
	@echo "======= End of building requires for `pwd`."
	@echo "======="
	@touch $@
endif

.$(HARDWARE)_requires: Makefile
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@rm -f .$(HARDWARE)_requires
	@touch .$(HARDWARE)_requires
	@for part in $(REQUIRES) ; do \
	  echo $$part >> .$(HARDWARE)_requires ; \
	done
	@echo "======="
	@echo "======= Start of building requires for: `pwd`:"
	@echo "=======" ; \
	export FLAVOUR= ; \
	$(foreach part,$(REQUIRES),\
	  $(MAKE) -C $(TOP_BUILD_DIR)/$(part) TOOLCHAIN=$(TOOLCHAIN) HARDWARE=$(HARDWARE) FLAVOUR= all &&) true
endif


.$(HARDWARE)_clean_done: .$(HARDWARE)_clean
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@if [ ! -s .$(HARDWARE)_clean ]; then \
	  echo -e "======= ... Nothing to be done (there are no requires) ..." ; \
	fi
	@echo "======="
	@echo "======= End of cleaning requires for `pwd`."
	@echo "======="
	@touch $@
endif

.$(HARDWARE)_clean: Makefile
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@rm -f .$(HARDWARE)_clean
	@touch .$(HARDWARE)_clean
	@for part in $(REQUIRES) ; do \
	  echo $$part >> .$(HARDWARE)_clean ; \
	done
	@echo "======="
	@echo "======= Start of cleaning requires for: `pwd`:"
	@echo "=======" ; \
	$(foreach part,$(REQUIRES),\
	  $(MAKE) -C $(TOP_BUILD_DIR)/$(part) TOOLCHAIN=$(TOOLCHAIN) HARDWARE=$(HARDWARE) FLAVOUR= clean &&) true
endif


.$(HARDWARE)_dist_clean_done: .$(HARDWARE)_dist_clean
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@if [ ! -s .$(HARDWARE)_dist_clean ]; then \
	  echo -e "======= ... Nothing to be done (there are no requires) ..." ; \
	fi
	@echo "======="
	@echo "======= End of dist_cleaning requires for `pwd`."
	@echo "======="
	@touch $@
endif

.$(HARDWARE)_dist_clean: Makefile
ifneq ($(shell pwd),$(TOP_BUILD_DIR_ABS))
	@rm -f .$(HARDWARE)_dist_clean
	@touch .$(HARDWARE)_dist_clean
	@for part in $(REQUIRES) ; do \
	  echo $$part >> .$(HARDWARE)_dist_clean ; \
	done
	@echo "======="
	@echo "======= Start of dist_cleaning requires for: `pwd`:"
	@echo "=======" ; \
	$(foreach part,$(REQUIRES),\
	  $(MAKE) -C $(TOP_BUILD_DIR)/$(part) TOOLCHAIN=$(TOOLCHAIN) HARDWARE=$(HARDWARE) FLAVOUR= dist_clean &&) true
endif


#######
####### Clean up default rules:
#######

local_rootfs_clean:
ifneq ($(TOOLCHAIN),setup)
ifneq ($(TOOLCHAIN),)
	@if [ -f .$(HARDWARE).rootfs ]; then \
	  REMOVE_PACKAGE="$(REMOVE_PACKAGE)" $(BUILDSYSTEM)/rootfs_clean $(DEST_DIR) $(HARDWARE) ; \
	else \
	  echo -e "======= ... Nothing to be done (there are no installed packages)." ; \
	fi
	@rm -rf .$(HARDWARE).rootfs
endif
endif

.local_rootfs_clean:
	@echo "======= Remove packages from 'dist/rootfs/$(TOOLCHAIN)/$(HARDWARE)/...' file system..."


local_dist_clean:
	@if [ -f .$(HARDWARE).dist ] ; then \
	  $(BUILDSYSTEM)/dist_clean $(DEST_DIR) $(HARDWARE); \
	  rm .$(HARDWARE).dist; \
	fi
	@rm -rf .$(HARDWARE)_dist*

.local_dist_clean:
	@echo "Destination cleaning..."


local_clean:
	@rm -rf $(CLEANUP_FILES)
	@rm -rf .$(HARDWARE)_clean*
	@if [ "$(filter-out .setup,$(addprefix ., $(TOOLCHAIN)))" ]; then \
	  rmdir $(filter-out .setup,$(addprefix ., $(TOOLCHAIN))) > /dev/null 2>&1 || true ; \
	fi

.local_clean:
	@echo "Cleaning..."


global_clean: .global_clean

.global_clean:
	@echo "Full Tree Clean..."
	@$(BUILDSYSTEM)/global_clean $(addprefix ., $(TOOLCHAIN_NAMES)) $(TOP_BUILD_DIR_ABS)


downloads_clean: .downloads_clean

.downloads_clean:
	@echo "Full Downloads Clean..."
	@$(BUILDSYSTEM)/downloads_clean $(addprefix ., $(BUILD_TOOLCHAIN_NAME)) $(TOP_BUILD_DIR_ABS)/sources




### Declare some targets as phony

.PHONY: .target*
.PHONY: all local_all clean local_clean dist_clean local_dist_clean rootfs_clean local_rootfs_clean
.PHONY: .install

.SUFFIXES:


#######
####### Generic rules
#######

# link rule, used to build binaries
# $(target): $(objs)
# 	$(LINK)
#

LINKER = $(if $(filter .cpp,$(suffix $(SRCS))),$(CXX_LINKER),$(CC_LINKER))

ifeq ($(COMPONENT_IS_3PP),)
LINKMAP = -Wl,-Map,$@.linkmap
endif

BASIC_LDOPTS  = $(LDFLAGS) $(LINKMAP)
BASIC_LDOPTS += -o $@ $(filter %.o,$^)


define cmdheader
  @echo -e "\n======= $(1) ======="
  $(2)
  @echo -e ""
endef


LINK = $(call cmdheader,"Linking $@",$(LINKER) $(BASIC_LDOPTS))

# LINK_C overrides the automatic linker selection provided with LINK
# and always  uses gcc. Useful when building both C and C++ targets
# in the same component:
LINK_C = $(call cmdheader,"Linking $@",$(CC) $(BASIC_LDOPTS))

LINK_SO = $(call cmdheader,"Linking $@", $(LINKER) $(BASIC_LDOPTS) -shared)

LINK_A = $(call cmdheader,"Building $@",$(AR) cru $@ $^)


#######
####### Source dependency
#######

flatfile = $(subst /,_,$(subst ./,,$(1)))
DEPFILE = $(patsubst %.o,%.d,$(if $(findstring $(TOOLCHAIN),$@),$(TARGET_BUILD_DIR)/$(call flatfile,$(subst $(TARGET_BUILD_DIR)/,,$@)),$(call flatfile,$@)))
DEPSETUP = -MD -MP -MF $(DEPFILE) -MT $@

####### .cpp -> .o
%.o: %.cpp
	@echo -e "\n======= $< -> $@ ======="
	$(quiet)$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $(DEPSETUP) $<

$(TARGET_BUILD_DIR)/%.o: %.cpp
	@echo -e "\n======= $< -> $@ ======="
	@mkdir -p $(dir $@)
	$(quiet)$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $(DEPSETUP) $<

####### .c -> .o
%.o: %.c
	@echo -e "\n======= $< -> $@ ======="
	$(quiet)$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $(DEPSETUP) $<

$(TARGET_BUILD_DIR)/%.o: %.c
	@echo -e "\n======= $< -> $@ ======="
	@mkdir -p $(dir $@)
	$(quiet)$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $(DEPSETUP) $<



#######
####### Source archive and patch handling
#######

# Patch dependency:
PATCHES_DEP = $(foreach patch,$(PATCHES),\
	$(shell $(BUILDSYSTEM)/apply_patches $(patch) -dep-))

SRC_DIR_BASE = $(dir $(SRC_DIR))

# Unpack SRC_ARCHIVE in SRC_DIR and backup old SRC_DIR:
UNPACK_SRC_ARCHIVE = \
	@echo "Expanding $(SRC_ARCHIVE)"; \
	if [ -d $(SRC_DIR) ]; then mv $(SRC_DIR) $$(mktemp -d $(SRC_DIR).bak.XXXXXX); fi; \
	mkdir -p $(SRC_DIR_BASE); \
	$(if $(findstring .rpm,$(SRC_ARCHIVE)), \
	  cd $(SRC_DIR_BASE) && rpm2cpio $(SRC_ARCHIVE) | cpio -id --quiet, \
	  $(if $(findstring .zip,$(SRC_ARCHIVE)), \
	    unzip -q -d $(SRC_DIR_BASE) $(SRC_ARCHIVE), \
	    tar $(if $(findstring .bz2,$(SRC_ARCHIVE)),-xjf,-xzf) \
	      $(SRC_ARCHIVE) -C $(SRC_DIR_BASE))); \
	chmod -R u+w $(SRC_DIR)

# Apply patches in PATCHES on SRC_DIR_BASE:
APPLY_PATCHES = $(quiet)$(foreach patch,$(PATCHES),\
	$(BUILDSYSTEM)/apply_patches $(patch) $(SRC_DIR_BASE) &&) true

################################################################
#
# Example rule:
#
# src_done = $(SRC_DIR)/.source-done
#
# $(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
# 	$(UNPACK_SRC_ARCHIVE)
# 	$(APPLY_PATCHES)
# 	 <other stuff that needs to be done to the source,
# 	   should be empty in most cases>
# 	@touch $@
#
################################################################



#######
####### Build system triplet:
#######

ifeq ($(shell echo $(shell ${BUILDSYSTEM}/canonical-build 2> /dev/null)),)
BUILD = unknown-unknown-unknown-unknown
$(error Errorr: Unknown BUILD System '${BUILD}')
else
BUILD = $(shell echo $(shell ${BUILDSYSTEM}/canonical-build 2> /dev/null))
endif



#######
####### Include dependencies if they exist
#######

-include .makefile
-include $(targetflavour)/*.d

#######
####### Include files with references to BUILD-SYSTEM scripts:
#######

-include $(BUILDSYSTEM)/pkgtool/.config
-include $(BUILDSYSTEM)/progs/.config
-include $(BUILDSYSTEM)/scripts/.config
-include $(BUILDSYSTEM)/sbin/.config

#######
####### And hand made references to BUILD-SYSTEM scripts:
#######
    BUILD_PKG_REQUIRES = $(BUILDSYSTEM)/build_pkg_requires $(REQUIRES)
BUILD_ALL_PKG_REQUIRES = $(BUILDSYSTEM)/build_pkg_requires --pkg-type=all $(REQUIRES)
BUILD_BIN_PKG_REQUIRES = $(BUILDSYSTEM)/build_pkg_requires --pkg-type=bin $(REQUIRES)
BUILD_DEV_PKG_REQUIRES = $(BUILDSYSTEM)/build_pkg_requires --pkg-type=dev $(REQUIRES)


CORE_MK = 1
endif
