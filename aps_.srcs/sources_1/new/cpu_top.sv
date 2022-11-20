`timescale 1ns / 1ps
`include "defines_riscv.v"

module cpu_top (
    input CLK100MHZ,
    input rst
);

logic [`WORD_LEN-1:0] instruction;

// main decoder connection 
logic [1:0] ex_op_a_sel_o;
logic [2:0] ex_op_b_sel_o;
logic [`ALU_OP_WIDTH-1:0] alu_op_o;
logic mem_req_o;
logic mem_we_o;
logic [2:0] mem_size_o;

logic gpr_we_a_o;
logic wb_src_sel_o;

logic illegal_instr_o;
logic branch_o;
logic jal_o;
logic jalr_o;

decoder_riscv main_decoder (
      .fetched_instr_i(instruction),

      .ex_op_a_sel_o(ex_op_a_sel_o),
      .ex_op_b_sel_o(ex_op_b_sel_o),
      .alu_op_o(alu_op_o),

      .mem_req_o (mem_req_o),
      .mem_we_o  (mem_we_o),
      .mem_size_o(mem_size_o),

      .gpr_we_a_o  (gpr_we_a_o),
      .wb_src_sel_o(wb_src_sel_o),

      .illegal_instr_o(illegal_instr_o),
      .branch_o(branch_o),
      .jal_o(jal_o),
      .jalr_o(jalr_o)
);

// sign-extenders for I, S, J, B

logic [`WORD_LEN-1:0] imm_I;
assign imm_I = {{(`WORD_LEN - 12) {instruction[31]}}, instruction[`I_TYPE_IMM]};

logic [`WORD_LEN-1:0] imm_S;
assign imm_S = {{(`WORD_LEN - 12) {instruction[31]}}, instruction[`S_TYPE_IMM_11_5], instruction[`S_TYPE_IMM_4_0]};

logic [`WORD_LEN-1:0] imm_J;
assign imm_J = {{(`WORD_LEN - 21) {instruction[31]}},
    instruction[`J_TYPE_IMM_20],
    instruction[`J_TYPE_IMM_19_12],
    instruction[`J_TYPE_IMM_11],
    instruction[`J_TYPE_IMM_10_1],
    1'b0
};

logic [`WORD_LEN-1:0] imm_B;
assign imm_B = {{(`WORD_LEN - 13) {instruction[31]}}, 
    instruction[`B_TYPE_IMM_12],
    instruction[`B_TYPE_IMM_11],
    instruction[`B_TYPE_IMM_10_5],
    instruction[`B_TYPE_IMM_4_1],
    1'b0
};

// alu 
logic ALU_flag;
logic [`WORD_LEN-1:0] ALU_res;
// pc
// parameter COUNTER_WIDTH = $clog2(`INSTR_DEPTH);
logic [`WORD_LEN-1:0] PC;

// switches  
//logic [`WORD_LEN-1:0] extended_switch;
//assign extended_switch = {{(`WORD_LEN - 15) {SW[14]}}, SW[14:0]};

// instruction memory
instruction_memory im(
  .A(PC),
  .D(instruction)
);
// constant
//logic [`WORD_LEN-1:0] extended_const;
// assign extended_const = {{(`WORD_LEN - `CONST_LEN) {instruction[`CONST+(`CONST_LEN-1)]}},instruction[`CONST]};   
// rf

logic memory_rd; // read data form data memory

logic [`WORD_LEN-1:0] rd1;
logic [`WORD_LEN-1:0] rd2;
logic [`WORD_LEN-1:0] wd;

// wd multiplexer
always_comb begin
  case (wb_src_sel_o)
    `WB_EX_RESULT: wd <= ALU_res;
    `WB_LSU_DATA: wd <= memory_rd;
    default: wd <= 0;
  endcase
end

// connection
rf_riscv rf (
  .clk (CLK100MHZ),
  .adr_1(instruction[`RA1]),
  .adr_2(instruction[`RA2]),
  .adr_3(instruction[`WA]),
  .wd (wd),
  .we (gpr_we_a_o),
  .rd_1(rd1),
  .rd_2(rd2)
);

// PC
logic [`WORD_LEN-1:0] pc_inc;
logic [`WORD_LEN-1:0] pc_inc_imm;
// muxes for pc
assign pc_inc_imm = branch_o ? imm_B : imm_J;
assign pc_inc = (jal_o || (branch_o && ALU_flag)) ? pc_inc_imm : 4;

always_ff @(posedge CLK100MHZ or posedge rst) begin
  if (rst) PC <= 0;
  else begin
    if (jalr_o) PC <= rd1 + imm_I;
    else PC = PC + pc_inc;
  end 
end

// ALU
logic [`WORD_LEN-1:0] alu_A;
logic [`WORD_LEN-1:0] alu_B;

// select A operand
always_comb begin
    case (ex_op_a_sel_o)
        `OP_A_RS1: alu_A <= rd1;
        `OP_A_CURR_PC: alu_A <= PC;
        `OP_A_ZERO: alu_A <= 0;
        default: alu_A <= 0;
    endcase
end

// select B operand
always_comb begin
    case (ex_op_b_sel_o)
        `OP_B_RS2: alu_B <= rd2;
        `OP_B_IMM_I: alu_B <= imm_I;
        `OP_B_IMM_U: alu_B <= {instruction[`U_TYPE_IMM_31_12], {(`WORD_LEN - 20) {1'b0}}};
        `OP_B_IMM_S: alu_B <= imm_S;
        `OP_B_INCR: alu_B <= 4;
        default: alu_B <= 0;
    endcase
end

alu_riscv alu (
  .A(alu_A),
  .B(alu_B),
  .ALUOp(alu_op_o),
  .Flag  (ALU_flag),
  .Result(ALU_res)
);

//assign LED[15:0] = rd1[15:0];
data_memory memory (
    .CLK(CLK100MHZ),
    .A(ALU_res),
    .WD(rd2),
    .WE(mem_we_o),
    .RD(memory_rd)
);

endmodule
