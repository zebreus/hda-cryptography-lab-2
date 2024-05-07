#ifdef __INTELLISENSE__
#include "AesFunctions.cppm"
#else
import AesFunctions;
#endif
#include <algorithm>
#include <fcntl.h>
#include <iostream>
#include <ranges>
#include <unistd.h>

// tag::main[]
int main() {
  int devRandom = open("/dev/random", O_RDONLY);

  for (int round = 0; round < 1000000; ++round) {
    std::array<unsigned char, 16> plaintext, key;
    read(devRandom, plaintext.data(), 16);
    read(devRandom, key.data(), 16);

    // Cipher with our implementation
    auto ciphertext = simple_encrypt(plaintext, key);
    auto decryptedPlaintext = simple_decrypt(ciphertext, key);
    // Cipher with openssl
    auto ciphertextOpenssl = simple_openssl_encrypt(plaintext, key);
    auto decryptedPlaintextOpenssl =
        simple_openssl_decrypt(ciphertextOpenssl, key);

    if (!std::ranges::equal(ciphertext, ciphertextOpenssl)) {
      printf("OpenSSL and simple encryption produced different ciphertexts");
      exit(1);
    }
    if (!std::ranges::equal(plaintext, decryptedPlaintext)) {
      printf("Decryption did not produce the original plaintext");
      exit(1);
    }
    if (!std::ranges::equal(decryptedPlaintext, decryptedPlaintextOpenssl)) {
      printf("OpenSSL and simple decryption produced different results");
      exit(1);
    }
  }
  std::printf("Encryption and decryption seems to work\n");
}
// end::main[]