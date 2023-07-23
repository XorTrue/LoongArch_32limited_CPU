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
    input ICache_valid, ICache_ready,
    output IF1_ID_flush_from_ICache,
    output PC_stall_from_ICache
    );

    assign  { IF1_ID_flush_from_ICache, 
              PC_stall_from_ICache } = 
                (~ICache_valid | ICache_ready) ?
                    2'b00 : 2'b11;

endmodule
