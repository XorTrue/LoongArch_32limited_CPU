`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/16 16:16:53
// Design Name: 
// Module Name: decoder
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

module decoder(
    input [`WORD-1:0] inst,
    output reg [`OPCODE_LEN-1:0] ALU_opcode,
    output reg [`OPCODE_LEN-1:0] CMP_opcode
    );
endmodule
