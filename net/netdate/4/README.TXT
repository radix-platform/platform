
The TIME protocol, RFC-868
==========================

The TIME protocol is described in RFC-868.

The time server is listening on TCP/UDP port 37 and sends a 32-bit binary number
(seconds since 1900-01-01 00:00.00 UTC).

This base will serve until time stamp 4294967295, which will be on 2036-02-07 06:28.14 UTC.

Example: 3346003716 , which translates to 2006-01-11 21:28:49.

The standardized data format refers to UTC (Coordinated Universal Time), no other time zones.
This protocol cannot estimate network delays or report additional information.
Note: Time stamp on 1970-01-01 00:00.00 UTC (begin of the unix epoch) was 2208988800.


Short list of time servers:
==========================

ptbtime1.ptb.de             - ports 13 (local time), 37, NTP
ptbtime2.ptb.de             - ports 13 (local time), 37, NTP

NIST - US National Institute of Standards and Technology - www.boulder.nist.gov:
-------------------------------------------------------------------------------
time-a.timefreq.bldrdoc.gov - ports 13, 37
time-b.timefreq.bldrdoc.gov - ports 13, 37
time-c.timefreq.bldrdoc.gov - ports 13, 37
