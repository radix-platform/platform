#!/usr/bin/env python

import sys
try:
       from M2Crypto import RSA
except ImportError, e:
       sys.stderr.write('ERROR: Failed to import the "M2Crypto" module: %s\n' % e.message)
       sys.stderr.write('Please install the "M2Crypto" Python module.\n')
       sys.stderr.write('On Debian GNU/Linux the package is called "python-m2crypto".\n')
       sys.exit(1)

def print_bignum(output, name, val):
    while val[0] == '\0':
        val = val[1:]
    output.write('static const uint8_t %s[%d] = {\n' % (name, len(val)))
    idx = 0
    for v in val:
        if not idx:
            output.write('\t')
        output.write('0x%.2x, ' % ord(v))
        idx += 1
        if idx == 8:
            idx = 0
            output.write('\n')
    if idx:
        output.write('\n')
    output.write('};\n\n')

def print_keys(output, n):
    output.write(r'''
struct key_params {
	const uint8_t *e, *n;
	const uint32_t len_e, len_n;
};

#define KEYS(_e, _n) {			\
	.e = _e, .len_e = sizeof(_e),	\
	.n = _n, .len_n = sizeof(_n),	\
}

static const struct key_params __attribute__ ((unused)) keys[] = {
''')
    for n in xrange(n + 1):
        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
    output.write('};\n')

files = sys.argv[1:-1]
outfile = sys.argv[-1]

if len(files) == 0:
    print 'Usage: %s input-file... output-file' % (sys.argv[0], )
    sys.exit(2)

output = open(outfile, 'w')
output.write('#include <stdint.h>\n\n\n')

# load key
idx = 0
for f in files:
    try:
        key = RSA.load_pub_key(f)
    except RSA.RSAError:
        key = RSA.load_key(f)

    print_bignum(output, 'e_%d' % idx, key.e[4:])
    print_bignum(output, 'n_%d' % idx, key.n[4:])
    idx += 1

print_keys(output, idx - 1)
