#include <sys/types.h>
#include <stdlib.h>
#include <dirent.h>
main() { struct dirent *di; DIR *d = opendir("."); di = readdir(d);
if (di && di->d_name[-2] == '.' && di->d_name[-1] == 0 &&
di->d_name[0] == 0) exit(0); exit(1);}
