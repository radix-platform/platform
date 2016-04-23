#!/bin/sh
#
# make-ca.sh
# ==========
#
# Script to populate OpenSSL's CApath from a bundle of PEM formatted CAs
#
# The file certdata.txt must exist in the local directory
# Version number is obtained from the version of the data.
#

certdata="certdata.txt"

if [ ! -r $certdata ]; then
  echo "$certdata must be in the local directory"
  exit 1
fi

VERSION=$1

EXITSTATUS=0

TEMPDIR=$(mktemp -d /tmp/XXXXXXXX) || { echo "Cannot create '/tmp/...' directory" ; exit 92; }
trap "rm -rf $TMP" EXIT

genfname() {
  file=$1
  line=`head -n 1 $file`
  fname=`echo $line | cut -f 2 -d '"' | sed -e 's, ,_,g' -e 's,/,_,g' -e 's,(,=,g' -e 's,),=,g' -e 's/,/_/g'`
  echo "$fname"
}

splitted="splitted"

create_ca_file() {
  name=$1
  pemfl=$2
  START=`grep -n "BEGIN CERTIFICATE" $pemfl | cut -f 1 -d ':'`
  END=`grep -n "END CERTIFICATE" $pemfl | cut -f 1 -d ':'`
  cat $pemfl | sed -n ${START},${END}p > ${splitted}/${name}.crt
}


TRUSTATTRIBUTES="CKA_TRUST_SERVER_AUTH"
BUNDLE="ca-bundle-${VERSION}.crt"
SPLITTED_CERTS="ca-certificates-${VERSION}.crt"
CONVERTSCRIPT="./make-cert.pl"
SSLDIR="/etc/ssl"

mkdir "${TEMPDIR}/certs"

# Get a list of starting lines for each cert
CERTBEGINLIST=$(grep -n "^# Certificate" "${certdata}" | cut -d ":" -f1)

# Get a list of ending lines for each cert
CERTENDLIST=`grep -n "^CKA_TRUST_STEP_UP_APPROVED" "${certdata}" | cut -d ":" -f 1`

# Start a loop
for certbegin in ${CERTBEGINLIST}; do
  for certend in ${CERTENDLIST}; do
    if test "${certend}" -gt "${certbegin}"; then
      break
    fi
  done

  # Dump to a temp file with the name of the file as the beginning line number
  sed -n "${certbegin},${certend}p" "${certdata}" > "${TEMPDIR}/certs/${certbegin}.tmp"
done

unset CERTBEGINLIST CERTDATA CERTENDLIST certbegin certend

mkdir -p certs
rm -f certs/*       # Make sure the directory is clean

mkdir -p ${splitted}
rm -f ${splitted}/* # Make sure the directory is clean

for tempfile in ${TEMPDIR}/certs/*.tmp; do
  # Make sure that the cert is trusted...
  grep "CKA_TRUST_SERVER_AUTH" "${tempfile}" | \
    egrep "TRUST_UNKNOWN|NOT_TRUSTED" > /dev/null

  if test "${?}" = "0"; then
    # Throw a meaningful error and remove the file
    cp "${tempfile}" tempfile.cer
    perl ${CONVERTSCRIPT} > tempfile.crt
    keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
    echo "Certificate ${keyhash} is not trusted!  Removing..."
    rm -f tempfile.cer tempfile.crt "${tempfile}"
    continue
  fi

  # If execution made it to here in the loop, the temp cert is trusted
  # Find the cert data and generate a cert file for it

  cp "${tempfile}" tempfile.cer
  perl ${CONVERTSCRIPT} > tempfile.crt
  keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
  mv tempfile.crt "certs/${keyhash}.pem"

  # Create separate certificate file
  crtfname=`genfname tempfile.cer`
  create_ca_file $crtfname "certs/${keyhash}.pem"

  rm -f tempfile.cer "${tempfile}"
  echo "Created ${keyhash}.pem"
done

# Remove blacklisted files
# MD5 Collision Proof of Concept CA
if test -f certs/8f111d69.pem; then
  echo "Certificate 8f111d69 is not trusted!  Removing..."
  rm -f certs/8f111d69.pem
fi

# Finally, generate the bundle and clean up.
cat certs/*.pem > ${BUNDLE}
cat ${splitted}/*.crt > ${SPLITTED_CERTS}

exit $EXITSTATUS
