`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 22:15:50
// Design Name: 
// Module Name: MUL_ST1
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

module MUL_ST1(
    input sign,
    input [`WORD-1:0] mul00, mul01, mul10, //mul11,
    output [`WORD-1:0] mul_res
    );

    wire [`HALF-1:0] tmp0 = mul01[15:0] + mul10[15:0];
    wire [`WORD-1:0] tmp1 = mul00 + {tmp0, 16'h0};
    assign mul_res = sign ? -tmp1 : tmp1;

endmodule
