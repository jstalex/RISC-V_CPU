`timescale 1ns / 1ps

module im_tb();

logic [31:0] inst;
logic [5:0] addr;

instruction_memory dut(addr, inst);

initial begin
  addr = 0;
  for(integer i = 0; i < 8; i++) begin
    addr = addr + 1;
  end
end
endmodule
