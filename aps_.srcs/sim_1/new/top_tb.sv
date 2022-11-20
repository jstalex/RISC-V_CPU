`timescale 1ns / 1ps

module top_tb();

parameter PERIOD = 10;

logic CLK;
logic rst;

always begin
   CLK = 1'b0;
   #(PERIOD/2) CLK = 1'b1;
   #(PERIOD/2);
end

cpu_top dut(.CLK100MHZ(CLK), .rst(rst));

initial begin
  rst <= 1;
  #20;
  rst <= 0;
end

endmodule
