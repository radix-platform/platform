
/* begin *

   omap5uevm.config.without-mac80211 - original configuration for omap5uevm board with omap2, omap3 support
                                       (Doesn't work with -mfpu=neon-vfpv4 -mfloat-abi=hard because
                                        omap2, omap3 support assunes the armv6k architecture which
                                        doesn't have the vfpv4 coprocessor. Now we support only omap4, omap5
                                        with special neon-vfpv4 patch);
   omap5uevm.config.vfpv4            - probed kernel for omap 4/5 only (doesn't work now);
   README.TXT                        - this file.

 * end */
