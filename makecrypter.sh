grep gcc *.c | sed "s/^.*gcc/gcc/;s/-o.*/-o crypter/" | bash
chmod 755 crypter
