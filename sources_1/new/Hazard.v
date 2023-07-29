`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/29 23:12:16
// Design Name: 
// Module Name: Hazard
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

module Hazard(
    input [7:0] CTRL_EX,
    input [`REG_LOG-1:0] rd_EX,
    input [`REG_LOG*3-1:0] rs_ID,
    output stall_from_Load,
    output flush_from_Load
    );

    wire [1:0] REG_WB;
    wire [1:0] MEM;
    wire [3:0] EX;
    assign {REG_WB, MEM, EX} = CTRL_EX;
    wire MEM_read, MEM_write;
    assign {MEM_read, MEM_write} = MEM;

    wire [`REG_LOG-1:0] rs0_ID, rs1_ID, rs2_ID;
    assign stall_from_Load = 
        MEM_read & |rd_EX & ( (rs0_ID == rd_EX) | (rs1_ID == rd_EX) | (rs2_ID == rd_EX) );
    assign flush_from_Load = 
        MEM_read & |rd_EX & ( (rs0_ID == rd_EX) | (rs1_ID == rd_EX) | (rs2_ID == rd_EX) );

endmodule
