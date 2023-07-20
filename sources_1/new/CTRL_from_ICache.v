`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 17:25:48
// Design Name: 
// Module Name: CTRL_from_ICache
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


module CTRL_from_ICache(
    input clk, rst,
    input ICache_valid, ICache_ready,
    output reg IF0_IF1_stall_from_ICache,
    output reg IF1_ID_flush_from_ICache,
    output reg PC_stall_from_ICache
    );

    always@(posedge clk)
    begin
        if(rst)
        begin
            { IF0_IF1_stall_from_ICache, 
              IF1_ID_flush_from_ICache, 
              PC_stall_from_ICache } <= 3'b000;
        end
        else
        begin
            if(~ICache_valid | ICache_ready)
            begin
                { IF0_IF1_stall_from_ICache, 
                  IF1_ID_flush_from_ICache, 
                  PC_stall_from_ICache } <= 3'b000;
            end
            else
            begin
                { IF0_IF1_stall_from_ICache, 
                  IF1_ID_flush_from_ICache, 
                  PC_stall_from_ICache } <= 3'b111;
            end
        end
    end

endmodule
