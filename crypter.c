#include <crypt.h>
#include <stdio.h>

int main(
      int argc,
        char **argv)
{
    char *key = argv[1];
      char *salt = argv[2];
        char *enc = crypt(key, salt);
          fprintf(stderr,"On standard error:key = \"%s\", salt = \"%s\", enc = \"%s\"\n",
                   key ? key:"NULL", salt ? salt:"NULL", enc ? enc:"NULL");

        printf("%s\n",enc);
        return 0;
}
/* gcc -O2 crypter.c  -lcrypt -o crypter*/

