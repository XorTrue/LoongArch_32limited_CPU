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
    input stall_from_Load,
    input EX_Branch,
    input Pre_Branch,

    input memory_valid_for_ICache,
    input [`WORD-1:0] load_inst_addr,

    input memory_valid_for_DCache,
    input memory_for_store,
    input [`WORD-1:0] load_store_data_addr,
    input [`WORD-1:0] data_to_store,

    output reg memory_ready_for_ICache = 0,
    output reg [`CACHE_LINE_WIDTH-1:0] inst_from_mem = 0,

    output reg memory_ready_for_DCache = 0,
    output reg [`CACHE_LINE_WIDTH-1:0] data_from_mem = 0,

    output reg base_ram_ce_n = 1,
    output reg base_ram_oe_n = 1,
    output reg base_ram_we_n = 1,
    output reg [19:0] base_ram_addr = 0,
    inout [31:0] base_ram_data,
  
    output reg ext_ram_ce_n = 1,
    output reg ext_ram_oe_n = 1,
    output reg ext_ram_we_n = 1,
    output reg [19:0] ext_ram_addr = 0,
    input  [31:0] ext_ram_data_in,
    output [31:0] ext_ram_data_out
    );

    wire stall = stall_from_Load;
    wire flush = EX_Branch | Pre_Branch;

    reg [2:0] cache_cnt = 3'b100;
    reg [`CACHE_LINE_WIDTH-1:0] addr_cache = 0;
    reg [`CACHE_LINE_WIDTH-1:0] store_cache = 0;
    assign ext_ram_data_out = store_cache[31:0];
    reg [3:0] num_cnt = 0;
    reg [3:0] wait_cnt = 0;

    parameter IDLE = 0;
    parameter CACHE = 1;
    parameter DECODE = 2;
    parameter STORE = 3;
    parameter LOAD = 4;
    parameter WAIT = 5;
    parameter RET = 6;

    reg [3:0] curr_state = IDLE;
    reg [3:0] next_state = IDLE;
    always@(posedge clk)
    begin
        if(rst | ((flush | stall) && ~memory_valid_for_DCache))
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end

    parameter WAIT_S = 0;
    parameter WAIT_D = 1;
    parameter WAIT_I = 2;
    reg [3:0] wait_state = 0;

    wire write_cache_empty = (cache_cnt == 0);
    wire is_base = (load_store_data_addr >= 32'h8000_0000 && 
                    load_store_data_addr <  32'h8040_0000);
    wire is_empty = |addr_cache[`WORD-1:0];
    always@(*)
    begin
        next_state = curr_state;
        if(curr_state == IDLE)
        begin
            if(~(memory_ready_for_DCache | memory_ready_for_ICache))
            begin
                if(~memory_valid_for_DCache && 
                    memory_valid_for_ICache)
                    next_state = DECODE;
                else if(memory_ready_for_DCache)
                begin
                    if(memory_for_store && ~write_cache_full)
                        next_state = CACHE;
                    else if(~write_cache_empty)
                        next_state = DECODE;
                    else if(memory_valid_for_DCache)
                        next_state = DECODE;
                end
            end
        end
        else if(curr_state == CACHE)
            next_state = RET;
        else if(curr_state == DECODE)
        begin
            if(wait_state == WAIT_S)
            begin
                if(is_empty)
                    next_state = IDLE;
                else 
                    next_state = STORE;
            end
            else
                next_state = LOAD;
        end
        else if(curr_state == WAIT)
        begin
            if(wait_cnt == `CACHE_WAIT_CYCLE - 1)
            begin
                if(wait_state == WAIT_S)
                    next_state = STORE;
                else
                    next_state = LOAD;
            end
        end
        else if(curr_state == STORE)
        begin
            if(num_cnt == 1)
                next_state = IDLE;
            else
                next_state = WAIT;
        end
        else if(curr_state == LOAD)
        begin
            if(num_cnt == `CACHE_WORD_NUM)
                next_state = RET;
            else
                next_state = WAIT;
        end
        else if(curr_state == RET)
            next_state = IDLE;
    end

    always@(posedge clk)
    begin
        if(curr_state == IDLE)
        begin
            num_cnt <= 0;
            wait_cnt <= 0;
            wait_state <= 0;
            memory_ready_for_DCache <= 0;
            memory_ready_for_ICache <= 0;
            base_ram_ce_n <= 1;
            base_ram_oe_n <= 1;
            base_ram_we_n <= 1;
            ext_ram_ce_n <= 1;
            ext_ram_oe_n <= 1;
            ext_ram_we_n <= 1;
            if(~memory_valid_for_DCache && 
                memory_valid_for_ICache)
                wait_state <= WAIT_I;
            else
            begin
                if(~write_cache_empty)
                    wait_state <= WAIT_S;
                else if(memory_valid_for_DCache)
                    wait_state <= WAIT_D;
            end
        end
        else if(curr_state == CACHE)
        begin
            addr_cache <= {load_store_data_addr, addr_cache[`WORD*4-1:`WORD*3]};
            store_cache <= {data_to_store, store_cache[`WORD*4-1:`WORD*3]};
            cache_cnt <= cache_cnt + 1;
        end
        else if(curr_state == DECODE)
        begin
            if(wait_state == WAIT_S)
                ext_ram_addr <= addr_cache[19:0];
            else if(wait_state == WAIT_D)
            begin
                base_ram_addr <= load_store_data_addr[19:0];
                ext_ram_addr <= load_store_data_addr[19:0];
            end
            else
                base_ram_addr <= load_inst_addr[19:0];    
        end
        else if(curr_state == WAIT)
        begin
            if(wait_cnt == `CACHE_WAIT_CYCLE - 1)
            begin
                base_ram_ce_n <= 1;
                base_ram_oe_n <= 1;
                base_ram_we_n <= 1;
                ext_ram_ce_n <= 1;
                ext_ram_oe_n <= 1;
                ext_ram_we_n <= 1;
            end
            else
                wait_cnt <= wait_cnt + 1;
        end
        else if(curr_state == STORE)
        begin
            num_cnt <= num_cnt + 1;
            wait_cnt <= 0;
            if(num_cnt == 1)
            begin
                ext_ram_ce_n <= 1;
                ext_ram_we_n <= 1;
                cache_cnt <= cache_cnt - 1;
                addr_cache  <= {32'h0, addr_cache[`WORD*4-1:`WORD]};
                store_cache <= {32'h0, store_cache[`WORD*4-1:`WORD]};                
            end
            else 
            begin
                ext_ram_ce_n <= 0;
                ext_ram_we_n <= 0;
            end
        end
        else if(curr_state == LOAD)
        begin
            base_ram_addr <= {base_ram_addr[19:4], num_cnt[1:0], 2'b00};
            ext_ram_addr  <= { ext_ram_addr[19:4], num_cnt[1:0], 2'b00};
            num_cnt <= num_cnt + 1;
            wait_cnt <= 0;
            inst_from_mem <= {base_ram_data, inst_from_mem[`WORD*4-1:`WORD]};
            data_from_mem <= is_base ? 
                {base_ram_data, data_from_mem[`WORD*4-1:`WORD]} :
                {ext_ram_data_in, data_from_mem[`WORD*4-1:`WORD]};
            if(num_cnt == `CACHE_WORD_NUM)
            begin
                base_ram_ce_n <= 1;
                base_ram_oe_n <= 1;
                ext_ram_ce_n <= 1;
                ext_ram_oe_n <= 1;
            end
            else   
            begin
                if(wait_state == WAIT_I || is_base)
                begin
                    base_ram_ce_n <= 0;
                    base_ram_oe_n <= 0;
                end
                else
                begin
                    ext_ram_ce_n <= 0;
                    ext_ram_oe_n <= 0;
                end
            end
        end 
        else if(curr_state == RET)
        begin
            if(wait_state == WAIT_I)
                memory_ready_for_ICache <= 1;
            else
                memory_ready_for_DCache <= 1;
        end
    end
    
    assign write_cache_full = (cache_cnt == 4);

endmodule
