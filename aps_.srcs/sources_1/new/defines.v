
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

//`define ADD 4'b0000
//`define SUB 4'b0001
//`define SLL 4'b0010
//`define SLT 4'b0011
//`define SLTU 4'b0100
//`define XOR 4'b0101
//`define SRL 4'b0110
//`define SRA 4'b0111
//`define OR 4'b1000
//`define AND 4'b1001
//`define BEQ 4'b1100
//`define BNE 4'b1010
//`define BLT 4'b1011
//`define BGE 4'b1101
//`define BLTU 4'b1110
//`define BGEU 4'b1111

`define WORD_LEN 32

`define ALU_OP_LEN 4
`define ALU_OP_NUM 16

`define INSTR_WIDTH 32
`define INSTR_DEPTH 64

`define CONST_LEN 8

`define CONST 12:5
`define WA 4:0
`define RA1 22:18
`define RA2 17:13
`define ALUOp 27:23
`define WS 29:28
`define C 30
`define B 31

