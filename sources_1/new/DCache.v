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
    input is_io,
    input [1:0] is_dmem,
    input [`WORD-1:0] addr,
    input [`WORD-1:0] data_to_store,
    //input pipeline_valid,
    input memory_ready,
    input [`CACHE_LINE_WIDTH-1:0] data_from_mem,

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
    wire [1:0] req_dmem;
    Request_Buffer #(2) LS_Buffer(
        .clk(clk), .rst(rst),
        .we(rbuf_we),
        .in(is_dmem & {2{~is_io}}),
        .out(req_dmem)
    );


    wire ret_we;
    wire [`CACHE_LINE_WIDTH-1:0] data_w;
    wire [`WORD-1:0] data_from_ret;
    Return_Buffer Return_Buffer(
        .clk(clk), .rst(rst),
        .we(ret_we),
        .addr(req_addr[`CACHE_LINE_BYTE_LOG-1:2]),
        .in(data_from_mem),
        .out(data_w),
        .ret(data_from_ret)
    );

    parameter TAG_WIDTH = `WORD-1-`RAM_DEPTH_LOG-`CACHE_LINE_BYTE_LOG+1;
    wire [`RAM_DEPTH_LOG-1:0] addr_r = 
        addr[`RAM_DEPTH_LOG+`CACHE_LINE_BYTE_LOG-1:`CACHE_LINE_BYTE_LOG];
    wire [`RAM_DEPTH_LOG-1:0] addr_w = 
        req_addr[`RAM_DEPTH_LOG+`CACHE_LINE_BYTE_LOG-1:`CACHE_LINE_BYTE_LOG];
    wire Cache_we_w;
    wire [`CACHE_LINE_WIDTH-1:0] Cache_data_r;
    wire [TAG_WIDTH-1:0] tag_w = 
        req_addr[`WORD-1:`RAM_DEPTH_LOG+`CACHE_LINE_BYTE_LOG];
    wire [TAG_WIDTH-1:0] tag_r;
    wire hit;

    wire en_r;
    wire [`CACHE_LINE_WIDTH-1:0] data_w_act;
    BRAM_SDPSC #(`CACHE_LINE_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "")  
    Cache_Data (
        .clk(clk), 
        .addr_w(addr_w),
        .addr_r(addr_r),
        .din_w(data_w_act),
        .we_w(Cache_we_w),
        .en_r(en_r),
        .dout_r(Cache_data_r)
    );
    BRAM_SDPSC #(TAG_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "") 
    TAG (
        .clk(clk),
        .addr_w(addr_w),
        .addr_r(addr_r),
        .din_w(tag_w),
        .we_w(Cache_we_w),
        .en_r(en_r),
        .dout_r(tag_r)
    );
    assign hit = (tag_r == tag_w);

    reg [`WORD-1:0] data_from_cache;
    always@(*)
    begin
        case(req_addr[`CACHE_LINE_BYTE_LOG-1:2])
            2'b00: data_from_cache = Cache_data_r[`WORD-1:0];
            2'b01: data_from_cache = Cache_data_r[`WORD*2-1:`WORD];
            2'b10: data_from_cache = Cache_data_r[`WORD*3-1:`WORD*2];
            2'b11: data_from_cache = Cache_data_r[`WORD*4-1:`WORD*3];
            default: data_from_cache = 0;
        endcase
    end

    wire is_data_from_mem;
    assign data = is_data_from_mem ? data_from_ret : data_from_cache;
    
    wire is_direct;
    reg [`CACHE_LINE_WIDTH-1:0] data_direct;
    always@(*)
    begin
        case(req_addr[`CACHE_LINE_BYTE_LOG-1:2])
            2'b00: data_direct = {Cache_data_r[`WORD*4-1:`WORD], req_data};
            2'b01: data_direct = {Cache_data_r[`WORD*4-1:`WORD*2], req_data, Cache_data_r[`WORD-1:0]};
            2'b10: data_direct = {Cache_data_r[`WORD*4-1:`WORD*3], req_data, Cache_data_r[`WORD*2-1:0]};
            2'b11: data_direct = {req_data, Cache_data_r[`WORD*3-1:0]};
            default: data_direct = 0;
        endcase
    end
    assign data_w_act = is_direct ? data_direct : data_from_mem;

    DCache_FSM DCache_FSM(
        .clk(clk), .rst(rst),
        .hit(hit),
        .is_dmem(req_dmem),
        .memory_ready(memory_ready),
        .rbuf_we(rbuf_we),
        .en_r(en_r),
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
