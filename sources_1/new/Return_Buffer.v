`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/30 19:58:45
// Design Name: 
// Module Name: Return_Buffer
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

module Return_Buffer(  
    input clk, rst,
    input we,
    input [`CACHE_LINE_BYTE_LOG-2-1:0] addr,
    input [`CACHE_LINE_WIDTH-1:0] in,
    output reg [`CACHE_LINE_WIDTH-1:0] out,
    output reg [`WORD-1:0] inst_from_ret
    );

    always@(posedge clk)
    begin
        if(rst)
            out <= 0;       
        else
        begin
            if(we)
                out <= in;
            else
                out <= out;
        end
    end

    always@(*)
    begin
        case(addr)
            2'b00: inst_from_ret = out[`WORD-1:0];
            2'b01: inst_from_ret = out[`WORD*2-1:`WORD];
            2'b10: inst_from_ret = out[`WORD*3-1:`WORD*2];
            2'b11: inst_from_ret = out[`WORD*4-1:`WORD*3];
            default: inst_from_ret = 0;
        endcase
    end

endmodule
