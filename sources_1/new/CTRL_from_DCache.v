`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 17:25:27
// Design Name: 
// Module Name: CTRL_from_DCache
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

module CTRL_from_DCache(
    input [`WORD-1:0] inst,
    input DCache_ready,
    output stall_from_DCache,
    output flush_from_DCache
    );

    wire DCache_valid = 
        (inst[31:24] == 8'b00101000) ||  // Load
        (inst[31:24] == 8'b00101001);    // Store

    assign stall_from_DCache = ~DCache_ready & DCache_valid;
    assign flush_from_DCache = ~DCache_ready & DCache_valid;

endmodule