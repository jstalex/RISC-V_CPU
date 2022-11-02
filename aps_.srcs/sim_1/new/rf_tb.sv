`timescale 1ns / 1ps

module rf_tb();

parameter PERIOD = 10;

logic CLK;
logic we;
logic [4:0] adr_3;
logic [31:0] wd;

logic [4:0] RA1;
logic [31:0] RD;

rf_riscv dut(.clk(CLK), .adr_3(adr_3), .we(we), .adr_1(RA1), .wd(wd), .rd_1(RD));

always begin
   CLK = 1'b0;
   #(PERIOD/2) CLK = 1'b1;
   #(PERIOD/2);
end

initial begin

    int data;
    
    for(integer i = 1; i < 32; i++) begin
    
        @(posedge CLK); #1;
        
        data = $urandom();
        
        we = 1;
        wd = data;
        adr_3 = i;
        
        @(posedge CLK); #1;
        we = 0;
        
        RA1 = i;
        @(posedge CLK);
        if (RD != data) 
            $display("FAIL adress = %b ; rd = %d; wd = %d", adr_3, RD, data);
        else
            $display("PASS adress = %b ; rd = %d; wd = %d", adr_3, RD, data);    
    end
end

endmodule
