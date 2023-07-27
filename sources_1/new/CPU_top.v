`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 17:14:58
// Design Name: 
// Module Name: CPU_top
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

module CPU_top(
    input clk, rst
    );

    wire Pre_Branch, EX_Branch;
    wire [`WORD-1:0] Pre_PC, EX_PC;
    wire PC_stall_from_ICache;
    wire PC_stall_from_DCache;
    wire [`WORD-1:0] PC_IF0;
    IF0 IF0(
        .clk(clk), .rst(rst),
        .Pre_Branch(Pre_Branch), 
        .Pre_PC(Pre_PC), 
        .EX_Branch(EX_Branch), 
        .EX_PC(EX_PC), 
        .PC_stall_from_ICache(PC_stall_from_ICache), 
        .PC_stall_from_DCache(PC_stall_from_DCache), 
        .PC_out(PC_IF0)
    );

    wire [`WORD-1:0] PC_IF1;
    wire ICache_valid;
    IF0_IF1 IF0_IF1(
        .clk(clk), .rst(rst),
        .IF0_IF1_PC_in(PC_IF0), 
        .IF0_IF1_PC_out(PC_IF1), 
        .ICache_valid_in(1),
        .ICache_valid_out(ICache_valid)
    );

    wire ICache_ready;
    wire [`WORD-1:0] inst_ICache;
    ICache ICache(

    );

    wire predict;
    Predict_2bit Predict_2bit(
        .clk(clk), .rst(rst),
        .EX_Branch(EX_Branch),
        .predict_out(predict)
    );
    

    wire IF1_ID_flush_from_ICache;
    IF1 IF1(
        .predict(predict), 
        .IF1_PC_in(PC_IF1),
        .inst(inst_ICache),
        .ICache_valid(ICache_valid), .ICache_ready(ICache_ready),
        .Pre_Branch_out(Pre_Branch), 
        .Pre_PC_out(Pre_PC),
        .PC_stall_from_ICache(PC_stall_from_ICache),
        .IF1_ID_flush_from_ICache(IF1_ID_flush_from_ICache)
    );

    wire IF1_ID_stall_from_DCache;
    wire IF1_ID_flush_from_EX_Branch;
    wire [`WORD-1:0] PC_ID;
    wire [`WORD-1:0] inst_ID;
    IF1_ID IF1_ID(
        .clk(clk), .rst(rst),
        .IF1_ID_stall_from_DCache(IF1_ID_stall_from_DCache),
        .IF1_ID_flush_from_EX_Branch(IF1_ID_flush_from_EX_Branch),
        .IF1_ID_flush_from_ICache(~ICache_ready),
        .IF1_ID_flush_from_Pre_Branch(Pre_Branch),
        .IF1_ID_PC_in(PC_IF1),
        .IF1_ID_PC_out(PC_ID),
        .IF1_ID_inst_in(inst_ICache),
        .IF1_ID_inst_out(inst_ID)
    );

    wire REG_write;
    wire [`REG_LOG-1:0] REG_write_addr;
    wire [`WORD-1:0] REG_write_data;
    wire [`OPCODE_LEN*2-1:0] opcode;
    wire [7:0] CTRL_EX;
    wire [14:0] rs;
    wire [`WORD*3-1:0] src;
    wire [`WORD*2-1:0] CONST;
    ID ID(
        .clk(clk), .rst(rst),
        .inst(inst_ID),
        .REG_write(REG_write), 
        .REG_write_addr(REG_write_addr), 
        .REG_write_data(REG_write_data),
        .opcode(opcode),
        .CTRL_EX(CTRL_EX),
        .rs(rs),
        .src(src),
        .CONST(CONST)
    );
    

    wire ID_EX_stall_from_DCache;
    wire ID_EX_flush_from_EX_Branch;
    wire [`WORD-1:0] PC_EX;
    wire [`WORD-1:0] inst_EX;
    wire [`OPCODE_LEN*2-1:0] opcode_EX;
    wire [7:0] CTRL_EX_EX;
    wire [14:0] rs_EX;
    wire [`WORD*3-1:0] src_EX;
    wire [`WORD*2-1:0] CONST_EX;
    ID_EX ID_EX(
        .clk(clk), .rst(rst),
        .ID_EX_stall_from_DCache(ID_EX_stall_from_DCache),
        .ID_EX_flush_from_EX_Branch(ID_EX_flush_from_EX_Branch),
        .ID_EX_PC_in(PC_ID),
        .ID_EX_PC_out(PC_EX),
        .ID_EX_inst_in(inst_ID),
        .ID_EX_inst_out(inst_EX),
        .ID_EX_opcode_in(opcode),
        .ID_EX_opcode_out(opcode_EX),
        .ID_EX_CTRL_EX_in(CTRL_EX),
        .ID_EX_CTRL_EX_out(CTRL_EX_EX),
        .ID_EX_rs_in(rs),
        .ID_EX_rs_out(rs_EX),
        .ID_EX_src_in(src),
        .ID_EX_src_out(src_EX),
        .ID_EX_CONST_in(CONST),
        .ID_EX_CONST_out(CONST_EX)
    );

    wire CAL_MUL;
    wire [`WORD-1:0] ALU_res;
    wire [`WORD*2-1:0] src_fwd;
    EX EX(
        .clk(clk), .rst(rst),
        .PC(PC_EX),
        .opcode(opcode_EX),
        .CTRL_EX(CTRL_EX_EX),
        .rs(rs_EX),
        .src(src_EX),
        .CONST(CONST_EX),
        .fwd(),
        .src_from_MEM(),
        .src_from_WB(),
        .predict(predict),
        .EX_Branch_out(EX_Branch),
        .EX_PC_out(EX_PC),
        .CAL_MUL(CAL_MUL),
        .ALU_out(ALU_res),
        .src_fwd(src_fwd)
    );

    wire [`WORD-1:0] src1_fwd, src2_fwd;
    assign {src1_fwd, src2_fwd} = src_fwd;
    wire sign;
    wire [`WORD-1:0] mul00, mul01, mul10;
    MUL_ST0 MUL_ST0(
        .src0(src1_fwd),
        .src1(src2_fwd),
        .sign(sign),
        .mul00(mul00),
        .mul01(mul01),
        .mul10(mul10)
    );

    wire [`WORD-1:0] PC_MEM;
    wire [`WORD-1:0] inst_MEM;
    wire [7:0] CTRL_EX_MEM;
    wire CAL_SEL;
    wire [`WORD-1:0] ALU_res_MEM;
    wire [14:0] rs_MEM;
    EX_MEM EX_MEM(
        .clk(clk), .rst(rst),
        .EX_MEM_PC_in(PC_EX),
        .EX_MEM_PC_out(PC_MEM),
        .EX_MEM_inst_in(inst_EX),
        .EX_MEM_inst_out(inst_MEM),
        .EX_MEM_CTRL_EX_in(CTRL_EX_EX),
        .EX_MEM_CTRL_EX_out(CTRL_EX_MEM),
        .CAL_SEL_in(CAL_MUL),
        .CAL_SEL_out(CAL_SEL),
        .ALU_res_in(ALU_res),
        .ALU_res_out(ALU_res_MEM),
        .EX_MEM_rs_in(rs_EX),
        .EX_MEM_rs_out(rs_MEM)
    );

    wire [`WORD-1:0] mul_res;
    MUL_ST1 MUL_ST1(
        .sign(sign),
        .mul00(mul00),
        .mul01(mul01),
        .mul10(mul10),
        .mul_res(mul_res)
    );

    wire [`WORD-1:0] CAL_res;
    MEM MEM(
        .clk(clk), .rst(rst),
        .CAL_SEL(CAL_SEL),
        .ALU_res(ALU_res_MEM),
        .MUL_res(mul_res),
        .CAL_res(CAL_res)
    );



endmodule
