`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/30 16:27:39
// Design Name: 
// Module Name: Request_Buffer
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

module Request_Buffer #(
    parameter WIDTH = `WORD
)(
    input clk, rst,
    input we,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out = 0
    );
    always@(posedge clk)
    begin
        if(rst)
            out <= `PC_RST;
        else
        begin
            if(we)
                out <= in;
            else
                out <= out;
        end
    end
endmodule
