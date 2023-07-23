`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 16:23:15
// Design Name: 
// Module Name: NPC
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

module NPC(
    input [`WORD-1:0] PC,    
    input Pre_Branch,
    input [`WORD-1:0] Pre_PC,
    input EX_Branch,
    input [`WORD-1:0] EX_PC,
    output reg [`WORD-1:0] NPC
    );

    always@(*)
    begin
        casex({EX_Branch, Pre_Branch})
            2'b1x:   NPC = EX_PC;
            2'b01:   NPC = Pre_PC;
            2'b00:   NPC = PC + 32'd4;
            default: NPC = `UNDEFINE;
        endcase
    end

endmodule
