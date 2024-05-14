// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_hamming_22_16_dec (
  input        [21:0] in,
  output logic [15:0] d_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);


  // Syndrome calculation
  assign syndrome_o[0] = ^(in & 22'h01AD5B);
  assign syndrome_o[1] = ^(in & 22'h02366D);
  assign syndrome_o[2] = ^(in & 22'h04C78E);
  assign syndrome_o[3] = ^(in & 22'h0807F0);
  assign syndrome_o[4] = ^(in & 22'h10F800);
  assign syndrome_o[5] = ^(in & 22'h3FFFFF);

  // Corrected output calculation
  assign d_o[0] = (syndrome_o == 6'h23) ^ in[0];
  assign d_o[1] = (syndrome_o == 6'h25) ^ in[1];
  assign d_o[2] = (syndrome_o == 6'h26) ^ in[2];
  assign d_o[3] = (syndrome_o == 6'h27) ^ in[3];
  assign d_o[4] = (syndrome_o == 6'h29) ^ in[4];
  assign d_o[5] = (syndrome_o == 6'h2a) ^ in[5];
  assign d_o[6] = (syndrome_o == 6'h2b) ^ in[6];
  assign d_o[7] = (syndrome_o == 6'h2c) ^ in[7];
  assign d_o[8] = (syndrome_o == 6'h2d) ^ in[8];
  assign d_o[9] = (syndrome_o == 6'h2e) ^ in[9];
  assign d_o[10] = (syndrome_o == 6'h2f) ^ in[10];
  assign d_o[11] = (syndrome_o == 6'h31) ^ in[11];
  assign d_o[12] = (syndrome_o == 6'h32) ^ in[12];
  assign d_o[13] = (syndrome_o == 6'h33) ^ in[13];
  assign d_o[14] = (syndrome_o == 6'h34) ^ in[14];
  assign d_o[15] = (syndrome_o == 6'h35) ^ in[15];

  // err_o calc. bit0: single error, bit1: double error
  assign err_o[0] = syndrome_o[5];
  assign err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];

endmodule : prim_secded_hamming_22_16_dec