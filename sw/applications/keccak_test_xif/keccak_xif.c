#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <inttypes.h>
#include <time.h>

#include "shake_ds.h"
#include "fips202.h"
#include "core_v_mini_mcu.h"
#include "csr.h"

#define SHAKE256_512_BYTES                    64
#define PARAM_K                               16
#define VEC_K_SIZE_BYTES                      PARAM_K
#define G_FCT_DOMAIN 3



int main() {
    shake256incctx shake256state;
    uint64_t m[2] = { 0x39cc3918b75cca7f, 0x742d1190d017f7b1};
    uint8_t theta[SHAKE256_512_BYTES] = {0};
    unsigned int cycles;

    shake256incctx shake256state2;
    uint8_t theta2[SHAKE256_512_BYTES] = {0};

    uint8_t theta_ref[SHAKE256_512_BYTES] = {
        0x28, 0xAF, 0xE4, 0x8A, 0x44, 0xF9, 0x93, 0xF6, 0x9E, 0xC5, 0xFF, 0xB8, 0x49, 0xBA, 0x1B, 0x58,
        0x25, 0x41, 0xF0, 0x9F, 0xE7, 0x05, 0xA9, 0x96, 0x99, 0x79, 0xCB, 0x4D, 0x9A, 0x4A, 0xC0, 0x98,
        0x95, 0xAE, 0xBA, 0xFA, 0x4D, 0x2E, 0x1E, 0xF2, 0xE5, 0x12, 0x65, 0xF7, 0xAD, 0x04, 0x78, 0x53,
        0x2E, 0x93, 0xB2, 0x0D, 0xDD, 0xE6, 0x21, 0x4E, 0x45, 0x9D, 0x6F, 0xE9, 0xA3, 0x53, 0xD3, 0xCB
    };


    printf("Test started!\n");
    CSR_CLEAR_BITS(CSR_REG_MCOUNTINHIBIT, 0x1);
    CSR_WRITE(CSR_REG_MCYCLE, 0);
    shake256_512_ds(&shake256state, theta, (uint8_t*) m, VEC_K_SIZE_BYTES, G_FCT_DOMAIN);
    CSR_READ(CSR_REG_MCYCLE, &cycles);
    printf("Number of clock cycles : %d\n", cycles);

    printf("Checking theta after shake256_512_ds...\n");
    for (int i = 0; i < SHAKE256_512_BYTES; ++i) {
        if (theta_ref[i] != theta[i]) {
            printf("Mismatch found at index %d: expected %x, got %x\n", i, theta_ref[i], theta[i]);
        }
    }
    

    return 0;
}
