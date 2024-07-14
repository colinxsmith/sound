#include <crypt.h>
#include <stdio.h>

int main(
      int argc,
        char **argv)
{
    char *key = argv[1];
      char *salt = argv[2];
        char *enc = crypt(key, salt);
          printf("key = \"%s\", salt = \"%s\", enc = \"%s\"\n",
                   key ? key:"NULL", salt ? salt:"NULL", enc ? enc:"NULL");
          return 0;
}
/* gcc -O2 crypter.c  -lcrypt -o crypter*/

