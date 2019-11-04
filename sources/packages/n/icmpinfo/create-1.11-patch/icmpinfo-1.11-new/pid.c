
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>

#define PIDFILE                 "/var/run/icmpinfo.pid"

extern char *pname;

void sig_handler(int);
void pid_file(void);
void pid_kill(void);

void pid_file(void)
{
    FILE *fp;

    if ((fp = fopen(PIDFILE, "w")) != (FILE *)NULL) {
        fprintf(fp, "%d\n", getpid());
        fclose(fp);
    }
    else
    {
        fprintf(stderr, "\n%s: Could not write PID file `%s', terminating.\n",
            pname, PIDFILE);
        exit(1);
    }
    signal(SIGHUP, sig_handler);
    signal(SIGINT, sig_handler);
    signal(SIGTERM, sig_handler);
}

void sig_handler(int sig)
{
    unlink(PIDFILE);
    exit(0);
}

void pid_kill(void)
{
    FILE *fp;
    int pid;

    if ((fp = fopen(PIDFILE, "r")) != (FILE *)NULL)
    {
        if (fscanf(fp, "%d", &pid) == 1)
        {
            kill(pid, SIGHUP);
            sleep(1);
        }
        fclose(fp);
    }
}

