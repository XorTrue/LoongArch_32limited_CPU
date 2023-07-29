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

module EX(
    input clk, rst,
    input PC,
    input [`OPCODE_LEN*2-1:0] opcode,
    input [7:0] CTRL_EX,
    input [`REG_LOG*3-1:0] rs,
    input [`WORD*3-1:0] src,
    input [`WORD*2-1:0] CONST,

    input [5:0] fwd,
    input [`WORD-1:0] src_from_MEM,
    input [`WORD-1:0] src_from_WB,

    input predict,

    output EX_Branch_out,
    output [`WORD-1:0] EX_PC_out,
    output CAL_MUL,
    output [`WORD-1:0] ALU_out,
    output [`WORD*2-1:0] src_fwd
    );

    wire [1:0] fwd0, fwd1, fwd2;
    assign {fwd2, fwd1, fwd0} = fwd;

    wire [`WORD-1:0] src0, src1, src2;
    assign {src2, src1, src0} = src;
    wire [`WORD-1:0] src0_fwd, src1_fwd, src2_fwd;

    SEL_3 FWD0_SRC0(
        .sel(fwd0),
        .in0(src0), .in1(src_from_WB), .in2(src_from_MEM),
        .out(src0_fwd)
    );
    SEL_3 FWD1_SRC1(
        .sel(fwd1),
        .in0(src1), .in1(src_from_WB), .in2(src_from_MEM),
        .out(src1_fwd)
    );
    SEL_3 FWD2_SRC2(
        .sel(fwd2),
        .in0(src2), .in1(src_from_WB), .in2(src_from_MEM),
        .out(src2_fwd)
    );
    assign src_fwd = {src2_fwd, src1_fwd};

    wire [1:0] REG_WB;
    wire [1:0] MEM;
    wire [3:0] EX;
    assign {MEM, EX, REG_WB} = CTRL_EX;
    wire is_branch, is_MUL;
    wire ALU_in0_MUX, ALU_in1_MUX;
    assign {is_branch, is_MUL, ALU_in0_MUX, ALU_in1_MUX} = EX;
    assign CAL_MUL = is_MUL;
    
    wire [`WORD-1:0] IMM, OFFS;
    assign {IMM, OFFS} = CONST;
    
    wire [`WORD-1:0] ALU_in0, ALU_in1;
    SEL_2 SRC1_or_PC(
        .sel(ALU_in0_MUX),
        .in0(src1_fwd), .in1(PC),  
        .out(ALU_in0)
    ); 
    SEL_2 SRC2_or_IMM(
        .sel(ALU_in1_MUX),
        .in0(src2_fwd), .in1(IMM),  
        .out(ALU_in1)
    );

    wire [`OPCODE_LEN-1:0] ALU_opcode, CMP_opcode;
    assign {ALU_opcode, CMP_opcode} = opcode;
    //wire [`WORD-1:0] ALU_out;
    ALU ALU(
        .ALU_opcode(ALU_opcode),
        .ALU_in0(ALU_in0), .ALU_in1(ALU_in1), 
        .ALU_out(ALU_out)
    );
    wire [`WORD-1:0] CMP_out, CMP_PC_out;
    CMP CMP(
        .CMP_opcode(CMP_opcode),
        .CMP_in0(src0_fwd), .CMP_in1(src1_fwd), 
        .CMP_PC_in(ALU_in0), .CMP_OFFS_in(OFFS), 
        .CMP_out(CMP_out), 
        .CMP_PC_out(CMP_PC_out)
    );

    EX_Branch EX_Branch(
        .is_branch(is_branch), .branch(branch), 
        .predict(predict), 
        .EX_Branch_out(EX_Branch_out),
        .PC_EX(PC),
        .PC_Branch(CMP_PC_out),
        .EX_PC_out(EX_PC_out)
    );

endmodule
