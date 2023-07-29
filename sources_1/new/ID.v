`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 15:45:40
// Design Name: 
// Module Name: ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "CPU_Parameter.vh"

module ID(
    input clk, rst,
    input [`WORD-1:0] inst,
    input REG_write,
    input [`REG_LOG-1:0] REG_write_addr,
    input [`WORD-1:0] REG_write_data,
    output [`OPCODE_LEN*2-1:0] opcode,
    output [7:0] CTRL_EX,
    output [`REG_LOG*3-1:0] rs,
    output [`WORD*3-1:0] src,
    output [`WORD*2-1:0] CONST
    );

    wire [`OPCODE_LEN-1:0] ALU_opcode, CMP_opcode;
    wire [1:0] REG_WB;
    wire [1:0] MEM;
    wire [3:0] EX;
    Decoder Decoder(
        .inst(inst),
        .ALU_opcode(ALU_opcode),
        .CMP_opcode(CMP_opcode),
        .rs(rs),
        .REG_WB(REG_WB),
        .MEM(MEM),
        .EX(EX)
    );
    assign opcode = {ALU_opcode, CMP_opcode};
    assign CTRL_EX = {REG_WB, MEM, EX};
    
    wire [`REG_LOG-1:0] rs0, rs1, rs2;
    assign {rs2, rs1, rs0} = rs;
    wire [`WORD-1:0] src0, src1, src2;
    RF RF(
        .clk(clk), 
        .rst(rst),
        .RFWrite(REG_write),
        .rd(REG_write_addr),
        .rd_WriteData(REG_write_data),
        .rs0(rs0),   .rs1(rs1),   .rs2(rs2),
        .src0(src0), .src1(src1), .src2(src2)
    );
    assign src = {src0, src1, src2};

    wire [`WORD-1:0] IMM, OFFS;
    IMM_OFFS IMM_OFFS(
        .inst(inst),
        .imm(IMM),
        .offs(OFFS)
    );
    assign CONST = {IMM, OFFS};

endmodule
