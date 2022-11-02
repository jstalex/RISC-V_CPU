`timescale 1ns / 1ps
`include "defines.v"

module alu_riscv (
  input [31:0] A,
  input [31:0] B,
  input [3:0] ALUOp,
  output reg Flag,   
  output reg [31:0] Result  
);                            

always @* begin
    case (ALUOp)
        `ADD: begin Result = A + B; Flag = 0; end
        `SUB: begin Result = A - B; Flag = 0; end
        `SLL: begin Result = A << B; Flag = 0; end
        `SLT: begin Result = $signed(A < B); Flag = 0; end
        `SLTU: begin Result = A < B; Flag = 0; end
        `XOR: begin Result = A ^ B; Flag = 0; end        
        `SRL: begin Result = A >> B; Flag = 0; end
        `SRA: begin Result = $signed(A) >>> B; Flag = 0; end
        `OR: begin Result = A | B; Flag = 0; end
        `AND: begin Result = A & B; Flag = 0; end
        `BEQ: begin Result = 0; Flag = (A == B); end
        `BNE: begin Result = 0; Flag = (A != B); end
        `BLT: begin Result = 0; Flag = $signed(A < B); end
        `BGE: begin Result = 0; Flag = $signed(A >= B); end
        `BLTU: begin Result = 0; Flag = (A < B); end
        `BGEU: begin Result = 0; Flag = (A >= B); end
        default: begin Result = 0; Flag = 0; end      
    endcase
end
endmodule