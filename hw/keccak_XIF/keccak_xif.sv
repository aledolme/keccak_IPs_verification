module keccak_xif
  import cv32e40px_core_v_xif_pkg::*;
  import keccak_xif_pkg::*;
(
    input logic clk_i,
    input logic rst_ni,

    input  x_issue_req_t x_issue_req_i,

    input keccak_xif_pkg::mode_t mode_i,
    input keccak_xif_pkg::funct7_t funct7_i,
    input keccak_xif_pkg::funct2_t funct2_i,
    input keccak_xif_pkg::immediate_t immediate_i,
    input keccak_xif_pkg::in_t in_i,
    input logic [1:0] insr_i,
    input logic keccak_i,
    output logic keccak_done_o,
    input logic kecca_store_i, 
    output keccak_xif_pkg::out_t out_o
);

  //--------signals declarations ----------------------------------------------------------------------------
  keccak_xif_pkg::out_t zero;
  keccak_xif_pkg::out_t trailing_zero_bits_count_result, laci_gf2m_mul_low_result;
  keccak_xif_pkg::out_t laci_gf2m_mul_low_reg;
  keccak_xif_pkg::out_t gf_reduce_result;
  keccak_xif_pkg::out_t gf_carryless_result; //, gf_carryless_result_reg;
  keccak_xif_pkg::out_t gf_square_result;
  keccak_xif_pkg::out_t reed_solomon_result;
  keccak_xif_pkg::out_t ftt_result;
  keccak_xif_pkg::out_t encode_result;
  keccak_xif_pkg::out_t vector_result;

  logic [31:0] gf_reduce_z2;
  logic enable, enable_reg;
  logic [1599:0] keccak_input, keccak_result;
  logic keccak_enable;

  keccak_xif_pkg::out_t mux_out;
  keccak_xif_pkg::out_t keccak_32out;
  logic [31:0] lim1, lim2;
  logic [49:0] [31:0] keccak_32out_packed;
  logic keccak_mux_reg;
  keccak_xif_pkg::instruction_u instruction; 
  
  assign zero = '0;

  assign keccak_32out_packed = keccak_result;
  
  assign enable = (mode_i == keccak_xif_pkg::OP_R_R1) && (funct7_i == keccak_xif_pkg::FUNCT7_2);
  assign keccak_enable = (mode_i == keccak_xif_pkg::OP_R4_R4) && (funct2_i == keccak_xif_pkg::FUNCT2_0);

  assign instruction = x_issue_req_i.instr;
  assign keccak_mux = (instruction.as_keccak_xif_R4.funct3 == keccak_xif_pkg::OP_R4_R4) && (instruction.as_keccak_xif_R4.funct2 == keccak_xif_pkg::FUNCT2_2);

  //register for keccak
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      keccak_32out.rd1 = '0;
      keccak_32out.rd2 = '0;
    end else begin
      if (keccak_mux == 1'b1) begin
         keccak_32out.rd1 = '0;
         keccak_32out.rd2 = keccak_32out_packed[x_issue_req_i.rs[0]];
      end else
          keccak_32out = '0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      enable_reg <= '0;
      keccak_mux_reg <= '0;
    end else begin
      enable_reg <= enable;
      keccak_mux_reg <= keccak_mux;
    end
  end

  // Register for storing laci_gf2m_mul_low_result only when en=1
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      laci_gf2m_mul_low_reg <= '0;
    end else if ( enable) begin
      laci_gf2m_mul_low_reg <= laci_gf2m_mul_low_result;
    end else if ( enable_reg) begin
      laci_gf2m_mul_low_reg.rd2 <= laci_gf2m_mul_low_reg.rd1;
      laci_gf2m_mul_low_reg.rd1 <= laci_gf2m_mul_low_reg.rd2;
    end
  end

  register_keccak i_register_keccak (
    .clk_i(clk_i),
    .rst_ni(rst_ni),  
    .register_keccak_0_i(in_i.rs1_0),  
    .register_keccak_1_i(in_i.rs2_0),  
    .register_keccak_enable_i(keccak_enable),
    .register_keccak_index_i(in_i.rs3_0[5:0]),
    .register_keccak_o(keccak_input)
  );

  keccak i_keccak (
    .clk(clk_i),   
    .rst_n(rst_ni),
    .start(keccak_i),
    .din(keccak_input),
    .dout(keccak_result),
    .done(keccak_done_o)
  );

  always_comb begin
      if (keccak_mux == 1'b1) begin
          //lim1 = in_i.rs1_0;
          out_o.rd2 = keccak_32out.rd2;
          out_o.rd1 = '0;
      end else
          out_o = '0;
  end




endmodule
