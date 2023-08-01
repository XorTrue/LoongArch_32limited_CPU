`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:34:31
// Design Name: 
// Module Name: DCache
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

module DCache(
    input clk, rst,
    input [1:0] is_dmem,
    input [`WORD-1:0] addr,
    input [`WORD-1:0] data_to_store,
    input pipeline_valid,
    input memory_ready,
    input [`WORD-1:0] data_from_mem,

    output [`WORD-1:0] load_store_addr,
    output pipeline_ready,
    output memory_valid,
    output memory_for_store,
    output [`WORD-1:0] data,
    output [`WORD-1:0] data_to_mem
    );

    wire rbuf_we;
    wire [`WORD-1:0] req_addr;
    Request_Buffer Request_Buffer(
        .clk(clk), .rst(rst),
        .we(rbuf_we),
        .in(addr),
        .out(req_addr)
    );
    wire [`WORD-1:0] req_data;
    Request_Buffer Data_Buffer(
        .clk(clk), .rst(rst),
        .we(rbuf_we),
        .in(data_to_store),
        .out(req_data)
    );

    wire ret_we;
    wire [`CACHE_LINE_WIDTH-1:0] data_w;
    wire [`WORD-1:0] data_from_ret;
    Return_Buffer Return_Buffer(
        .clk(clk), .rst(rst),
        .we(ret_we),
        .in(data_from_mem),
        .out(data_w),
        .inst(data_from_ret)
    );

    parameter TAG_WIDTH = `WORD-1-`RAM_DEPTH_LOG-`CAHCE_LINE_BTYE_LOG+1;
    wire [`RAM_DEPTH_LOG-1:0] addr_r = 
        addr[`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG-1:`CAHCE_LINE_BTYE_LOG];
    wire [`RAM_DEPTH_LOG-1:0] addr_w = 
        req_addr[`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG-1:`CAHCE_LINE_BTYE_LOG];
    wire Cache_we_w;
    wire [`CACHE_LINE_WIDTH-1:0] Cache_data_r;
    wire [TAG_WIDTH-1:0] tag_w = 
        req_addr[`WORD-1:`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG];
    wire [TAG_WIDTH-1:0] tag_r;
    wire hit;

    wire [`WORD-1:0] data_w_act;
    BRAM_SDPSC #(`CACHE_LINE_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "")  
    Cache_Data (
        .clk(clk), 
        .addr_w(addr_w),
        .addr_r(addr_r),
        .din_w(data_w_act),
        .we_w(Cache_we_w),
        .en_r(1),
        .dout_r(Cache_data_r)
    );
    BRAM_SDPSC #(TAG_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "") 
    TAG (
        .clk(clk),
        .addr_w(addr_w),
        .addr_r(addr_r),
        .din_w(tag_w),
        .we_w(Cache_we_w),
        .en_r(1),
        .dout_r(tag_r)
    );
    assign hit = (tag_r == tag_w);

    wire [`WORD-1:0] data_from_cache;
    assign data_from_cache = Cache_data_r;

    wire is_data_from_mem;
    assign data = is_data_from_mem ? data_from_ret : data_from_cache;

    wire is_direct;
    assign data_w_act = is_direct ? req_data : data_w;

    DCache_FSM DCache_FSM(
        .clk(clk), .rst(rst),
        .hit(hit),
        .is_dmem(is_dmem),
        .memory_ready(memory_ready),
        .rbuf_we(rbuf_we),
        .ret_we(ret_we),
        .pipeline_ready(pipeline_ready),
        .Cache_we_w(Cache_we_w),
        .is_data_from_mem(is_data_from_mem),
        .is_direct(is_direct),
        .memory_valid(memory_valid),
        .memory_for_store(memory_for_store)
    );
    
    
    assign load_store_addr = req_addr;
    assign data_to_mem = req_data;
endmodule
