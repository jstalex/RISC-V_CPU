`include "defines_riscv.v"

module miriscv_lsu (
    input clk_i,  

    // core protocol
    input [`WORD_LEN-1:0] lsu_addr_i,  // запрашиваемый адрес
    input lsu_we_i,  // разрешение записи
    input [1:0] lsu_size_i,  // для выбора размера записи
    input [`WORD_LEN-1:0] lsu_data_i, // wd write data (RD2)
    input logic lsu_req_i,  // обращение к памяти
    output logic lsu_stall_req_o,  // подключен напрямую к en_pc
    output logic [`WORD_LEN-1:0] lsu_data_o,  // rd считанные данные

    // memory protocol
    input [`WORD_LEN-1:0] data_rdata_i,  // RD RAM данный из памяти
    output logic data_req_o, // обращение
    output data_we_o,  // WE разрешение записи
    output logic [3:0] data_be_o, // к каким байтам идет обращение 1-1111 
    output logic [`WORD_LEN-1:0] data_addr_o,  // адрес
    output logic [`WORD_LEN-1:0] data_wdata_o  // WD RAM данные для записи
);

assign data_addr_o = lsu_addr_i;

logic [1:0] offset;
assign offset = data_addr_o[1:0];

// data_req_o and data_we_o нужно поднять на 1 такт для записи/чтения
// by IlORDash
logic toggle_stall;
  always_ff @(posedge clk_i) begin
    if (lsu_req_i) begin
      toggle_stall <= ~toggle_stall;
    end else begin
      toggle_stall <= 1'b0;
    end
end
assign lsu_stall_req_o = lsu_req_i ^ toggle_stall;

assign data_req_o = lsu_stall_req_o; 
assign data_we_o = lsu_we_i && data_req_o;

// core to lsu interface
always_comb begin
    if (lsu_req_i)begin // если обращаемся
        if (lsu_we_i) begin // запись 
            if (data_we_o) data_wdata_o <= lsu_data_i << (offset * 8);
            else data_wdata_o <= 32'b0;
        end else begin // чтение
            case(lsu_size_i)
                `LDST_B: lsu_data_o <= {{(`WORD_LEN - 8) {data_rdata_i[7]}}, data_rdata_i[7:0]};
                `LDST_H: lsu_data_o <= {{(`WORD_LEN - 16) {data_rdata_i[15]}}, data_rdata_i[15:0]};
                `LDST_W: lsu_data_o <= data_rdata_i;
                `LDST_BU: lsu_data_o <= {24'b0, data_rdata_i[7:0]};
                `LDST_HU: lsu_data_o <= {16'b0, data_rdata_i[15:0]};
                default: lsu_data_o <= 32'b0;
            endcase    
        end
    end
end

// memory to lsu interface

always_comb begin
    case (offset)
      2'b00: begin
        if ((lsu_size_i == `LDST_B) || (lsu_size_i == `LDST_BU)) data_be_o <= 4'b0001;
        else if ((lsu_size_i == `LDST_H) || (lsu_size_i == `LDST_HU)) data_be_o <= 4'b0011;
        else if (lsu_size_i == `LDST_W) data_be_o <= 4'b1111;
      end
      2'b01: begin
        if ((lsu_size_i == `LDST_B) || (lsu_size_i == `LDST_BU)) data_be_o <= 4'b0010;
        else if ((lsu_size_i == `LDST_H) || (lsu_size_i == `LDST_HU)) data_be_o <= 4'b0110;
      end
      2'b10: begin
        if ((lsu_size_i == `LDST_B) || (lsu_size_i == `LDST_BU)) data_be_o <= 4'b0100;
        else if ((lsu_size_i == `LDST_H) || (lsu_size_i == `LDST_HU)) data_be_o <= 4'b1100;
      end
      2'b11: if ((lsu_size_i == `LDST_B) || (lsu_size_i == `LDST_BU)) data_be_o <= 4'b1000;
      default: data_be_o <= 4'b1111;
    endcase
end

endmodule







