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
    output flush_from_ICache,
    output stall_from_ICache
    );

    assign stall_from_ICache = ~ICache_ready & ICache_valid;
    assign flush_from_ICache = ~ICache_ready & ICache_valid;
    

endmodule
