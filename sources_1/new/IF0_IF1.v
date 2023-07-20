`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:35:57
// Design Name: 
// Module Name: IF0_IF1
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

module IF0_IF1(
    input clk,
    input rst,
    input IF0_IF1_stall,
    input IF0_IF1_clear,
    input IF0_IF1_PC_in,

    output reg [`WORD-1:0] IF0_IF1_PC_out,
    output reg iCache_valid
    );

    always@(posedge clk)
    begin
        if(rst)
        begin
            {IF0_IF1_PC_out, iCache_valid} <= {`PC_RST, 1'b0};
        end
        else
        begin
            

        end

    end
endmodule