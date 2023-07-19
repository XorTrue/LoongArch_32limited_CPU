`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 17:07:40
// Design Name: 
// Module Name: SEL_2
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

module SEL_2(
    input sel,
    input [`WORD-1:0] in0,
    input [`WORD-1:0] in1,
    output wire [`WORD-1:0] out
    );
    
    assign out = sel ? in1 : in0;

endmodule
