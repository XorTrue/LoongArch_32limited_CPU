`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 21:32:53
// Design Name: 
// Module Name: MEM
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

module MEM(
    input clk, rst,
    input CAL_SEL,
    input [`WORD-1:0] ALU_res,
    input [`WORD-1:0] MUL_res,


    output [`WORD-1:0] CAL_res
    );


    SEL_2 ALU_or_MUL(
        .sel(CAL_SEL),
        .in0(ALU_res),
        .in1(MUL_res),
        .out(CAL_res)
    );

endmodule
