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


module CTRL_from_DCache(
    input clk, rst,
    input DCache_valid, DCache_ready,
    output IF0_IF1_stall,
    output IF1_ID_flush,
    output PC_stall
    );

    always@(*)
    begin
        
    end

endmodule
