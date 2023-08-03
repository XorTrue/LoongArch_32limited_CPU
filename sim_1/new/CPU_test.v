`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 10:18:37
// Design Name: 
// Module Name: CPU_test
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

module CPU_test(
    inout wire [31:0] base_ram_data,
    inout wire [31:0] ext_ram_data
    );

    reg clk = 0;
    reg rst = 1;
    initial 
        forever
            #5 clk = ~clk;

    initial
    begin
        #10 rst = 0;
    end


    wire base_ram_ce_n;
    wire base_ram_oe_n;
    wire base_ram_we_n;
    wire [19:0] base_ram_addr;
    wire [31:0] base_ram_data_r;
    wire [31:0] base_ram_data_w;

    wire ext_ram_ce_n;
    wire ext_ram_oe_n;
    wire ext_ram_we_n;
    wire [19:0] ext_ram_addr;
    wire [31:0] ext_ram_data_r;
    wire [31:0] ext_ram_data_w;

    wire [31:0] PC_IF0_out;
    wire [31:0] PC_IF1_out;
    wire [31:0] inst_IF1_out;
    wire [31:0] PC_ID_out;
    wire [31:0] inst_ID_out;
    wire [31:0] PC_EX_out;
    wire [31:0] inst_EX_out;
    wire [31:0] PC_MEM_out;
    wire [31:0] inst_MEM_out;
    wire [31:0] PC_WB_out;
    wire [31:0] inst_WB_out;
    wire Pre_Branch;
    wire [31:0] Pre_PC;
    wire EX_Branch;
    wire [31:0] EX_PC;
    CPU_top CPU_top(
        .clk(clk), .rst(rst),

        .base_ram_ce_n(base_ram_ce_n),
        .base_ram_oe_n(base_ram_oe_n),
        .base_ram_we_n(base_ram_we_n),
        .base_ram_addr(base_ram_addr),
        .base_ram_data_r(base_ram_data_r),
        .base_ram_data_w(base_ram_data_w),

        .ext_ram_ce_n(ext_ram_ce_n),
        .ext_ram_oe_n(ext_ram_oe_n),
        .ext_ram_we_n(ext_ram_we_n),
        .ext_ram_addr(ext_ram_addr),
        .ext_ram_data_r(ext_ram_data_r),
        .ext_ram_data_w(ext_ram_data_w),     

        .PC_IF0_out(PC_IF0_out),
        .Pre_Branch_out(Pre_Branch),
        .Pre_PC_out(Pre_PC),
        .EX_Branch_out(EX_Branch),
        .EX_PC_out(EX_PC),
        .PC_IF1_out(PC_IF1_out),
        .inst_IF1_out(inst_IF1_out),
        .PC_ID_out(PC_ID_out),
        .inst_ID_out(inst_ID_out),
        .PC_EX_out(PC_EX_out),
        .inst_EX_out(inst_EX_out),
        .PC_MEM_out(PC_MEM_out),
        .inst_MEM_out(inst_MEM_out),
        .PC_WB_out(PC_WB_out),
        .inst_WB_out(inst_WB_out)
    );
    assign base_ram_data_r = base_ram_data;
    assign ext_ram_data_r = ext_ram_data;
    assign base_ram_data = base_ram_we_n ? {32{1'bz}} : base_ram_data_w;
    assign ext_ram_data = ext_ram_we_n ? {32{1'bz}} : ext_ram_data_w;

    wire [31:0] base_ram_data_r_m;
    wire [31:0] base_ram_data_w_m;
    BRAM_SDPSC #(32, 64, "LOW_LATENCY", "D:/XorTrue/LoongArch/Project/Project.srcs/inst_init.txt") 
    I_MEM_btm(
        .clk(clk),
        .addr_w(0),
        .addr_r(base_ram_addr[6+1:2]),
        .din_w(base_ram_data_w_m),
        .we_w(~base_ram_we_n),
        .en_r(~base_ram_oe_n),
        .dout_r(base_ram_data_r_m)
    );
    assign base_ram_data_w_m = base_ram_data;
    assign base_ram_data = base_ram_oe_n ? {32{1'bz}} : base_ram_data_r_m;

    wire [31:0] ext_ram_data_r_m;
    wire [31:0] ext_ram_data_w_m;
    BRAM_SDPSC #(32, 64, "LOW_LATENCY", "")
    D_MEM_btm(
        .clk(clk),
        .addr_w(ext_ram_addr[6+1:2]),
        .addr_r(ext_ram_addr[6+1:2]),
        .din_w(ext_ram_data_w_m),
        .we_w(~ext_ram_we_n),
        .en_r(~ext_ram_oe_n),
        .dout_r(ext_ram_data_r_m)
    );
    assign ext_ram_data_w_m = ext_ram_data;
    assign ext_ram_data = ext_ram_oe_n ? {32{1'bz}} : ext_ram_data_r_m;

endmodule
