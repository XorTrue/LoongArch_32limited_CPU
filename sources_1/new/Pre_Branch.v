`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 17:38:29
// Design Name: 
// Module Name: Pre_Branch
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

module Pre_Branch(
    input predict,
    input [`WORD-1:0] PC,
    input ICache_ready,
    input [`WORD-1:0] inst,
    output Pre_Branch_out,
    output [`WORD-1:0] Pre_PC_out
    );

    /*assign Pre_Branch_out = 
        ICache_ready & 
        ( (predict & (inst[31:30] == 2'b01)) |
          (inst[31:27] == 5'b01010) | 
          (inst[31:28] == 4'b0100 ) );*/
    assign Pre_Branch_out = 0;

    wire offs = (inst[31:27] == 5'b01010) ? 
                    { {15{inst[25]}}, inst[24:10], 2'b00 } :
                    { { 5{inst[ 9]}}, inst[ 8: 0], inst[25: 10], 2'b00 } ;

    assign Pre_PC_out = PC + offs;

endmodule
