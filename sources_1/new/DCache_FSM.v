`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 23:16:03
// Design Name: 
// Module Name: DCache_FSM
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

module DCache_FSM(  
    input clk, rst,
    input hit,
    input [1:0] is_dmem,
    input memory_ready,

    output reg rbuf_we = 0,
    output reg en_r = 0,
    output reg ret_we = 0,
    output reg pipeline_ready = 0,
    output reg Cache_we_w = 0,
    output reg is_data_from_mem = 0,
    output reg is_direct = 0,
    output reg memory_valid = 0,
    output reg memory_for_store = 0
    );

    wire is_load, is_store;
    assign {is_store, is_load} = is_dmem;

    parameter NEW = 0;
    parameter LOAD = 1;
    parameter WRITE = 2;
    parameter CMP_L = 3;
    parameter STORE = 4;
    parameter CMP_S = 5;
    parameter DIRECT = 6;
    parameter IDLE = 7;

    reg [3:0] curr_state = NEW;
    reg [3:0] next_state = NEW;

    always@(posedge clk)
    begin
        if(rst)
            curr_state <= NEW;
        else
            curr_state <= next_state;
    end

    always@(*)
    begin
        rbuf_we = 0;
        en_r = 0;
        ret_we = 0;
        pipeline_ready = 0;
        Cache_we_w = 0;
        is_data_from_mem = 0;
        is_direct = 0;
        memory_valid = 0;
        memory_for_store = 0;
        next_state = curr_state;
        /*if(curr_state == IDLE)
        begin
            if(|is_dmem)
            begin
                rbuf_we = 1;
                en_r = 1;
                next_state = NEW;
            end
        end*/
        if(curr_state == NEW)
        begin
            /*if(|is_dmem)
            begin
                rbuf_we = 1;
                en_r = 1;
            end*/
            if(is_load)
            begin
                //next_state = CMP_L;
                if(~hit)
                    next_state = LOAD;
                else
                begin
                    rbuf_we = 1;
                    en_r = 1;
                    pipeline_ready = 1;
                    next_state = NEW;
                end
            end
            else if(is_store)
            begin
                //next_state = CMP_S;
                if(hit)
                    next_state = DIRECT;
                else
                begin
                    //rbuf_we = 1;
                    //en_r = 1;
                    next_state = STORE;
                    //pipeline_ready = 1;
                end
            end
            else 
            begin
                rbuf_we = 1;
                en_r = 1;
            end
        end
        /*else if(curr_state == CMP_L)
        begin
            if(hit)
                next_state = LOAD;
            else
            begin
                pipeline_ready = 1;
                next_state = NEW;
            end
        end*/
        else if(curr_state == LOAD)
        begin
            memory_valid = 1;
            if(memory_ready)
            begin
                ret_we = 1;
                Cache_we_w = 1;
                next_state = WRITE;
            end
        end
        else if(curr_state == WRITE)
        begin
            is_data_from_mem = 1;
            pipeline_ready = 1;
            rbuf_we = 1;
            en_r = 1;
            //Cache_we_w = 1;
            next_state = NEW;
        end
        /*else if(curr_state == CMP_S)
        begin
            if(hit)
                next_state = DIRECT;
            else
            begin
                curr_state = STORE;
                pipeline_ready = 1;
            end
        end*/
        else if(curr_state == DIRECT)
        begin
            is_direct = 1;
            Cache_we_w = 1;
            next_state = STORE;
        end
        else if(curr_state == STORE)
        begin
            memory_valid = 1;
            memory_for_store = 1;
            if(memory_ready)
            begin
                rbuf_we = 1;
                en_r = 1;
                pipeline_ready = 1;
                next_state = NEW;
            end
        end
    end

endmodule
