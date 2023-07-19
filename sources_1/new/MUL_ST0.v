`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 21:55:46
// Design Name: 
// Module Name: MUL_ST0
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

module MUL_ST0(
    input [`WORD-1:0] src0,
    input [`WORD-1:0] src1,
    output sign,
    output [`WORD-1:0] mul00, mul01, mul10//, mul11
    );

    assign sign = src0[31] ^ src1[31];
    assign mul00 = src1[15: 0] * src0[15: 0];
    assign mul01 = src1[15: 0] * src0[31:16];
    assign mul10 = src1[31:16] * src0[15: 0];
    //assign mul11 = src1[31:16] * src0[31:16];

endmodule
