#ifdef __INTELLISENSE__
#include "AesFunctions.cppm"
#else
import AesFunctions;
#endif
#include <algorithm>
#include <iostream>
#include <ranges>

// tag::supplied-data[]
// First 13 bytes of the key
constexpr std::array<unsigned char, 13> partial_key = {
    0x81, 0x59, 0x6b, 0xfb, 0x39, 0xc6, 0x2b,
    0x71, 0x6e, 0x52, 0xdb, 0x91, 0x81,
};
// Ciphertext known to decrypt to only [a-z.] with the correct key
constexpr std::array<unsigned char, 16> ciphertext = {
    0xbf, 0x3f, 0xb7, 0x7d, 0x93, 0xdd, 0x6c, 0xfd,
    0xef, 0xb8, 0x82, 0x2b, 0x82, 0xd0, 0x35, 0x8a,
};
// end::supplied-data[]

// tag::main[]
int main() {
  std::array<unsigned char, 16> key;
  for (int i = 0; i < 13; i++) {
    key[i] = partial_key[i];
  }
  for (unsigned char a = 0; a != 255; ++a) {
    for (unsigned char b = 0; b != 255; ++b) {
      for (unsigned char c = 0; c != 255; ++c) {
        key[13] = a;
        key[14] = b;
        key[15] = c;
        auto decryptedPlaintext = simple_decrypt(ciphertext, key);
        if (std::ranges::all_of(decryptedPlaintext, [](unsigned char c) {
              return (c >= 'a' && c <= 'z') || c == '.';
            })) {
          std::cout << "Found key: ";
          for (int i = 0; i < 16; i++) {
            std::cout << std::hex << (unsigned int)key[i];
          }
          std::cout << std::endl;
          std::cout << "Decrypted text is:" << std::endl;
          for (int i = 0; i < 16; i++) {
            std::cout << decryptedPlaintext[i];
          }
          std::cout << std::endl;
          return 0;
        }
      }
    }
  }
  std::cout << "Key not found" << std::endl;
  return 1;
}
// end::main[]