`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 19:54:06
// Design Name: 
// Module Name: EX_Branch
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

module EX_Branch(
    input is_branch,
    input branch,
    input predict,
    output EX_Branch_out,
    input [`WORD-1:0] PC_EX,
    input [`WORD-1:0] PC_Branch,
    output [`WORD-1:0] EX_PC_out
    );

    assign EX_Branch_out = is_branch & (branch ^ predict);
    assign EX_PC_out = predict ? PC_Branch : PC_EX + 32'h4;

endmodule
