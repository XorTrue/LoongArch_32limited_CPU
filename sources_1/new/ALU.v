`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 16:36:22
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [`OPCODE_LEN-1:0] ALU_opcode,
    input [`WORD-1:0] ALU_in0,
    input [`WORD-1:0] ALU_in1,
    output reg [`WORD-1:0] ALU_out
    );

    always@(*)
    begin
        case(ALU_opcode)
            `ALU_ADD  : ALU_out = ALU_in0 + ALU_in1;
            `ALU_SUB  : ALU_out = ALU_in0 - ALU_in1;
            `ALU_AND  : ALU_out = ALU_in0 & ALU_in1;
            `ALU_OR   : ALU_out = ALU_in0 | ALU_in1;
            `ALU_XOR  : ALU_out = ALU_in0 ^ ALU_in1;
            `ALU_SLL  : ALU_out = ALU_in0 << ALU_in1[4:0];
            `ALU_SRL  : ALU_out = ALU_in0 >> ALU_in1[4:0];
            `ALU_SLTU : ALU_out = (ALU_in0 < ALU_in1);
            default   : ALU_out = 32'h0; 
        endcase
    end

endmodule
