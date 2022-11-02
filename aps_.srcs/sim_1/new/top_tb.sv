`timescale 1ns / 1ps

module top_tb();

parameter PERIOD = 10;

logic CLK;
logic [15:0] sw;
logic [15:0] leds;
logic rst;

always begin
   CLK = 1'b0;
   #(PERIOD/2) CLK = 1'b1;
   #(PERIOD/2);
end

cpu_top dut(.CLK100MHZ(CLK), .SW(sw), .LED(leds), .rst(rst));

initial begin
  rst <= 1;
  #10;
  rst <= 0;
  sw <= 16'b0000_0000_0000_0100;
end

endmodule
