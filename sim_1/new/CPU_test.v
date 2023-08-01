`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 10:18:37
// Design Name: 
// Module Name: CPU_test
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
`include "D:/XorTrue/LoongArch/Project/Project.srcs/sources_1/new/CPU_Parameter.vh"

module CPU_test(

    );

    reg clk = 0;
    reg rst = 1;
    initial 
        forever
            #5 clk = ~clk;

    initial
    begin
        #10 rst = 0;
    end

    wire [`WORD-1:0] PC_IF0_out;
    wire [`WORD-1:0] PC_IF1_out;
    wire [`WORD-1:0] inst_IF1_out;
    wire [`WORD-1:0] PC_ID_out;
    wire [`WORD-1:0] inst_ID_out;
    wire [`WORD-1:0] PC_EX_out;
    wire [`WORD-1:0] inst_EX_out;
    wire [`WORD-1:0] PC_MEM_out;
    wire [`WORD-1:0] inst_MEM_out;
    wire [`WORD-1:0] PC_WB_out;
    wire [`WORD-1:0] inst_WB_out;
    wire Pre_Branch;
    wire [`WORD-1:0] Pre_PC;
    wire EX_Branch;
    wire [`WORD-1:0] EX_PC;
    CPU_top CPU_top(
        .clk(clk), .rst(rst),
        .PC_IF0_out(PC_IF0_out),
        .Pre_Branch_out(Pre_Branch),
        .Pre_PC_out(Pre_PC),
        .EX_Branch_out(EX_Branch),
        .EX_PC_out(EX_PC),
        .PC_IF1_out(PC_IF1_out),
        .inst_IF1_out(inst_IF1_out),
        .PC_ID_out(PC_ID_out),
        .inst_ID_out(inst_ID_out),
        .PC_EX_out(PC_EX_out),
        .inst_EX_out(inst_EX_out),
        .PC_MEM_out(PC_MEM_out),
        .inst_MEM_out(inst_MEM_out),
        .PC_WB_out(PC_WB_out),
        .inst_WB_out(inst_WB_out)
    );

endmodule
