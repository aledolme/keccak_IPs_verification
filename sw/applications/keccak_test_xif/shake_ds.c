#include "shake_ds.h"


void shake256_512_ds(shake256incctx *state, uint8_t *output, const uint8_t *input, size_t inlen, uint8_t domain) {
    /* Init state */
    shake256_inc_init(state);

    /* Absorb input */
    shake256_inc_absorb(state, input, inlen);

    /* Absorb domain separation byte */
    shake256_inc_absorb(state, &domain, 1);

    /* Finalize */
    shake256_inc_finalize(state);

    /* Squeeze output */
    shake256_inc_squeeze(output, 512/8, state);
}
