`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/30 20:41:01
// Design Name: 
// Module Name: Way_Select_LRU
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

module Way_Select_LRU(
    input clk,
    input [`CACHE_WAY-1:0] hit,
    input [`RAM_DEPTH_LOG-1:0] addr,
    input way_sel_update,
    output way_sel
    );

    reg [`RAM_DEPTH-1:0] count = 0;
    always@(posedge clk)
    begin
        if(way_sel_update)
        begin
            case(hit)
                2'b10: count[addr] <= 1;
                2'b01: count[addr] <= 0;
                default: count[addr] <= count[addr];
            endcase
        end
        else
            count <= count;
    end

    assign way_sel = ~count[addr];
    
endmodule
