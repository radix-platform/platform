
dhcpcd.conf: Don't invoke wpa_supplicant by default:
---------------------------------------------------
  From d968ff96e1e4354c591e49fe79b4f4ce0e553f61 Mon Sep 17 00:00:00 2001
  From: Robby Workman <rworkman@slackware.com>
  Date: Sun, 11 Aug 2013 23:12:57 -0500

  Network init script (such as rc.inet1) and/or
  NetworkManager itself handles this just fine.


dhcpcd-hooks/20-resolv.conf: Actually validate the search list. Fixes #280:
--------------------------------------------------------------------------
  From 118b94bdffca7e33a5e0d6b596eb7e51e7109e68 Mon Sep 17 00:00:00 2001
  From: Roy Marples <roy@marples.name>
  Date: Tue, 6 Aug 2013 12:34:08 +0100
  Subject: [PATCH 1/2] Actually validate the search list. Fixes #280

