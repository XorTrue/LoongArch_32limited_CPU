`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:52:47
// Design Name: 
// Module Name: IF1_ID
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

module IF1_ID(
    input clk, rst,

    input IF1_ID_stall,
    input IF1_ID_clear,
    input IF1_ID_PC_in,
    input IF1_ID_inst_in,

    output reg [`WORD-1:0] IF1_ID_PC_out,
    output reg [`WORD-1:0] IF1_ID_inst_out
    );

    always@(posedge clk)
    begin
        if(rst)
        begin
            {IF1_ID_PC_out, IF1_ID_inst_out} <= {`PC_RST, 32'h0};
        end
        else
        begin
            
        end
    end

endmodule
