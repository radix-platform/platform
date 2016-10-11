
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include "remote_config.h"

#define PRINT_CONFIG

int set_config(remote_config_t *remote, int device_fd)
{
    unsigned int i;
    unsigned int *para=(unsigned int*)remote + 4;

    for(i = 0; i < ARRAY_SIZE(config_item); i++){
        if(para[i]!=0xffffffff){
#ifdef PRINT_CONFIG
            switch(i){
                case 7:

                case 19:
                case 20:
                case 21:
                case 22:
                case 23:
                case 24:

                case 25:
                case 26:
                case 27:
                case 28:
                case 29:
                case 30:
                case 31:
                case 32:
                    printf("%21s = 0x%08x\n", config_item[i], para[i]);
                    break;
                default:
                    printf("%21s = %lu\n", config_item[i], para[i]);
                    break;
                }
#endif
            ioctl(device_fd, remote_ioc_table[i], &para[i]);
            }
        }
    return 0;
}
