#! /bin/sh
#
# rc.K          This file is executed by init when it goes into runlevel 1,
#               which is the administrative state. It kills all daemons and
#               then puts the system into single user mode. Note that the
#               file systems are kept mounted.
#
# Author:       Miquel van Smoorenburg, <miquels@drinkel.nl.mugnet.org>
# Modified by:  Patrick J. Volkerding,  <volkerdi@slackware.com>,
#               Andrey V. Kosteltsev,   <kx@radix.pro>
#

# Set the path.
PATH=/sbin:/bin:/usr/bin:/usr/sbin

# Load any needed keyboard mappings:
if [ -x /etc/rc.d/rc.keymap ]; then
  . /etc/rc.d/rc.keymap
fi

# If there are SystemV init scripts for this runlevel, run them.
if [ -x /etc/rc.d/rc.sysvinit ]; then
  . /etc/rc.d/rc.sysvinit
fi

# Try to turn off quota:
#if grep -q quota /etc/fstab ; then
#  if [ -x /sbin/quotaoff ]; then
#    echo "Turning off filesystem quotas."
#    /sbin/quotaoff -a
#  fi
#fi

# Try to turn off accounting:
if [ -x /sbin/accton -a -r /var/log/pacct ]; then
  /sbin/accton off
fi

# Run any local shutdown scripts:
if [ -x /etc/rc.d/rc.local_shutdown ]; then
  /etc/rc.d/rc.local_shutdown stop
fi

# Stop the Apache web server:
if [ -x /etc/rc.d/rc.httpd ]; then
  /etc/rc.d/rc.httpd stop
fi

# Stop Nginx server:
if [ -x /etc/rc.d/rc.nginx ]; then
  /etc/rc.d/rc.nginx stop
fi

# Stop Message broker RabbitMQ
if [ -x /etc/rc.d/rc.rabbitmq ]; then
  /etc/rc.d/rc.rabbitmq stop
fi

# Stop key-value store Redis
if [ -x /etc/rc.d/rc.redis ]; then
  /etc/rc.d/rc.redis stop
fi

# Stop uWSGI for cGit server:
if [ -x /etc/rc.d/rc.cgit-uwsgi ]; then
  /etc/rc.d/rc.cgit-uwsgi stop
fi

# Stop FastCGI PHP server:
if [ -x /etc/rc.d/rc.php-fpm ]; then
  /etc/rc.d/rc.php-fpm stop
fi

# Stop postgres
if [ -x /etc/rc.d/rc.postgresql ]; then
  /etc/rc.d/rc.postgresql stop
fi

# Stop the MySQL database:
if [ -r /var/run/mysql/mysql.pid ]; then
  . /etc/rc.d/rc.mysqld stop
fi

# Stop the Samba server:
if [ -x /etc/rc.d/rc.samba ]; then
  . /etc/rc.d/rc.samba stop
fi

# Shut down the NFS server:
if [ -x /etc/rc.d/rc.nfsd ]; then
  /etc/rc.d/rc.nfsd stop
fi

# Shut down the SSH server:
if [ -x /etc/rc.d/rc.sshd ]; then
  /etc/rc.d/rc.sshd stop
fi

# Stop the Tomcat daemon:
if [ -x /etc/rc.d/rc.tomcat ]; then
  . /etc/rc.d/rc.tomcat stop
fi

# Shut down the Memcached daemon:
if [ -x /etc/rc.d/rc.memcached ]; then
  /etc/rc.d/rc.memcached stop
fi

# Shut down the Postfix daemon:
if [ -x /etc/rc.d/rc.postfix ]; then
  /etc/rc.d/rc.postfix stop
fi

# Shut down the IMAP daemon:
if [ -x /etc/rc.d/rc.cyrus-imapd ]; then
  /etc/rc.d/rc.cyrus-imapd stop
fi

# Shut down the SASL authentication daemon:
if [ -x /etc/rc.d/rc.saslauthd ]; then
  /etc/rc.d/rc.saslauthd stop
fi

# Shut down OpenLDAP:
if [ -x /etc/rc.d/rc.openldap ]; then
  /etc/rc.d/rc.openldap stop
fi

# Stop D-Bus:
if [ -x /etc/rc.d/rc.messagebus ]; then
  sh /etc/rc.d/rc.messagebus stop
fi

# Kill any processes (typically gam) that would otherwise prevent
# unmounting NFS volumes:
unset FUSER_DELAY
for dir in $(/bin/mount | grep 'type nfs' | cut -d ' ' -f 3 ) ; do
  echo "Killing processes holding NFS mount $dir open..."
  # Background this to prevent fuser from also blocking shutdown:
  /usr/bin/fuser -k -m $dir &
  FUSER_DELAY=5
done
# If fuser was run, let it have some delay:
if [ ! -z "$FUSER_DELAY" ]; then
  sleep $FUSER_DELAY
fi

# Unmount any NFS, SMB, or CIFS filesystems:
echo "Unmounting remote filesystems."
/bin/umount -v -a -l -f -r -t nfs,smbfs,cifs

# Shut down PCMCIA devices:
if [ -x /etc/rc.d/rc.pcmcia ] ; then
  . /etc/rc.d/rc.pcmcia stop
  # The cards might need a little extra time here to deactivate:
  sleep 5
fi

# Terminate acpid before syslog:
if [ -x /etc/rc.d/rc.acpid -a -r /var/run/acpid.pid ]; then # quit
  . /etc/rc.d/rc.acpid stop
fi

# Terminate ntpd before syslog:
if [ -x /etc/rc.d/rc.ntpd -a -r /var/run/ntpd.pid ]; then # quit
  sh /etc/rc.d/rc.ntpd stop
fi

# Kill all processes.
echo
echo "Sending all processes the SIGHUP signal."
killall5 -1
echo -n "Waiting for processes to hang up"
for loop in 0 1 2 3 4 5 ; do
  sleep 1
  echo -n "."
done
echo
echo "Sending all processes the SIGTERM signal."
killall5 -15
echo -n "Waiting for processes to terminate"
for loop in 0 1 2 3 4 5 ; do
  sleep 1
  echo -n "."
done
echo
echo "Sending all processes the SIGKILL signal."
killall5 -9
echo -n "Waiting for processes to exit"
for loop in 0 1 2 3 4 5 ; do
  sleep 1
  echo -n "."
done
echo

# Now go to the single user level
echo "Going to single user mode..."
telinit -t 1 1

