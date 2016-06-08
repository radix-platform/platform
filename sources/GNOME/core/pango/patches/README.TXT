
pango-1.??.?-no-eps.patch - used for building pango without cairo SVG, PDF, PS engines.
                            This patch required when full functional cairo is installed
                            into target x86_64 rootfs and we have cairo-{svg,pdf,ps}.h
                            headers but for x86_32 platform we still have libcairo which
                            doesn't have SVG, PDF, PS support. In this case we have to apply
                            this patch to be able build x86_32 libs/pango.

                            This patch is not required for X11/libs/pango !
