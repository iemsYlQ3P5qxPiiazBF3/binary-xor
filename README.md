```
xor/dexor

program to encrypt text using /dev/urandom or /dev/random

output of program is in hex, decoded also into files `encrypted` and `key`

for a set key, write it in binary to <key file>, and run `./dexor.sh <plaintext file> <key file>`
(the key and plaintext must be the same, or the key can be larger)
(the plaintext file should come first)

the output of decrypted text is in `decrypted` file

to encrypt:

./xor.sh -f <file to encrypt> -k /dev/(u)random

to decrypt:

./dexor.sh encrypted/key encrypted/key #(order doesn't matter)

time:
(500 bytes)
for decrypting, it takes 0 minutes 8 seconds
for encrypting, it takes 0 minutes 6 seconds
(these measurements made on a computer)
```
