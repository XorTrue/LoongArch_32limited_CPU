`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 19:17:27
// Design Name: 
// Module Name: Cache_MEM
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

module Cache_MEM(
    input clk, rst,

    input memory_valid_for_ICache,
    input [`WORD-1:0] load_addr_inst,

    input memory_valid_for_DCache,
    input [`WORD-1:0] load_addr_data,

    output reg memory_ready_for_ICache,
    output [`CACHE_LINE_WIDTH-1:0] inst_from_mem,

    output reg memory_ready_for_DCache,
    output [`CACHE_LINE_WIDTH-1:0] data_from_mem,

    output base_ram_ce_n,
    output base_ram_oe_n,
    output base_ram_we_n,
    output [19:0] base_ram_addr,
  

    output ext_ram_ce_n,
    output ext_ram_oe_n,
    output ext_ram_we_n,
    output [19:0] ext_ram_addr
    );

    reg [`WORD-1:0] load_cnt = 0;
    reg [3:0] wait_cnt = 0;

    parameter IDLE = 0;
    parameter REQ_I = 1;
    parameter WAIT = 2;
    parameter LOAD_I = 3;

    reg [3:0] curr_state = IDLE;
    reg [3:0] next_state = IDLE;

    /*always@(*)
    begin
        next_state = curr_state;
        if(curr_state == IDLE)
        begin
            if(memory_valid_for_ICache)
                next_state = REQ_I;
        end
        else if(curr_state == REQ_I)
            next_state = WAIT;
        else if(curr_state == WAIT)
        begin
            if(wait_cnt == `CAHCE_WAIT_CYCLE - 1)
                next_state = LOAD_I;
        end
        else if(curr_state == LOAD_I)
        begin
            if(load_cnt ==  - 1)
                next_state = RET;
        end
        end

    end*/

    always@(posedge clk)
    begin
        if(rst)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end


endmodule
