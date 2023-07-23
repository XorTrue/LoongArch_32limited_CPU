`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 17:21:58
// Design Name: 
// Module Name: IF1
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

module IF1(
    input predict,
    input [`WORD-1:0] IF1_PC_in,
    input [`WORD-1:0] inst,

    input ICache_valid, ICache_ready,

    output Pre_Branch_out,
    output [`WORD-1:0] Pre_PC_out,

    output PC_stall_from_ICache,
    output IF1_ID_flush_from_ICache
    );

    CTRL_from_ICache CTRL_from_ICache(
        .ICache_valid(ICache_valid),
        .ICache_ready(ICache_ready),
        .IF1_ID_flush_from_ICache(IF1_ID_flush_from_ICache),
        .PC_stall_from_ICache(PC_stall_from_ICache)
    );

    Pre_Branch Pre_Branch(
        .predict(predict),
        .PC(IF1_PC_in),
        .ICache_ready(ICache_ready),
        .inst(inst),
        .Pre_Branch_out(Pre_Branch_out),
        .Pre_PC_out(Pre_PC_out)
    );
    
endmodule
