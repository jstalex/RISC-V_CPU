`timescale 1ns / 1ps 

`define ADD 5'b00000
`define SUB 5'b01000
`define SLL 5'b00001
`define SLT 5'b00010
`define SLTU 5'b00011
`define XOR 5'b00100
`define SRL 5'b00101
`define SRA 5'b01101
`define OR 5'b00110
`define AND 5'b00111
`define BEQ 5'b11000
`define BNE 5'b11001
`define BLT 5'b11100
`define BGE 5'b11101
`define BLTU 5'b11110
`define BGEU 5'b11111


module alu_riscv_tb();

reg [31:0] A, B;
reg [4:0] ALUOp;
wire Flag;
wire [31:0] Result;

alu_riscv dut(A, B, ALUOp, Flag, Result);

initial begin
    operation_check(1,3,`ADD);
    operation_check(0,1,`ADD);
    operation_check(0,0, `ADD);
    
    operation_check(1,1, `SUB);
    operation_check(4,2, `SUB);
    
    operation_check(2,2, `SLL);
    operation_check(0,2, `SLL);
    
    operation_check(2,4, `SLT);
    operation_check(4,2, `SLT);
    
    operation_check(0,2, `SLTU);
    operation_check(0,0, `SLTU);
    
    operation_check(1,0, `XOR);
    operation_check(1,1, `XOR);
    
    operation_check(4,2, `SRL);
    operation_check(8,0, `SRL);
    
    operation_check(7,1, `SRA);
    operation_check(5,2, `SRA);
    
    operation_check(0,1, `OR);
    operation_check(1,0, `OR);
    operation_check(0,0, `OR);
    
    operation_check(1,0, `AND);
    operation_check(1,1, `AND);
    
    operation_check(66,66, `BEQ);
    operation_check(666,66, `BEQ);
    
    operation_check(222,22, `BNE);
    operation_check(2,2,`BNE);
    
    operation_check(-1,100, `BLT);
    operation_check(300,-300, `BLT);
    
    operation_check(-600,300, `BGE);
    operation_check(0, 22, `BGE);
    
    operation_check(3,0, `BLTU);
    operation_check(300,3, `BLTU);
    
    operation_check(22,22, `BGEU);
    operation_check(22,222, `BGEU);
    
    $stop;
end


// tasks

task operation_check;       
  input [31:0] a, b;
  input [4:0] option;  
  
  reg [31:0] expected_result;
  reg expected_flag;
  
  // определение ожидаемых значений 
  case (option)
        `ADD: begin expected_result = a + b; expected_flag = 0; end
        `SUB: begin expected_result = a - b; expected_flag = 0; end
        `SLL: begin expected_result = a << b; expected_flag = 0; end
        `SLT: begin expected_result = $signed(a < b); expected_flag = 0; end
        `SLTU: begin expected_result = a < b; expected_flag = 0; end
        `XOR: begin expected_result = a ^ b; expected_flag = 0; end        
        `SRL: begin expected_result = a >> b; expected_flag = 0; end
        `SRA: begin expected_result = $signed(A) >>> b; expected_flag = 0; end
        `OR: begin expected_result = a | b; expected_flag = 0; end
        `AND: begin expected_result = a & b; expected_flag = 0; end
        `BEQ: begin expected_result = 0; expected_flag = (a == b); end
        `BNE: begin expected_result = 0; expected_flag = (a != b); end
        `BLT: begin expected_result = 0; expected_flag = $signed(a < b); end
        `BGE: begin expected_result = 0; expected_flag = $signed(a >= b); end
        `BLTU: begin expected_result = 0; expected_flag = (a < b); end
        `BGEU: begin expected_result = 0; expected_flag = (a >= b); end
        default: expected_flag = 0;      
    endcase
  // подсчет с помощью АЛУ и сравнение 
  begin
    A = a; 
    B = b;
    ALUOp = option;
    
    #10;
           
    if (expected_result == Result && expected_flag == Flag)    
      $display("PASS");
    else                                        
      $display("FAIL");    
  end
endtask

endmodule
