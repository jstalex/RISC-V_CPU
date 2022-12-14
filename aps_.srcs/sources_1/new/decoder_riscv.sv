`timescale 1ns / 1ps
// `include "defines_riscv.v"

module decoder_riscv (
  input logic   [31:0]  fetched_instr_i,
  output  logic [1:0]   ex_op_a_sel_o,      // выходы сделаны регистрами,
  output  logic [2:0]   ex_op_b_sel_o,      // потому что всё устройство 
  output  logic [4:0]   alu_op_o,           // будет комбинационной схемой
  output  logic         mem_req_o,          // описанной внутри блока 
  output  logic         mem_we_o,           // always, а слева от знака равно
  output  logic [2:0]   mem_size_o,         // внутри always должны стоять
  output  logic         gpr_we_a_o,         // всегда только регистры,
  output  logic         wb_src_sel_o,       // даже если в итоге схема
  output  logic         illegal_instr_o,    // превратится в
  output  logic         branch_o,           // комбинационно устройство
  output  logic         jal_o,              // без памяти
  output  logic         jalr_o           
);

always_comb begin
    if (fetched_instr_i[1:0] == 2'b11 && fetched_instr_i != 7'b1110011) begin
        ex_op_a_sel_o <= 0;
        ex_op_b_sel_o <= 0;
        alu_op_o <= 0;
        mem_req_o <= 0;
        mem_we_o <= 0;
        mem_size_o <= 0;
        gpr_we_a_o <= 0;
        wb_src_sel_o <= 0;
        illegal_instr_o <= 0;
        branch_o <= 0;
        jal_o <= 0;
        jalr_o <= 0;
        
        case (fetched_instr_i[`INSTR_OPCODE])
            //R-type
            `OP_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_RS1;
                ex_op_b_sel_o <= `OP_B_RS2;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_EX_RESULT;
                
                case (fetched_instr_i[`R_TYPE_FUNCT_3])
                    `OP_FUNCT_3_ADD_SUB: begin
                        case (fetched_instr_i[`R_TYPE_FUNCT_7])
                            `OP_FUNCT_7_ADD: alu_op_o <= `ALU_ADD;
                            `OP_FUNCT_7_SUB: alu_op_o <= `ALU_SUB;
                            default: illegal_instr_o <= 1'b1;
                        endcase
                    end
                    
                    `OP_FUNCT_3_XOR: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_XOR)
                            alu_op_o <= `ALU_XOR;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_FUNCT_3_OR: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_OR)
                            alu_op_o <= `ALU_OR;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_FUNCT_3_AND: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_AND)
                            alu_op_o <= `ALU_AND;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_FUNCT_3_SLL: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_SLL)
                            alu_op_o <= `ALU_SLL;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_FUNCT_3_SRL_SRA: begin
                        case (fetched_instr_i[`R_TYPE_FUNCT_7])
                            `OP_FUNCT_7_SRL: alu_op_o <= `ALU_SRL;
                            `OP_FUNCT_7_SRA: alu_op_o <= `ALU_SRA;
                            default: illegal_instr_o <= 1'b1;
                        endcase
                    end
                    
                    `OP_FUNCT_3_SLT: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_SLT)
                            alu_op_o <= `ALU_SLTS;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_FUNCT_3_SLTU: begin
                        if (fetched_instr_i[`R_TYPE_FUNCT_7] == `OP_FUNCT_7_SLTU)
                            alu_op_o <= `ALU_SLTU;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    default: illegal_instr_o <= 1'b1;
                endcase
            end
            
            //I-type
            `OP_IMM_OPCODE: begin
            
                //values defaults
                ex_op_a_sel_o <= `OP_A_RS1;
                ex_op_b_sel_o <= `OP_B_IMM_I;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_EX_RESULT;
                
                case (fetched_instr_i[`I_TYPE_FUNCT_3])
                    `OP_IMM_FUNCT_3_ADDI: alu_op_o <= `ALU_ADD;
                    `OP_IMM_FUNCT_3_XORI: alu_op_o <= `ALU_XOR;
                    `OP_IMM_FUNCT_3_ORI: alu_op_o <= `ALU_OR;
                    `OP_IMM_FUNCT_3_ANDI: alu_op_o <= `ALU_AND;
                    
                    `OP_IMM_FUNCT_3_SLLI: begin
                        if (fetched_instr_i[`I_TYPE_ALT_FUNCT_7] == `OP_IMM_FUNCT_7_SLLI)
                            alu_op_o <= `ALU_SLL;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_IMM_FUNCT_3_SRLI: begin
                        if (fetched_instr_i[`I_TYPE_ALT_FUNCT_7] == `OP_IMM_FUNCT_7_SRLI)
                            alu_op_o <= `ALU_SRL;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_IMM_FUNCT_3_SRAI: begin
                        if (fetched_instr_i[`I_TYPE_ALT_FUNCT_7] == `OP_IMM_FUNCT_7_SRAI)
                            alu_op_o <= `ALU_SRA;
                        else
                            illegal_instr_o <= 1'b1;
                    end
                    
                    `OP_IMM_FUNCT_3_SLTI: alu_op_o <= `ALU_SLTS;
                    `OP_IMM_FUNCT_3_SLTIU: alu_op_o <= `ALU_SLTU;
                    default: illegal_instr_o <= 1'b1;
                endcase
            end
            
            //I-type.2
            `LOAD_OPCODE: begin
            
                //values defaults
                ex_op_a_sel_o <= `OP_A_RS1;
                ex_op_b_sel_o <= `OP_B_IMM_I;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_LSU_DATA;
                mem_req_o <= 1'b1;
                mem_we_o <= 1'b0;
                
                case (fetched_instr_i[`I_TYPE_FUNCT_3])
                    `LOAD_FUNCT_3_LB: mem_size_o <= `LDST_B;
                    `LOAD_FUNCT_3_LH: mem_size_o <= `LDST_H;
                    `LOAD_FUNCT_3_LW: mem_size_o <= `LDST_W;
                    `LOAD_FUNCT_3_LBU: mem_size_o <= `LDST_BU;
                    `LOAD_FUNCT_3_LHU: mem_size_o <= `LDST_HU;
                    default: illegal_instr_o <= 1'b1;
                endcase
            end
            
            //S-type
            `STORE_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_RS1;
                ex_op_b_sel_o <= `OP_B_IMM_S;
                mem_req_o <= 1'b1;
                mem_we_o <= 1'b1;
                
                case (fetched_instr_i[`S_TYPE_FUNCT_3])
                    `STORE_FUNCT_3_SB: mem_size_o <= `LDST_B;
                    `STORE_FUNCT_3_SH: mem_size_o <= `LDST_H;
                    `STORE_FUNCT_3_SW: mem_size_o <= `LDST_W;
                    default: illegal_instr_o <= 1'b1;
                endcase
            end
            
            //B-type
            `BRANCH_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_RS1;
                ex_op_b_sel_o <= `OP_B_RS2;
                branch_o <= 1'b1;
                
                case (fetched_instr_i[`B_TYPE_FUNCT_3])
                    `BRANCH_FUNCT_3_BEQ: alu_op_o <= `ALU_EQ;
                    `BRANCH_FUNCT_3_BNE: alu_op_o <= `ALU_NE;
                    `BRANCH_FUNCT_3_BLT: alu_op_o <= `ALU_LTS;
                    `BRANCH_FUNCT_3_BGE: alu_op_o <= `ALU_GES;
                    `BRANCH_FUNCT_3_BLTU: alu_op_o <= `ALU_LTU;
                    `BRANCH_FUNCT_3_BGEU: alu_op_o <= `ALU_GEU;
                    default: illegal_instr_o <= 1'b1;
                endcase
            end
            
            //J-type
            `JAL_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_CURR_PC;
                ex_op_b_sel_o <= `OP_B_INCR;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_EX_RESULT;
                alu_op_o <= `ALU_ADD;
                jal_o <= 1'b1;
            end
            
            //I-type.3
            `JALR_OPCODE: begin
                if (fetched_instr_i[`I_TYPE_FUNCT_3] == `JALR_FUNCT_3_SLTU) begin
                    //values defaults
                    ex_op_a_sel_o <= `OP_A_CURR_PC;
                    ex_op_b_sel_o <= `OP_B_INCR;
                    gpr_we_a_o <= 1'b1;
                    wb_src_sel_o <= `WB_EX_RESULT;
                    alu_op_o <= `ALU_ADD;
                    jalr_o <= 1'b1;
                end
                else
                    illegal_instr_o <= 1'b1;
            end
            
            //U-type
            `LUI_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_ZERO;
                ex_op_b_sel_o <= `OP_B_IMM_U;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_EX_RESULT;
                alu_op_o <= `ALU_ADD;
            end
            
            //U-type.2
            `AUIPC_OPCODE: begin
                //values defaults
                ex_op_a_sel_o <= `OP_A_CURR_PC;
                ex_op_b_sel_o <= `OP_B_IMM_U;
                gpr_we_a_o <= 1'b1;
                wb_src_sel_o <= `WB_EX_RESULT;
                alu_op_o <= `ALU_ADD;
            end
            //I-type.4
            `SYSTEM_OPCODE: illegal_instr_o <= 1'b0;
            `MISC_MEM_OPCODE:illegal_instr_o <= 1'b0;
            default: illegal_instr_o <= 1'b1;
        endcase
    end
    else
        illegal_instr_o <= 1'b1;
end
endmodule