// tag::supplied-data[]
// First 13 bytes of the key
constexpr unsigned char partial_key[13] = {
    0x81, 0x59, 0x6b, 0xfb, 0x39, 0xc6, 0x2b,
    0x71, 0x6e, 0x52, 0xdb, 0x91, 0x81,
};
// Ciphertext known to decrypt to only [a-z.] with the correct key
constexpr unsigned char ciphertext[16] = {
    0xbf, 0x3f, 0xb7, 0x7d, 0x93, 0xdd, 0x6c, 0xfd,
    0xef, 0xb8, 0x82, 0x2b, 0x82, 0xd0, 0x35, 0x8a,
};
// end::supplied-data[]