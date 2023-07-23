`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:56:23
// Design Name: 
// Module Name: RF
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

module RF(
    input clk, rst,
    input RFWrite,
    input [`REG_LOG-1:0] rd,
    input [`WORD-1:0] rd_WriteData,
    input [`REG_LOG-1:0] rs0, rs1, rs2,
    output [`WORD-1:0] src0, src1, src2
    );

    reg [`WORD-1:0] REG [31:0];

    integer i;
    always@(negedge clk)
    begin
        if(rst)
        begin
            for(i = 0; i <= 31; i = i + 1)
                REG[i] <= 32'h0;
        end
        else
        begin
            if(RFWrite)
                REG[rd] <= rd_WriteData & {32{|rd}};
            /*else
                REG[rd] <= REG[rd];*/
        end
    end

    assign {src0, src1, src2} = {REG[rs0], REG[rs1], REG[rs2]};

endmodule
