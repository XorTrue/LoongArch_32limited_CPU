`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 16:34:20
// Design Name: 
// Module Name: ICache
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


module ICache(
    input clk, rst,
    input stall,
    input flush,
    input [`WORD-1:0] PC,
    input pipeline_valid,
    input memory_ready,
    input [`CACHE_LINE_WIDTH-1:0] inst_from_mem,

    output [`WORD-1:0] load_addr,
    output pipeline_ready,
    output memory_valid,
    output [`WORD-1:0] inst
    );

    wire rbuf_we;
    wire [`WORD-1:0] req_addr; 
    Request_Buffer Request_Buffer(
        .clk(clk), .rst(rst),
        .we(rbuf_we | ~stall),
        .in(PC),
        .out(req_addr)
    );

    wire ret_we;
    wire [`CACHE_LINE_WIDTH-1:0] data_w;
    wire [`WORD-1:0] inst_from_ret;
    Return_Buffer Return_Buffer(
        .clk(clk), .rst(rst),
        .we(ret_we),
        .in(inst_from_mem),
        .out(data_w),
        .inst(inst_from_ret)
    );


    parameter TAG_WIDTH = `WORD-1-`RAM_DEPTH_LOG-`CAHCE_LINE_BTYE_LOG+1;
    wire [`RAM_DEPTH_LOG-1:0] addr_r = 
        PC[`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG-1:`CAHCE_LINE_BTYE_LOG];
    wire [`RAM_DEPTH_LOG-1:0] addr_w = 
        req_addr[`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG-1:`CAHCE_LINE_BTYE_LOG];
    wire [`CACHE_WAY-1:0] Cache_we_w;
    wire [`CACHE_LINE_WIDTH-1:0] Cache_data_r [0:`CACHE_WAY-1];
    wire [TAG_WIDTH-1:0] tag_w = 
        req_addr[`WORD-1:`RAM_DEPTH_LOG+`CAHCE_LINE_BTYE_LOG];
    wire [TAG_WIDTH-1:0] tag_r [`CACHE_WAY-1:0];
    wire [`CACHE_WAY-1:0] hit;
    genvar i;
    generate
        for(i = 0; i <= `CACHE_WAY - 1; i = i + 1)
        begin : Cache
            BRAM_SDPSC #(`CACHE_LINE_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "")  
            Cache_Data (
                .clk(clk), 
                .addr_w(addr_w),
                .addr_r(addr_r),
                .din_w(data_w),
                .we_w(Cache_we_w[i]),
                .en_r(~stall),
                .dout_r(Cache_data_r[i])
            );
            BRAM_SDPSC #(TAG_WIDTH, `RAM_DEPTH, `RAM_PERFORMANCE, "")  
            TAG (
                .clk(clk),
                .addr_w(addr_w),
                .addr_r(addr_r),
                .din_w(tag_w),
                .we_w(Cache_we_w[i]),
                .en_r(~stall),
                .dout_r(tag_r[i])
            );
            assign hit[i] = (tag_r[i] == tag_w);
        end
    endgenerate

    wire select_way;
    wire [`CACHE_LINE_WIDTH-1:0] way_data;
    assign way_data = Cache_data_r[select_way];

    wire [`WORD-1:0] inst_from_cache;
    assign inst_from_cache = way_data;

    wire is_inst_from_mem;
    wire [`WORD-1:0] inst_i = is_inst_from_mem ? inst_from_ret : inst_from_cache;
    reg [`WORD-1:0] inst_reg = 0;
    always@(negedge clk)
    begin
        if(rst | flush)
            inst_reg <= 0;
        else
            inst_reg <= inst_i;
    end
    assign inst = inst_reg;


    wire way_to_replace;
    Way_Select_LRU Way_Select_LRU(
        .clk(clk),
        .hit(hit),
        .addr(addr_r),
        .way_sel_update(~(stall | flush)),
        .way_sel(way_to_replace)
    );

    ICache_FSM ICache_FSM(
        .clk(clk),
        .rst(rst | flush | stall),
        .hit(hit),
        .way_to_replace(way_to_replace),
        .pipeline_valid(pipeline_valid),
        .memory_ready(memory_ready),
        .addr(req_addr),
        .load_addr(load_addr),
        .select_way(select_way),
        .rbuf_we(rbuf_we),
        .ret_we(ret_we),
        .pipeline_ready(pipeline_ready),
        .Cache_we_w(Cache_we_w),
        .is_inst_from_mem(is_inst_from_mem),
        .memory_valid(memory_valid)
    );

endmodule
