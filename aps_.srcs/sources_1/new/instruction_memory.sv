`timescale 1ns / 1ps

module instruction_memory #(
    int WIDTH = 32,
    int DEPTH = 256
)(
    input [`WORD_LEN - 1:0] A,
    output [WIDTH-1:0] D
);

logic [WIDTH-1:0]ROM[0:DEPTH-1];
initial $readmemb("prog.txt", ROM, 0, DEPTH-1); 

logic [`WORD_LEN - 1:0] shifted_adress;
assign shifted_adress = A >> 2;

assign D = ROM[shifted_adress[7:0]]; 
    
endmodule
