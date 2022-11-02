`timescale 1ns / 1ps
`include "defines.v"

module cpu_top (
    input CLK100MHZ,
    input [15:0] SW,
    input rst,
    output [15:0] LED
);
// alu 
logic ALU_flag;
logic [`WORD_LEN-1:0] ALU_res;
// pc
parameter COUNTER_WIDTH = $clog2(`INSTR_DEPTH);
logic [COUNTER_WIDTH-1:0] PC;
// switches  
logic [`WORD_LEN-1:0] extended_switch;
assign extended_switch = {{(`WORD_LEN - 15) {SW[14]}}, SW[14:0]};
// instruction memory
logic [`WORD_LEN-1:0] instruction;
instruction_memory im(
  .A(PC),
  .D(instruction)
);
// constant
logic [`WORD_LEN-1:0] extended_const;
assign extended_const = {{(`WORD_LEN - `CONST_LEN) {instruction[`CONST+(`CONST_LEN-1)]}},instruction[`CONST]};   
// rf
logic [`WORD_LEN-1:0] rd1;
logic [`WORD_LEN-1:0] rd2;
logic [`WORD_LEN-1:0] wd;
// wd multiplexer
always_comb begin
  case (instruction[`WS])
    2'b01: wd = extended_switch;
    2'b10: wd = extended_const;
    2'b11: wd = ALU_res;
    default: wd = 0;
  endcase
end
// connection
rf_riscv rf (
  .clk (CLK100MHZ),
  .adr_1(instruction[`RA1]),
  .adr_2(instruction[`RA2]),
  .adr_3(instruction[`WA]),
  .wd (wd),
  .we (instruction[29] | instruction[28]),
  .rd_1(rd1),
  .rd_2(rd2)
);
// PC
always_ff @(posedge CLK100MHZ) begin
  if (rst)PC <= 0;
  else if ((instruction[`C] & ALU_flag) | instruction[`B]) PC <= PC + extended_const;
  else PC <= PC + 1;
end
// ALU
alu_riscv alu (
  .A(rd1),
  .B(rd2),
  .ALUOp(instruction[`ALUOp]),
  .Flag  (ALU_flag),
  .Result(ALU_res)
);

assign LED[15:0] = rd1[15:0];

endmodule
