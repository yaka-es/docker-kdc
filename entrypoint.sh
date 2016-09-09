#!/bin/sh

set -e

do_init() {
	echo "Initializing Kerberos." >&2

	echo -n "REALM (e.g. EXAMPLE.COM): " >&2
	read REALM

	echo -n "Domain (e.g. example.com): " >&2
	read DOMAIN

	echo -n "KDC server (e.g. kdc.example.com): " >&2
	read KDC_SERVER

	echo -n "Admin server (e.g. kdc.example.com): " >&2
	read ADMIN_SERVER

	kdb5_util -r ${REALM} create -s

	cat > /etc/krb5.conf << EOF
[logging]
# default = FILE:/var/log/krb5libs.log
# kdc = FILE:/var/log/krb5kdc.log
# admin_server = FILE:/var/log/kadmind.log

[libdefaults]
dns_lookup_realm = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
rdns = false
default_realm = ${REALM}

[realms]
${REALM} = {
	kdc = ${KDC_SERVER}
	admin_server = ${ADMIN_SERVER}
}

[domain_realm]
${DOMAIN} = ${REALM}
.${DOMAIN} = ${REALM}
EOF

	echo "Please check etc/krn5.conf!" >&2

	kadmin.local -r ${REALM}  addprinc admin/admin@${REALM}

	exit 0
}

case "$1" in
	init)
		do_init
		;;

	server)
		shift
		;;

	*)
		exec $*
		;;
esac

do_stop() {
	killall kpropd
	killall kadmind
	killall krb5kdc
	exit 0
}

do_hup() {
	:
}

trap "do_stop" SIGINT
trap "do_stop" SIGTERM
trap "do_hup" SIGHUP

touch /var/log/messages

/usr/sbin/krb5kdc
/usr/sbin/kadmind
/usr/sbin/kpropd

tail -f /var/log/messages

