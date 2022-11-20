//new defines from github
// new alu codes
`define RESET_ADDR 32'h00000000

`define ALU_OP_WIDTH  5

`define ALU_ADD   5'b00000
`define ALU_SUB   5'b01000

`define ALU_XOR   5'b00100
`define ALU_OR    5'b00110
`define ALU_AND   5'b00111

// shifts
`define ALU_SRA   5'b01101
`define ALU_SRL   5'b00101
`define ALU_SLL   5'b00001

// comparisons
`define ALU_LTS   5'b11100
`define ALU_LTU   5'b11110
`define ALU_GES   5'b11101
`define ALU_GEU   5'b11111
`define ALU_EQ    5'b11000
`define ALU_NE    5'b11001

// set lower than operations
`define ALU_SLTS  5'b00010
`define ALU_SLTU  5'b00011

// opcodes
`define LOAD_OPCODE      5'b00_000
`define MISC_MEM_OPCODE  5'b00_011
`define OP_IMM_OPCODE    5'b00_100
`define AUIPC_OPCODE     5'b00_101
`define STORE_OPCODE     5'b01_000
`define OP_OPCODE        5'b01_100
`define LUI_OPCODE       5'b01_101
`define BRANCH_OPCODE    5'b11_000
`define JALR_OPCODE      5'b11_001
`define JAL_OPCODE       5'b11_011
`define SYSTEM_OPCODE    5'b11_100

// dmem type load store
`define LDST_B           3'b000
`define LDST_H           3'b001
`define LDST_W           3'b010
`define LDST_BU          3'b100
`define LDST_HU          3'b101

// operand a selection
`define OP_A_RS1         2'b00
`define OP_A_CURR_PC     2'b01
`define OP_A_ZERO        2'b10

// operand b selection
`define OP_B_RS2         3'b000
`define OP_B_IMM_I       3'b001
`define OP_B_IMM_U       3'b010
`define OP_B_IMM_S       3'b011
`define OP_B_INCR        3'b100

// writeback source selection
`define WB_EX_RESULT     1'b0
`define WB_LSU_DATA      1'b1   

//----------------------------//

`define INSTR_OPCODE 6:2 

//R-type
`define R_TYPE_FUNCT_7 31:25
`define R_TYPE_RS_2 24:20
`define R_TYPE_RS_1 19:15
`define R_TYPE_FUNCT_3 14:12
`define R_TYPE_RD 11:7



//I-type
`define I_TYPE_IMM 31:20
`define I_TYPE_RS_1 19:15
`define I_TYPE_FUNCT_3 14:12
`define I_TYPE_RD 11:7

`define I_TYPE_ALT_FUNCT_7 31:25
//`define I_TYPE_ALT_RS_2 24:20 //shamt


//S-type
`define S_TYPE_IMM_11_5 31:25
`define S_TYPE_RS_2 24:20
`define S_TYPE_RS_1 19:15
`define S_TYPE_FUNCT_3 14:12
`define S_TYPE_IMM_4_0 11:7

//B-type
`define B_TYPE_IMM_12 31
`define B_TYPE_IMM_10_5 30:25
`define B_TYPE_RS_2 24:20
`define B_TYPE_RS_1 19:15
`define B_TYPE_FUNCT_3 14:12
`define B_TYPE_IMM_4_1 11:8
`define B_TYPE_IMM_11 7

//U-type
`define U_TYPE_IMM_31_12 31:12
`define U_TYPE_RD 11:7

//J-type
`define J_TYPE_IMM_20 31
`define J_TYPE_IMM_10_1 30:21
`define J_TYPE_IMM_11 20
`define J_TYPE_IMM_19_12 19:12
`define J_TYPE_RD 11:7

//----------------------------//

//VALUES OF OPCODES

//R-type
`define OP_OPCODE 5'b01_100

`define OP_FUNCT_3_ADD_SUB 3'h0
`define OP_FUNCT_3_XOR 3'h4
`define OP_FUNCT_3_OR 3'h6
`define OP_FUNCT_3_AND 3'h7
`define OP_FUNCT_3_SLL 3'h1
`define OP_FUNCT_3_SRL_SRA 3'h5
`define OP_FUNCT_3_SLT 3'h2
`define OP_FUNCT_3_SLTU 3'h3

`define OP_FUNCT_7_ADD 7'h00
`define OP_FUNCT_7_SUB 7'h20
`define OP_FUNCT_7_XOR 7'h00
`define OP_FUNCT_7_OR 7'h00
`define OP_FUNCT_7_AND 7'h00
`define OP_FUNCT_7_SLL 7'h00
`define OP_FUNCT_7_SRL 7'h00
`define OP_FUNCT_7_SRA 7'h20
`define OP_FUNCT_7_SLT 7'h00
`define OP_FUNCT_7_SLTU 7'h00

//I-type
`define OP_IMM_OPCODE 5'b00_100

`define OP_IMM_FUNCT_3_ADDI 3'h0
`define OP_IMM_FUNCT_3_XORI 3'h4
`define OP_IMM_FUNCT_3_ORI 3'h6
`define OP_IMM_FUNCT_3_ANDI 3'h7
`define OP_IMM_FUNCT_3_SLLI 3'h1
`define OP_IMM_FUNCT_3_SRLI 3'h5
`define OP_IMM_FUNCT_3_SRAI 3'h5
`define OP_IMM_FUNCT_3_SLTI 3'h2
`define OP_IMM_FUNCT_3_SLTIU 3'h3

`define OP_IMM_FUNCT_7_SLLI 7'h00
`define OP_IMM_FUNCT_7_SRLI 7'h00
`define OP_IMM_FUNCT_7_SRAI 7'h20

//I-type.2
`define LOAD_OPCODE 5'b00_000

`define LOAD_FUNCT_3_LB 3'h0
`define LOAD_FUNCT_3_LH 3'h1
`define LOAD_FUNCT_3_LW 3'h2
`define LOAD_FUNCT_3_LBU 3'h4
`define LOAD_FUNCT_3_LHU 3'h5

//S-type
`define STORE_OPCODE 5'b01_000

`define STORE_FUNCT_3_SB 3'h0
`define STORE_FUNCT_3_SH 3'h1
`define STORE_FUNCT_3_SW 3'h2

//B-type
`define BRANCH_OPCODE 5'b11_000

`define BRANCH_FUNCT_3_BEQ 3'h0
`define BRANCH_FUNCT_3_BNE 3'h1
`define BRANCH_FUNCT_3_BLT 3'h4
`define BRANCH_FUNCT_3_BGE 3'h5
`define BRANCH_FUNCT_3_BLTU 3'h6
`define BRANCH_FUNCT_3_BGEU 3'h7

//J-type
`define JAL_OPCODE 5'b11_011

//I-type.3
`define JALR_OPCODE 5'b11_001

`define JALR_FUNCT_3_SLTU 3'h0

//U-type
`define LUI_OPCODE 5'b01_101

//U-type.2
`define AUIPC_OPCODE 5'b00_101

//I-type.4
`define SYSTEM_OPCODE 5'b11_100

`define MISC_MEM_OPCODE 5'b00_011

//----------------------------//
//FOR DATA_MEMORY

//dmem type load store
`define LDST_B 3'b000
`define LDST_H 3'b001
`define LDST_W 3'b010
`define LDST_BU 3'b100
`define LDST_HU 3'b101

//----------------------------//

// old, updated
`define WORD_LEN 32
`define ALU_OP_NUM 16

`define INSTR_WIDTH 32
`define INSTR_DEPTH 256

`define CONST_LEN 8

`define CONST 12:5
`define WA 11:7
`define RA1 19:15 // new
`define RA2 24:20 // new
`define ALUOp 27:23
`define WS 29:28
`define C 30
`define B 31

