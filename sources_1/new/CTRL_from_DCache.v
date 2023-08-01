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
    input DCache_valid,
    input DCache_ready,
    output stall_from_DCache,
    output flush_from_DCache
    );

    assign stall_from_DCache = DCache_valid & ~DCache_ready ;
    assign flush_from_DCache = DCache_valid & ~DCache_ready ;

endmodule