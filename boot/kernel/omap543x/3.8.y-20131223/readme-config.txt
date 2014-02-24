
$ cp <kernel_src_dir>/arch/arm/configs/omap2plus_defconfig <kernel_src_dir>/.config
$ cd <kernel_src_dir>/
$ ARCH=arm make menuconfig
$ ARCH=arm make oldconfig
$ cp .config <build_dir>/omap5uevm.config

----------------------------------------------------------------
If we plan to build compat wl18xx outside; then we should set up

  CONFIG_NET_SCHED:
    menuconfig:
      Networking Support -->
        Networking Options -->
          QoS and/or fair queueing [=y] -->    and probably some scheduling options:
            <M> Generic Random Early Detectiom <M> (to produce sch_gred.ko)
            <M> Netfilter mark (FW) (to produce cls_fw.ko)
            <M> Universal 32bit comparisons w/ hashing (U32) (to produce cls_u32.ko)
              [*] Performance counters support
              [*] Netfilter marks support

see configs/omap5uevm.config.net-sched file.
----------------------------------------------------------------

configs/
 |
 +- omap5uevm.config.net-sched        - current config file, created for following wl18xx
 |                                      modules installation from TI compat-wireless thee;
 +- omap5uevm.config.with-wl18xx      - doesn't work because of wl18xx created for
 |                                      linux >= 3.9 but we have 3.8.13;
 +- omap5uevm.config.without-wl18xx   - can be used if we do not plan wireless support;
 |
 +- omap5uevm.config.without-mac80211 - because ti wireless wl18xx will be built outside
                                        we removed Marvel Libertas (incompatible libertas.ko
                                        with TI cfg80211.ko fron wl18xx) and we also removed
                                        cfg80211 & of cource mac80211 because these modules
                                        will be built in hal/3pp/omap/wl18xx/...

----------------------------------------------------------------
Changes for disable Marvel libertas, cfg80211 & mac80211:

  menuconfig:
    Device Drivers -->
      Network Device Support -->
        Wireless LAN -->
          < > Marvel 8xxx Libertas WLAN support.

  menuconfig:
    Networking Support -->
      Wireless -->
        < > cfg80211 - wireless configuration API

see configs/omap5uevm.config.without-mac80211 file.
----------------------------------------------------------------
