
http://linux-sunxi.org/Mainline_U-boot#Boot

Add following to the 'configs/Cubietruck_defconfig' to check slow memory

+S:CONFIG_DRAM_CLK=360
+S:CONFIG_DRAM_ZQ=123
+S:CONFIG_DRAM_EMR1=4
+S:CONFIG_DRAM_TIMINGS_DDR3_800E_1066G_1333J=y
