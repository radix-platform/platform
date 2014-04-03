/*
 * Infinite loop to receive every ICMP packet received on the socket.
 * For every packet that's received, we just call pr_pack() to look
 * at it and print it.
 */

#include	"defs.h"

int recv_ping()
{
	register int		n;
#if !defined(__GLIBC__)
	int			fromlen;
#else /* __GLIBC__ */
	socklen_t		fromlen;
#endif /* __GLIBC__ */
	struct sockaddr_in	from;

	for ( ; ; ) {
		fromlen = sizeof(from);
		if ( (n = recvfrom(sockfd, recvpack, sizeof(recvpack), 0,
				(struct sockaddr *) &from, &fromlen)) < 0) {
			if (errno == EINTR)
				continue;	/* normal */
			err_ret("recvfrom error");
			continue;
		}

		pr_pack(recvpack, n, &from);

	}
}
