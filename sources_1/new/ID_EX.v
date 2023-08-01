`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 20:15:46
// Design Name: 
// Module Name: ID_EX
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

module ID_EX(
    input clk, rst,

    input ID_EX_stall_from_DCache,
    input ID_EX_flush_from_EX_Branch,
    input ID_EX_flush_from_Load,
    
    input [`WORD-1:0] ID_EX_PC_in,
    input [`WORD-1:0] ID_EX_inst_in,
    input [`OPCODE_LEN*2-1:0] ID_EX_opcode_in,
    input [7:0] ID_EX_CTRL_EX_in,
    input [`REG_LOG*3-1:0] ID_EX_rs_in,
    input [`WORD*3-1:0] ID_EX_src_in,
    input [`WORD*2-1:0] ID_EX_CONST_in,

    output reg [`WORD-1:0] ID_EX_PC_out = 0,
    output reg [`WORD-1:0] ID_EX_inst_out = 0,
    output reg [`OPCODE_LEN*2-1:0] ID_EX_opcode_out = 0,
    output reg [7:0] ID_EX_CTRL_EX_out = 0,
    output reg [`REG_LOG*3-1:0] ID_EX_rs_out = 0,
    output reg [`WORD*3-1:0] ID_EX_src_out = 0,
    output reg [`WORD*2-1:0] ID_EX_CONST_out = 0
    
    );
    
    wire stall = ID_EX_stall_from_DCache;
    wire flush = ID_EX_flush_from_EX_Branch | 
                 ID_EX_flush_from_Load;

    always@(posedge clk)
    begin
        if(rst)
        begin
            { ID_EX_PC_out, 
              ID_EX_inst_out, 
              ID_EX_opcode_out, 
              ID_EX_CTRL_EX_out, 
              ID_EX_rs_out, 
              ID_EX_src_out, 
              ID_EX_CONST_out } <= {`PC_RST, 32'h0, 32'h0, 8'h0, 15'h0, 96'h0, 64'h0};
        end
        else
        begin
            if(stall)
            begin
                { ID_EX_PC_out, 
                  ID_EX_inst_out, 
                  ID_EX_opcode_out, 
                  ID_EX_CTRL_EX_out, 
                  ID_EX_rs_out, 
                  ID_EX_src_out, 
                  ID_EX_CONST_out } <= 
                { ID_EX_PC_out, 
                  ID_EX_inst_out, 
                  ID_EX_opcode_out, 
                  ID_EX_CTRL_EX_out, 
                  ID_EX_rs_out, 
                  ID_EX_src_out, 
                  ID_EX_CONST_out };
            end
            else
            begin
                { ID_EX_PC_out, 
                  ID_EX_inst_out, 
                  ID_EX_opcode_out, 
                  ID_EX_CTRL_EX_out, 
                  ID_EX_rs_out, 
                  ID_EX_src_out, 
                  ID_EX_CONST_out } <= 
                {279{~flush}} & 
                { ID_EX_PC_in, 
                  ID_EX_inst_in, 
                  ID_EX_opcode_in, 
                  ID_EX_CTRL_EX_in, 
                  ID_EX_rs_in, 
                  ID_EX_src_in, 
                  ID_EX_CONST_in };
            end
        end
    end


endmodule
