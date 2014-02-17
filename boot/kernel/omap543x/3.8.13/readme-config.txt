
$ cp <kernel_src_dir>/arch/arm/configs/omap2plus_defconfig <kernel_src_dir>/.config
$ cd <kernel_src_dir>/
$ ARCH=arm make menuconfig
$ ARCH=arm make oldconfig
$ cp .config <build_dir>/omap5evm.config

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

see configs/omap5evm.config.net-sched file.
----------------------------------------------------------------

configs/
 |
 +- omap5evm.config.net-sched      - current config file, created for following wl18xx
 |                                   modules installation from TI compat-wireless thee;
 +- omap5evm.config.with-wl18xx    - doesn't work because of wl18xx created for
 |                                   linux >= 3.9 but we have 3.8.13;
 +- omap5evm.config.without-wl18xx - can be used if we do not plan wireless support;
