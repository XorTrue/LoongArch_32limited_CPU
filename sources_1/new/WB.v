`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/29 21:02:22
// Design Name: 
// Module Name: WB
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

module WB(
    input [`WORD-1:0] PC,
    input [`WORD-1:0] inst,
    input [7:0] CTRL_EX,
    input [`REG_LOG*3-1:0] rs,
    input [`WORD-1:0] CAL_res,
    input [`WORD-1:0] data,
    output REG_write_WB,
    output [`REG_LOG-1:0] rd,
    output [`WORD-1:0] WB_data
    );
    

    assign rd = rs[4:0];

    wire [1:0] REG_WB;
    wire [1:0] MEM;
    wire [3:0] EX;
    assign {REG_WB, MEM, EX} = CTRL_EX;
    wire RES_MUX;
    assign {REG_write_WB, RES_MUX} = REG_WB;
    assign WB_data = RES_MUX ? data : CAL_res;

endmodule
