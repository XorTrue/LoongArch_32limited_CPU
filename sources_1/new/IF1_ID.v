`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:52:47
// Design Name: 
// Module Name: IF1_ID
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

module IF1_ID(
    input clk, rst,

    input IF1_ID_stall_from_DCache,   
    input IF1_ID_flush_from_EX_Branch,
    input IF1_ID_flush_from_ICache,
    input IF1_ID_flush_from_Pre_Branch,
 
    input [`WORD-1:0] IF1_ID_PC_in,
    input [`WORD-1:0] IF1_ID_inst_in,

    output reg [`WORD-1:0] IF1_ID_PC_out,
    output reg [`WORD-1:0] IF1_ID_inst_out
    );

    wire stall = IF1_ID_stall_from_DCache;
    wire flush = |{ IF1_ID_flush_from_EX_Branch, 
                    IF1_ID_flush_from_ICache, 
                    IF1_ID_flush_from_Pre_Branch };
    always@(posedge clk)
    begin
        if(rst)
        begin
            {IF1_ID_PC_out, IF1_ID_inst_out} <= {`PC_RST, 32'h0};
        end
        else
        begin
            if(stall)
            begin
                {IF1_ID_PC_out, IF1_ID_inst_out} <= {IF1_ID_PC_out, IF1_ID_inst_out};
            end
            else
            begin
                {IF1_ID_PC_out, IF1_ID_inst_out} <= 
                    {64{~flush}} & {IF1_ID_PC_in, IF1_ID_inst_in};
            end
        end
    end

endmodule
