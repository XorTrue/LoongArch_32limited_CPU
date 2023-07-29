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
    input IF0_IF1_stall_from_Load,

    input [`WORD-1:0] IF0_IF1_PC_in,
    input ICache_valid_in,

    output reg [`WORD-1:0] IF0_IF1_PC_out,
    output reg ICache_valid_out
    );

    wire stall = IF0_IF1_stall_from_Load;
    always@(posedge clk)
    begin
        if(rst)
        begin
            { IF0_IF1_PC_out, 
              ICache_valid_out } <= 
            { 32'b0, 1'b0 };
        end
        else
        begin
            if(stall)
            begin
                { IF0_IF1_PC_out, 
                  ICache_valid_out } <= 
                { IF0_IF1_PC_out, 
                  ICache_valid_out };
            end
            else
            begin
                { IF0_IF1_PC_out, 
                  ICache_valid_out } <= 
                { IF0_IF1_PC_in,
                  ICache_valid_in};
            end
        end
    end

endmodule
