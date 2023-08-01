`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 16:01:16
// Design Name: 
// Module Name: PC
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

module PC(
    input clk, 
    input rst,
    input [`WORD-1:0] PC_in,
    input PC_stall,
    output reg [`WORD-1:0] PC_out = 0
    );

    always@(posedge clk)
    begin
        if(rst)
            PC_out <= `PC_RST;
        else 
        begin
            if(PC_stall)
                PC_out <= PC_out;
            else
                PC_out <= PC_in;
        end
    end

endmodule
