// Copyright 2022 OpenHW Group
// Solderpad Hardware License, Version 2.1, see LICENSE.md for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

/* verilator lint_off UNUSED */
/* verilator lint_off MULTIDRIVEN */

module memory_subsystem
  import obi_pkg::*;
#(
    parameter NUM_BANKS = 2
) (
    input logic clk_i,
    input logic rst_ni,

    // Clock-gating signal
    input logic [NUM_BANKS-1:0] clk_gate_en_ni,

    input  obi_req_t  [NUM_BANKS-1:0] ram_req_i,
    output obi_resp_t [NUM_BANKS-1:0] ram_resp_o,

    input logic [core_v_mini_mcu_pkg::NUM_BANKS-1:0] set_retentive_ni
);

  logic [NUM_BANKS-1:0] ram_valid_q;
  // Clock-gating
  logic [NUM_BANKS-1:0] clk_cg;

  logic [13-1:0] ram_req_addr_0;
  logic [13-1:0] ram_req_addr_1;
  logic [13-1:0] ram_req_addr_2;
  logic [13-1:0] ram_req_addr_3;
  logic [13-1:0] ram_req_addr_4;
  logic [13-1:0] ram_req_addr_5;
  logic [13-1:0] ram_req_addr_6;
  logic [13-1:0] ram_req_addr_7;
  logic [13-1:0] ram_req_addr_8;
  logic [13-1:0] ram_req_addr_9;
  logic [13-1:0] ram_req_addr_10;
  logic [13-1:0] ram_req_addr_11;


  assign ram_req_addr_0  = ram_req_i[0].addr[15-1:2];

  assign ram_req_addr_1  = ram_req_i[1].addr[15-1:2];

  assign ram_req_addr_2  = ram_req_i[2].addr[15-1:2];

  assign ram_req_addr_3  = ram_req_i[3].addr[15-1:2];

  assign ram_req_addr_4  = ram_req_i[4].addr[15-1:2];

  assign ram_req_addr_5  = ram_req_i[5].addr[15-1:2];

  assign ram_req_addr_6  = ram_req_i[6].addr[15-1:2];

  assign ram_req_addr_7  = ram_req_i[7].addr[15-1:2];

  assign ram_req_addr_8  = ram_req_i[8].addr[15-1:2];

  assign ram_req_addr_9  = ram_req_i[9].addr[15-1:2];

  assign ram_req_addr_10 = ram_req_i[10].addr[15-1:2];

  assign ram_req_addr_11 = ram_req_i[11].addr[15-1:2];

  for (genvar i = 0; i < NUM_BANKS; i++) begin : gen_sram

    tc_clk_gating clk_gating_cell_i (
        .clk_i,
        .en_i(clk_gate_en_ni[i]),
        .test_en_i(1'b0),
        .clk_o(clk_cg[i])
    );

    always_ff @(posedge clk_cg[i] or negedge rst_ni) begin
      if (!rst_ni) begin
        ram_valid_q[i] <= '0;
      end else begin
        ram_valid_q[i] <= ram_resp_o[i].gnt;
      end
    end

    assign ram_resp_o[i].gnt = ram_req_i[i].req;
    assign ram_resp_o[i].rvalid = ram_valid_q[i];
  end

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram0_i (
      .clk_i(clk_cg[0]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[0].req),
      .we_i(ram_req_i[0].we),
      .addr_i(ram_req_addr_0),
      .wdata_i(ram_req_i[0].wdata),
      .be_i(ram_req_i[0].be),
      .set_retentive_ni(set_retentive_ni[0]),
      .rdata_o(ram_resp_o[0].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram1_i (
      .clk_i(clk_cg[1]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[1].req),
      .we_i(ram_req_i[1].we),
      .addr_i(ram_req_addr_1),
      .wdata_i(ram_req_i[1].wdata),
      .be_i(ram_req_i[1].be),
      .set_retentive_ni(set_retentive_ni[1]),
      .rdata_o(ram_resp_o[1].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram2_i (
      .clk_i(clk_cg[2]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[2].req),
      .we_i(ram_req_i[2].we),
      .addr_i(ram_req_addr_2),
      .wdata_i(ram_req_i[2].wdata),
      .be_i(ram_req_i[2].be),
      .set_retentive_ni(set_retentive_ni[2]),
      .rdata_o(ram_resp_o[2].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram3_i (
      .clk_i(clk_cg[3]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[3].req),
      .we_i(ram_req_i[3].we),
      .addr_i(ram_req_addr_3),
      .wdata_i(ram_req_i[3].wdata),
      .be_i(ram_req_i[3].be),
      .set_retentive_ni(set_retentive_ni[3]),
      .rdata_o(ram_resp_o[3].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram4_i (
      .clk_i(clk_cg[4]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[4].req),
      .we_i(ram_req_i[4].we),
      .addr_i(ram_req_addr_4),
      .wdata_i(ram_req_i[4].wdata),
      .be_i(ram_req_i[4].be),
      .set_retentive_ni(set_retentive_ni[4]),
      .rdata_o(ram_resp_o[4].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram5_i (
      .clk_i(clk_cg[5]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[5].req),
      .we_i(ram_req_i[5].we),
      .addr_i(ram_req_addr_5),
      .wdata_i(ram_req_i[5].wdata),
      .be_i(ram_req_i[5].be),
      .set_retentive_ni(set_retentive_ni[5]),
      .rdata_o(ram_resp_o[5].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram6_i (
      .clk_i(clk_cg[6]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[6].req),
      .we_i(ram_req_i[6].we),
      .addr_i(ram_req_addr_6),
      .wdata_i(ram_req_i[6].wdata),
      .be_i(ram_req_i[6].be),
      .set_retentive_ni(set_retentive_ni[6]),
      .rdata_o(ram_resp_o[6].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram7_i (
      .clk_i(clk_cg[7]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[7].req),
      .we_i(ram_req_i[7].we),
      .addr_i(ram_req_addr_7),
      .wdata_i(ram_req_i[7].wdata),
      .be_i(ram_req_i[7].be),
      .set_retentive_ni(set_retentive_ni[7]),
      .rdata_o(ram_resp_o[7].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram8_i (
      .clk_i(clk_cg[8]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[8].req),
      .we_i(ram_req_i[8].we),
      .addr_i(ram_req_addr_8),
      .wdata_i(ram_req_i[8].wdata),
      .be_i(ram_req_i[8].be),
      .set_retentive_ni(set_retentive_ni[8]),
      .rdata_o(ram_resp_o[8].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram9_i (
      .clk_i(clk_cg[9]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[9].req),
      .we_i(ram_req_i[9].we),
      .addr_i(ram_req_addr_9),
      .wdata_i(ram_req_i[9].wdata),
      .be_i(ram_req_i[9].be),
      .set_retentive_ni(set_retentive_ni[9]),
      .rdata_o(ram_resp_o[9].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram10_i (
      .clk_i(clk_cg[10]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[10].req),
      .we_i(ram_req_i[10].we),
      .addr_i(ram_req_addr_10),
      .wdata_i(ram_req_i[10].wdata),
      .be_i(ram_req_i[10].be),
      .set_retentive_ni(set_retentive_ni[10]),
      .rdata_o(ram_resp_o[10].rdata)
  );

  sram_wrapper #(
      .NumWords (8192),
      .DataWidth(32'd32)
  ) ram11_i (
      .clk_i(clk_cg[11]),
      .rst_ni(rst_ni),
      .req_i(ram_req_i[11].req),
      .we_i(ram_req_i[11].we),
      .addr_i(ram_req_addr_11),
      .wdata_i(ram_req_i[11].wdata),
      .be_i(ram_req_i[11].be),
      .set_retentive_ni(set_retentive_ni[11]),
      .rdata_o(ram_resp_o[11].rdata)
  );


endmodule
