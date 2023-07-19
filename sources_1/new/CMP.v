`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 16:47:02
// Design Name: 
// Module Name: CMP
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

module CMP(
    input [`OPCODE_LEN-1:0] CMP_opcode,
    input [`WORD-1:0] CMP_in0,
    input [`WORD-1:0] CMP_in1, 
    input [`WORD-1:0] CMP_PC_in,
    input [`WORD-1:0] CMP_OFFS_in,
    output reg CMP_out,
    output wire [`WORD-1:0] CMP_PC_out
    );

    wire signed [`WORD-1:0]  CMP_in0_signed, CMP_in1_signed;
    assign CMP_in0_signed = CMP_in0;
    assign CMP_in1_signed = CMP_in1;

    always@(*)
    begin
        case(CMP_opcode)
            `CMP_EQ  : CMP_out = (CMP_in0 == CMP_in1);
            `CMP_NE  : CMP_out = (CMP_in0 != CMP_in1);
            `CMP_GE  : CMP_out = (CMP_in0_signed >= CMP_in1_signed);
            `CMP_B   : CMP_out = 1'b1;
            default  : CMP_out = 1'b0;
        endcase
    end

    assign CMP_PC_out = CMP_PC_in + CMP_OFFS_in;

endmodule
