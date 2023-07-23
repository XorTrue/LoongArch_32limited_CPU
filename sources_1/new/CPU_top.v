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
        .is_branch(), .branch(),
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




endmodule
