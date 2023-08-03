`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/30 19:46:24
// Design Name: 
// Module Name: ICache_FSM
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

module ICache_FSM(
    input clk,
    input rst,
    input stall,
    input [`CACHE_WAY-1:0] hit,
    input way_to_replace,
    input pipeline_valid,
    input memory_ready,
    //input [`WORD-1:0] addr,
    //output reg [`WORD-1:0] load_addr = 0,
    output reg select_way = 0,
    output reg rbuf_we = 0,
    output reg ret_we = 0,
    output reg pipeline_ready = 0,
    output reg [`CACHE_WAY-1:0] Cache_we_w = 0,
    output reg is_inst_from_mem = 0,
    output reg memory_valid = 0,
    output reg fix_branch = 0
    );

    parameter NEW = 0;
    parameter LOAD = 1;
    parameter WRITE = 2;
    parameter CMP = 3;
    parameter IDLE = 4;

    reg [4:0] curr_state = NEW;
    reg [4:0] next_state = NEW;

    always@(posedge clk)
    begin
        if(rst)
            curr_state <= IDLE;
        else if(stall)
            curr_state <= NEW;
        else
            curr_state <= next_state;
    end

    /*always@(posedge clk)
    begin
        if(curr_state == CMP && hit == 2'b00)
            load_addr <= addr;
        else
            load_addr <= load_addr;
    end*/

    always@(*)
    begin
        select_way = 0;
        rbuf_we = 0;
        ret_we = 0;
        pipeline_ready = 0;
        Cache_we_w = 0;
        is_inst_from_mem = 0;
        memory_valid = 0;
        fix_branch = 0;
        next_state = curr_state;
        if(curr_state == IDLE)
        begin
            rbuf_we = 1;
            fix_branch = 1;
            next_state = NEW;
        end
        if(curr_state == NEW)
        begin
            //if(pipeline_valid)
            //begin
            //rbuf_we = 1;
            //next_state = CMP;
            //end
            if(pipeline_valid)
            begin
                if(~|hit)
                begin
                    next_state = LOAD;
                end
                else 
                begin
                    select_way = hit[1];
                    pipeline_ready = 1;
                    next_state = NEW;
                    rbuf_we = 1;
                end
            end
        end
        /*else if(curr_state == CMP)
        begin            
            if(~|hit)
                next_state = LOAD;
            else
            begin
                rbuf_we = 1;
                select_way = hit[1];
                pipeline_ready = 1;
                next_state = CMP;
            end
        end*/
        else if(curr_state == LOAD)
        begin
            memory_valid = 1;
            if(memory_ready)
            begin
                ret_we = 1;
                Cache_we_w[way_to_replace] = 1;
                //pipeline_ready = 1;
                //next_state = WRITE;
                next_state = WRITE;
            end
        end
        else if(curr_state == WRITE)
        begin
            is_inst_from_mem = 1;
            pipeline_ready = 1;
            rbuf_we = 1;
            //Cache_we_w[way_to_replace] = 1;
            next_state = NEW;
        end
    end



endmodule
