`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 21:01:49
// Design Name: 
// Module Name: EX_MEM
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

module EX_MEM(
    input clk, rst,
    input EX_MEM_stall_from_DCache,
    
    input [`WORD-1:0] EX_MEM_PC_in,
    input [`WORD-1:0] EX_MEM_inst_in,
    input [7:0] EX_MEM_CTRL_EX_in,
    input CAL_SEL_in,
    input [`WORD-1:0] ALU_res_in,
    input [`REG_LOG*3-1:0] EX_MEM_rs_in,
    input sign_in,
    input [`WORD*3-1:0] mul_tmp_in,

    output reg [`WORD-1:0] EX_MEM_PC_out,
    output reg [`WORD-1:0] EX_MEM_inst_out,
    output reg [7:0] EX_MEM_CTRL_EX_out,
    output reg CAL_SEL_out,
    output reg [`WORD-1:0] ALU_res_out,
    output reg [`REG_LOG*3-1:0] EX_MEM_rs_out,
    output reg sign_out,
    output reg [`WORD*3-1:0] mul_tmp_out
    );

    wire stall = EX_MEM_stall_from_DCache;

    always@(posedge clk)
    begin
        if(rst)
        begin
            { EX_MEM_PC_out, 
              EX_MEM_inst_out, 
              EX_MEM_CTRL_EX_out, 
              CAL_SEL_out, 
              ALU_res_out,
              EX_MEM_rs_out,
              sign_out,
              mul_tmp_out } <= 
            { `PC_RST, 32'h0, 8'h0, 1'b0, 32'h0, 15'h0, 1'b0, 96'h0};
        end    
        else
        begin
            if(stall)
            begin
              { EX_MEM_PC_out, 
                EX_MEM_inst_out, 
                EX_MEM_CTRL_EX_out, 
                CAL_SEL_out, 
                ALU_res_out,
                EX_MEM_rs_out,
                sign_out,
                mul_tmp_out } <=
              { EX_MEM_PC_out, 
                EX_MEM_inst_out, 
                EX_MEM_CTRL_EX_out, 
                CAL_SEL_out, 
                ALU_res_out,
                EX_MEM_rs_out,
                sign_out,
                mul_tmp_out };
            end
            else
            begin
              { EX_MEM_PC_out, 
                EX_MEM_inst_out, 
                EX_MEM_CTRL_EX_out, 
                CAL_SEL_out, 
                ALU_res_out,
                EX_MEM_rs_out,
                sign_out,
                mul_tmp_out } <=
              { EX_MEM_PC_in, 
                EX_MEM_inst_in, 
                EX_MEM_CTRL_EX_in, 
                CAL_SEL_in, 
                ALU_res_in,
                EX_MEM_rs_in,
                sign_in,
                mul_tmp_in };
            end
        end
    end

endmodule
