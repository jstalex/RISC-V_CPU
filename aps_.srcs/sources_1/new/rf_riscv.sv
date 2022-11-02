`timescale 1ns / 1ps

module rf_riscv(
    input clk,
    input [4:0] adr_1,
    input [4:0] adr_2,
    input [4:0] adr_3,
    input [31:0] wd,
    input we,
    output [31:0] rd_1,
    output [31:0] rd_2 
);  
// indexing 0-31 or 31-0?
logic [31:0] RAM [0:31];

assign rd_1 = (adr_1 == 0) ? 0 : RAM[adr_1];
assign rd_2 = (adr_2 == 0) ? 0 : RAM[adr_2];

always_ff @(posedge clk) begin
    if (we && adr_3) RAM[adr_3] <= wd;    
end

endmodule
