# docker-kdc
Dockerized minimal krb5-server installation based on Alpine Linux.

Do not use this build!

Basic usage:

```
$ docker run --rm -it \
	-v /mnt/docker/kdc-server/etc/krb5.conf:/etc/krb5.conf \
	-v /mnt/docker/kdc-server/var/lib/krb5kdc:/var/lib/krb5kdc \
	yakaes/docker-kdc init
$ docker run --rm -it \
	-v /mnt/docker/kdc-server/etc/krb5.conf:/etc/krb5.conf \
	-v /mnt/docker/kdc-server/var/lib/krb5kdc:/var/lib/krb5kdc \
	yakaes/docker-kdc
```

