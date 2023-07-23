`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 18:35:33
// Design Name: 
// Module Name: EX0
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

module EX0(
    input clk, rst
    );

    wire [`WORD-1:0] src0, src1, src2;
    wire [`WORD-1:0] ALU_in0, ALU_in1;
    SEL_2 SRC1_or_PC (
        .sel(),
        .in0(src1), .in1(),  
        .out(ALU_in0)
    ); 
    SEL_2 SRC2_or_IMM (
        .sel(),
        .in0(src2), .in1(),  
        .out(ALU_in1)
    );

    wire [`WORD-1:0] ALU_out;
    ALU ALU(
        .ALU_opcode(),
        .ALU_in0(ALU_in0), .ALU_in1(ALU_in1), 
        .ALU_out()
    );


    wire [`WORD-1:0] CMP_out, CMP_PC_out;
    CMP CMP(
        .CMP_opcode(),
        .CMP_in0(src0), .CMP_in1(src1), 
        .CMP_PC_in(ALU_in0), .CMP_OFFS_in(), 
        .CMP_out(CMP_out), 
        .CMP_PC_out(CMP_PC_out)
    );
endmodule
