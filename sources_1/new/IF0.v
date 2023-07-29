`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 16:45:34
// Design Name: 
// Module Name: IF0
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

module IF0(
    input clk, rst,
    input Pre_Branch,
    input [`WORD-1:0] Pre_PC,
    input EX_Branch,
    input [`WORD-1:0] EX_PC, 
    input PC_stall_from_ICache,
    input PC_stall_from_Load,
    input PC_stall_from_DCache,
    output [`WORD-1:0] PC_out
    );

    wire [`WORD-1:0] PC_in;
    NPC NPC(
        .PC(PC_out),
        .Pre_Branch(Pre_Branch),
        .Pre_PC(Pre_PC),
        .EX_Branch(EX_Branch),
        .EX_PC(EX_PC),
        .NPC(PC_in)
    );

    wire PC_stall = PC_stall_from_ICache | PC_stall_from_Load | PC_stall_from_DCache;
    PC PC(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_in),
        .PC_stall(PC_stall),
        .PC_out(PC_out)
    );

endmodule
