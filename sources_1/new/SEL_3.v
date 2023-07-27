`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 16:59:20
// Design Name: 
// Module Name: SEL_3
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

module SEL_3(
    input [1:0] sel,
    input [`WORD-1:0] in0, in1, in2,
    output reg [`WORD-1:0] out
    );

    always@(*)
    begin
        casex(sel)
            2'b1x: out = in2;
            2'b01: out = in1;
            2'b00: out = in0;
            default: out = 32'h0;
        endcase
    end
    
endmodule
