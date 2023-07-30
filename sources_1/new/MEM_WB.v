`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/29 20:49:31
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB(
    input clk, rst,
    input MEM_WB_flush_from_DCache,
    input [`WORD-1:0] MEM_WB_PC_in,
    input [`WORD-1:0] MEM_WB_inst_in,
    input [7:0] MEM_WB_CTRL_EX_in,
    input [`REG_LOG*3-1:0] MEM_WB_rs_in,
    input [`WORD-1:0] MEM_WB_CAL_res_in,
    input [`WORD-1:0] MEM_WB_data_in,
    
    output reg [`WORD-1:0] MEM_WB_PC_out,
    output reg [`WORD-1:0] MEM_WB_inst_out,
    output reg [7:0] MEM_WB_CTRL_EX_out,
    output reg [`REG_LOG*3-1:0] MEM_WB_rs_out,
    output reg [`WORD-1:0] MEM_WB_CAL_res_out,
    output reg [`WORD-1:0] MEM_WB_data_out
    );

    assign flush = MEM_WB_flush_from_DCache;
    always@(posedge clk)
    begin
        if(rst)
        begin
            { MEM_WB_PC_out, 
              MEM_WB_inst_out, 
              MEM_WB_CTRL_EX_out,
              MEM_WB_rs_out,
              MEM_WB_CAL_res_out,
              MEM_WB_data_out } <= 
            { `PC_RST, 32'h0, 8'h0, 15'h0, 32'h0, 32'h0 };
        end
        else
        begin
            { MEM_WB_PC_out, 
              MEM_WB_inst_out, 
              MEM_WB_CTRL_EX_out,
              MEM_WB_rs_out,
              MEM_WB_CAL_res_out,
              MEM_WB_data_out } <= 
            {151{~flush}} &
            { MEM_WB_PC_in, 
              MEM_WB_inst_in, 
              MEM_WB_CTRL_EX_in,
              MEM_WB_rs_in,
              MEM_WB_CAL_res_in,
              MEM_WB_data_in };
        end
    end

endmodule
