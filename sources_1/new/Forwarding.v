`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/29 22:52:24
// Design Name: 
// Module Name: Forwarding
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

module Forwarding(
    input [`REG_LOG*3-1:0] rs_EX,
    input [`REG_LOG-1:0] rd_MEM,
    input [`REG_LOG-1:0] rd_WB,
    input REG_write_MEM, REG_write_WB,
    output [5:0] fwd
    );

    wire [`REG_LOG-1:0] rs0_EX, rs1_EX, rs2_EX;
    assign {rs2_EX, rs1_EX, rs0_EX} = rs_EX;

    wire [1:0] fwd0, fwd1, fwd2;
    assign fwd0[1] = REG_write_MEM & |rd_MEM & (rs0_EX == rd_MEM);
    assign fwd0[0] = REG_write_WB  & |rd_WB  & (rs0_EX == rd_WB);
    assign fwd1[1] = REG_write_MEM & |rd_MEM & (rs1_EX == rd_MEM);
    assign fwd1[0] = REG_write_WB  & |rd_WB  & (rs1_EX == rd_WB);
    assign fwd2[1] = REG_write_MEM & |rd_MEM & (rs2_EX == rd_MEM);
    assign fwd2[0] = REG_write_WB  & |rd_WB  & (rs2_EX == rd_WB);
    assign fwd = {fwd2, fwd1, fwd0};


endmodule
