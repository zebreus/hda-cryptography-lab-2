#include <iostream>
#include <openssl/aes.h>
#include <openssl/evp.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

  const unsigned char in[16] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
                                'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p'};
  const unsigned char key[16] = {0xa3, 0x28, 0x4e, 0x09, 0xc6, 0xfe,
                                 0x53, 0x29, 0x97, 0xef, 0x6d, 0x10,
                                 0x74, 0xc3, 0xde, 0xad};

  std::cout << std::endl << "Text before encryption:" << std::hex << std::endl;
  for (unsigned int i = 0; i != 4 * 4; ++i)
    std::cout << "0x" << (unsigned int)in[i] << ", ";
  std::cout << std::endl;

  unsigned char out[16] = {
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  };
  AES_KEY aes_key;
  AES_set_encrypt_key(key, 128, &aes_key);
  AES_encrypt(in, out, &aes_key);

  std::cout << std::endl << "Text after encryption:" << std::hex << std::endl;
  for (unsigned int i = 0; i != 4 * 4; ++i)
    std::cout << "0x" << (unsigned int)out[i] << ", ";
  std::cout << std::endl;

  return 0;
}
