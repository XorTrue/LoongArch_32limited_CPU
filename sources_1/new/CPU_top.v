`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 17:14:58
// Design Name: 
// Module Name: CPU_top
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

module CPU_top(
    input clk, rst,

    input ext_uart_ready,
    input ext_uart_busy,
    input [`WORD-1:0] r_data,
    output ext_uart_clear,
    output ext_uart_start,
    output [`WORD-1:0] t_data,

    output base_ram_ce_n,
    output base_ram_oe_n,
    output base_ram_we_n,
    output [19:0] base_ram_addr,
    inout [31:0] base_ram_data,

    output ext_ram_ce_n,
    output ext_ram_oe_n,
    output ext_ram_we_n,
    output [19:0] ext_ram_addr,
    output [31:0] ext_ram_data_r,
    output [31:0] ext_ram_data_w,


    output [`WORD-1:0] PC_IF0_out,
    output Pre_Branch_out,
    output [`WORD-1:0] Pre_PC_out,
    output EX_Branch_out,
    output [`WORD-1:0] EX_PC_out,
    output [`WORD-1:0] PC_IF1_out,
    output [`WORD-1:0] inst_IF1_out,
    output [`WORD-1:0] PC_ID_out,
    output [`WORD-1:0] inst_ID_out,
    output [`WORD-1:0] PC_EX_out,
    output [`WORD-1:0] inst_EX_out,
    output [`WORD-1:0] PC_MEM_out,
    output [`WORD-1:0] inst_MEM_out,
    output [`WORD-1:0] PC_WB_out,
    output [`WORD-1:0] inst_WB_out
    );

    wire Pre_Branch, EX_Branch;
    wire [`WORD-1:0] Pre_PC, EX_PC;
    wire stall_from_ICache;
    wire stall_from_DCache;
    wire stall_from_Load;
    wire flush_from_Load;
    wire fix_branch;
    wire [`WORD-1:0] PC_IF0;
    IF0 IF0(
        .clk(clk), .rst(rst),
        .Pre_Branch(Pre_Branch), 
        .Pre_PC(Pre_PC), 
        .EX_Branch(EX_Branch), 
        .EX_PC(EX_PC), 
        .PC_stall_from_ICache(stall_from_ICache),
        .PC_stall_from_Load(stall_from_Load),
        .PC_stall_from_DCache(stall_from_DCache), 
        .fix_branch(fix_branch),
        .PC_out(PC_IF0)
    );

    wire [`WORD-1:0] PC_IF1;
    wire ICache_valid_in = 1;
    wire ICache_valid;
    IF0_IF1 IF0_IF1(
        .clk(clk), .rst(rst),
        .EX_Branch(EX_Branch),
        .Pre_Branch(Pre_Branch),
        .IF0_IF1_stall_from_ICache(stall_from_ICache),
        .IF0_IF1_stall_from_Load(stall_from_Load),
        .IF0_IF1_stall_from_DCache(stall_from_DCache),
        .fix_branch(fix_branch),
        .IF0_IF1_PC_in(PC_IF0), 
        .IF0_IF1_PC_out(PC_IF1), 
        .ICache_valid_in(ICache_valid_in),
        .ICache_valid_out(ICache_valid)
    );

    wire ICache_ready;
    wire memory_ready_for_ICache;
    wire [`CACHE_LINE_WIDTH-1:0] inst_from_mem;
    wire [`WORD-1:0] load_inst_addr;
    wire memory_valid_for_ICache;
    wire [`WORD-1:0] inst_ICache;
    ICache ICache(
        .clk(clk),
        .rst(rst),
        .ICache_stall_from_DCache(stall_from_DCache),
        .ICache_stall_from_Load(stall_from_Load),
        .Pre_Branch(Pre_Branch),
        .EX_Branch(EX_Branch),
        .PC(PC_IF0),
        .pipeline_valid(ICache_valid_in),
        .memory_ready(memory_ready_for_ICache),
        .inst_from_mem(inst_from_mem),
        .load_addr(load_inst_addr),
        .pipeline_ready(ICache_ready),
        .memory_valid(memory_valid_for_ICache),
        .fix_branch(fix_branch),
        .inst(inst_ICache)
    );

    /*wire we_w_i = 0;
    wire [`RAM_DEPTH_LOG-1:0] addr_r_i = PC_IF0[`RAM_DEPTH_LOG+1:2];
    wire [`WORD-1:0] inst_ICache_i;
    BRAM_SDPSC #(`WORD, `RAM_DEPTH, `RAM_PERFORMANCE, "D:/XorTrue/LoongArch/Project/Project.srcs/inst_init.txt") 
    I_MEM_test(
        .clk(clk),
        .addr_w(0),
        .addr_r(addr_r_i),
        .din_w(0),
        .we_w(we_w_i),
        .en_r(~(stall_from_Load | stall_from_DCache) && ~rst),
        .dout_r(inst_ICache_i)
    );
    assign ICache_ready = 1;
    reg [`WORD-1:0] inst_ICache_o;
    always@(negedge clk)
    begin
        if(rst | Pre_Branch)
            inst_ICache_o <= 0;
        else
            inst_ICache_o <= inst_ICache_i;
    end
    assign inst_ICache = inst_ICache_o;*/

    wire predict;
    Predict_2bit Predict_2bit(
        .clk(clk), .rst(rst),
        .EX_Branch(EX_Branch),
        .predict_out(predict)
    );
    

    wire flush_from_ICache;
    IF1 IF1(
        .predict(predict), 
        .IF1_PC_in(PC_IF1),
        .inst(inst_ICache),
        .ICache_valid(ICache_valid), .ICache_ready(ICache_ready),
        .Pre_Branch_out(Pre_Branch), 
        .Pre_PC_out(Pre_PC),
        .stall_from_ICache(stall_from_ICache),
        .flush_from_ICache(flush_from_ICache)
    );

    //wire IF1_ID_stall_from_DCache;
    //wire IF1_ID_flush_from_EX_Branch;
    wire [`WORD-1:0] PC_ID;
    wire [`WORD-1:0] inst_ID;
    IF1_ID IF1_ID(
        .clk(clk), .rst(rst),
        .IF1_ID_stall_from_DCache(stall_from_DCache),
        .IF1_ID_flush_from_EX_Branch(EX_Branch),
        .IF1_ID_stall_from_Load(stall_from_Load),
        .IF1_ID_flush_from_ICache(flush_from_ICache),
        //.IF1_ID_flush_from_Pre_Branch(Pre_Branch),
        .IF1_ID_PC_in(PC_IF1),
        .IF1_ID_PC_out(PC_ID),
        .IF1_ID_inst_in(inst_ICache),
        .IF1_ID_inst_out(inst_ID)
    );

    wire REG_write;
    wire [`REG_LOG-1:0] REG_write_addr;
    wire [`WORD-1:0] REG_write_data;
    wire [`OPCODE_LEN*2-1:0] opcode_ID;
    wire [7:0] CTRL_EX_ID;
    wire [`REG_LOG*3-1:0] rs_ID;
    wire [`WORD*3-1:0] src_ID;
    wire [`WORD*2-1:0] CONST_ID;
    ID ID(
        .clk(clk), .rst(rst),
        .inst(inst_ID),
        .REG_write(REG_write), 
        .REG_write_addr(REG_write_addr), 
        .REG_write_data(REG_write_data),
        .opcode(opcode_ID),
        .CTRL_EX(CTRL_EX_ID),
        .rs(rs_ID),
        .src(src_ID),
        .CONST(CONST_ID)
    );
    

    //wire ID_EX_stall_from_DCache;
    //wire ID_EX_flush_from_EX_Branch;
    wire [`WORD-1:0] PC_EX;
    wire [`WORD-1:0] inst_EX;
    wire [`OPCODE_LEN*2-1:0] opcode_EX;
    wire [7:0] CTRL_EX_EX;
    wire [`REG_LOG*3-1:0] rs_EX;
    wire [`WORD*3-1:0] src_EX;
    wire [`WORD*2-1:0] CONST_EX;
    ID_EX ID_EX(
        .clk(clk), .rst(rst),
        .ID_EX_stall_from_DCache(stall_from_DCache),
        .ID_EX_flush_from_EX_Branch(EX_Branch),
        .ID_EX_flush_from_Load(flush_from_Load),
        .ID_EX_PC_in(PC_ID),
        .ID_EX_PC_out(PC_EX),
        .ID_EX_inst_in(inst_ID),
        .ID_EX_inst_out(inst_EX),
        .ID_EX_opcode_in(opcode_ID),
        .ID_EX_opcode_out(opcode_EX),
        .ID_EX_CTRL_EX_in(CTRL_EX_ID),
        .ID_EX_CTRL_EX_out(CTRL_EX_EX),
        .ID_EX_rs_in(rs_ID),
        .ID_EX_rs_out(rs_EX),
        .ID_EX_src_in(src_ID),
        .ID_EX_src_out(src_EX),
        .ID_EX_CONST_in(CONST_ID),
        .ID_EX_CONST_out(CONST_EX)
    );

    wire [5:0] fwd;
    wire [`WORD-1:0] src_MEM;
    wire [`WORD-1:0] src_WB;
    wire CAL_MUL;
    wire [`WORD-1:0] ALU_res;
    wire [`WORD*3-1:0] src_fwd;
    wire [1:0] is_dmem;
    wire [1:0] io_info;
    EX EX(
        .clk(clk), .rst(rst),
        .PC(PC_EX),
        .inst(inst_EX),
        .opcode(opcode_EX),
        .CTRL_EX(CTRL_EX_EX),
        .rs(rs_EX),
        .src(src_EX),
        .CONST(CONST_EX),
        .fwd(fwd),
        .src_from_MEM(src_MEM),
        .src_from_WB(src_WB),
        .predict(predict),
        .EX_Branch_out(EX_Branch),
        .EX_PC_out(EX_PC),
        .CAL_MUL(CAL_MUL),
        .ALU_out(ALU_res),
        .src_fwd(src_fwd),
        .is_dmem(is_dmem),
        .io_info(io_info)
    );

    wire [`WORD-1:0] src0_fwd, src1_fwd, src2_fwd;
    assign {src2_fwd, src1_fwd, src0_fwd} = src_fwd;
    wire sign;
    wire [`WORD-1:0] mul00, mul01, mul10;
    MUL_ST0 MUL_ST0(
        .src0(src1_fwd),
        .src1(src2_fwd),
        .sign(sign),
        .mul00(mul00),
        .mul01(mul01),
        .mul10(mul10)
    );
    wire [`WORD*3-1:0] mul_tmp = {mul10, mul01, mul00};

    //wire EX_MEM_stall_from_DCache;
    wire [`WORD-1:0] PC_MEM;
    wire [`WORD-1:0] inst_MEM;
    wire [7:0] CTRL_EX_MEM;
    wire CAL_SEL;
    wire [`WORD-1:0] ALU_res_MEM;
    wire [`REG_LOG*3-1:0] rs_MEM;
    wire sign_reg;
    wire [`WORD*3-1:0] mul_tmp_reg;
    wire [1:0] is_dmem_MEM;
    wire [1:0] io_info_MEM;
    wire [`WORD-1:0] data_to_t_MEM;
    EX_MEM EX_MEM(
        .clk(clk), .rst(rst),
        .EX_MEM_stall_from_DCache(stall_from_DCache),
        .EX_MEM_PC_in(PC_EX),
        .EX_MEM_PC_out(PC_MEM),
        .EX_MEM_inst_in(inst_EX),
        .EX_MEM_inst_out(inst_MEM),
        .EX_MEM_CTRL_EX_in(CTRL_EX_EX),
        .EX_MEM_CTRL_EX_out(CTRL_EX_MEM),
        .CAL_SEL_in(CAL_MUL),
        .CAL_SEL_out(CAL_SEL),
        .ALU_res_in(ALU_res),
        .ALU_res_out(ALU_res_MEM),
        .EX_MEM_rs_in(rs_EX),
        .EX_MEM_rs_out(rs_MEM),
        .sign_in(sign),
        .sign_out(sign_reg),
        .mul_tmp_in(mul_tmp),
        .mul_tmp_out(mul_tmp_reg),
        .is_dmem_in(is_dmem),
        .is_dmem_out(is_dmem_MEM),
        .io_info_in(io_info),
        .io_info_out(io_info_MEM),
        .data_to_t_in(src1_fwd),
        .data_to_t_out(data_to_t_MEM)
    );

    wire [`WORD-1:0] mu00_in, mul01_in, mul10_in;
    assign {mul10_in, mul01_in, mul00_in} = mul_tmp_reg;
    wire [`WORD-1:0] mul_res;
    MUL_ST1 MUL_ST1(
        .sign(sign_reg),
        .mul00(mul00_in),
        .mul01(mul01_in),
        .mul10(mul10_in),
        .mul_res(mul_res)
    );

    wire DCache_ready;
    wire [`WORD-1:0] data_DCache;
    wire memory_valid_for_DCache;
    wire memory_ready_for_DCache;
    wire memory_for_store;
    wire [`WORD-1:0] load_store_data_addr;
    wire [`WORD-1:0] data_to_mem;
    wire [`CACHE_LINE_WIDTH-1:0] data_from_mem;
    DCache DCache(
        .clk(clk), .rst(rst),
        .is_io(io_info[0]),
        .is_dmem(is_dmem),
        .addr(ALU_res),
        .data_to_store(src0_fwd),
        //.pipeline_valid()
        .memory_ready(memory_ready_for_DCache),
        .data_from_mem(data_from_mem),
        .load_store_addr(load_store_data_addr),
        .pipeline_ready(DCache_ready),
        .memory_valid(memory_valid_for_DCache),
        .memory_for_store(memory_for_store),
        .data(data_DCache),
        .data_to_mem(data_to_mem)
    );


    /*wire [`RAM_DEPTH_LOG-1:0] addr_r_d = ALU_res[`RAM_DEPTH_LOG+1:2];
    wire [`RAM_DEPTH_LOG-1:0] addr_w_d = ALU_res[`RAM_DEPTH_LOG+1:2];
    wire en_r_d = (inst_EX[31:24] == 8'b00101000);
    wire we_w_d = (inst_EX[31:24] == 8'b00101001); 
    BRAM_SDPSC #(`WORD, `RAM_DEPTH, `RAM_PERFORMANCE, "")
    D_MEM_test(
        .clk(clk),
        .addr_w(addr_w_d),
        .addr_r(addr_r_d),
        .din_w(src0_fwd),
        .we_w(we_w_d),
        .en_r(en_r_d),
        .dout_r(data_DCache)
    );
    assign DCache_ready = 1;*/

    wire REG_wrtie_MEM;
    wire [`WORD-1:0] CAL_res;
    wire flush_from_DCache;
    wire [`WORD-1:0] data_MEM;
    MEM MEM(
        .clk(clk), .rst(rst),
        .io_info(io_info_MEM),
        .is_dmem(is_dmem_MEM),
        .CAL_SEL(CAL_SEL),
        .ALU_res(ALU_res_MEM),
        .MUL_res(mul_res),
        .CAL_res(CAL_res),
        .CTRL_EX(CTRL_EX_MEM),
        .REG_write_MEM(REG_write_MEM),
        .DCache_ready(DCache_ready),
        .stall_from_DCache(stall_from_DCache),
        .flush_from_DCache(flush_from_DCache),
        .data_DCache(data_DCache),
        .r_data(r_data),
        .data_to_t(data_to_t_MEM),
        .ready(ext_uart_ready),
        .busy(ext_uart_busy),
        .clear(ext_uart_clear),
        .start(ext_uart_start),
        .t_data(t_data),
        .data_out(data_MEM)
    );
    assign src_MEM = CAL_res;

    wire [`WORD-1:0] PC_WB;
    wire [`WORD-1:0] inst_WB;
    wire [7:0] CTRL_EX_WB;
    wire [`REG_LOG*3-1:0] rs_WB;
    wire [`WORD-1:0] CAL_res_WB;
    wire [`WORD-1:0] data_WB;
    MEM_WB MEM_WB(
        .clk(clk), .rst(rst),
        .MEM_WB_flush_from_DCache(flush_from_DCache),
        .MEM_WB_PC_in(PC_MEM),
        .MEM_WB_PC_out(PC_WB),
        .MEM_WB_inst_in(inst_MEM),
        .MEM_WB_inst_out(inst_WB),
        .MEM_WB_CTRL_EX_in(CTRL_EX_MEM),
        .MEM_WB_CTRL_EX_out(CTRL_EX_WB),
        .MEM_WB_rs_in(rs_MEM),
        .MEM_WB_rs_out(rs_WB),
        .MEM_WB_CAL_res_in(CAL_res),
        .MEM_WB_CAL_res_out(CAL_res_WB),
        .MEM_WB_data_in(data_MEM),
        .MEM_WB_data_out(data_WB)
    );

    wire REG_write_WB;
    WB WB(
        .PC(PC_WB),
        .inst(inst_WB),
        .CTRL_EX(CTRL_EX_WB),
        .rs(rs_WB),
        .CAL_res(CAL_res_WB),
        .data(data_WB),
        .REG_write_WB(REG_write_WB),
        .rd(REG_write_addr),
        .WB_data(REG_write_data)
    );
    assign src_WB = REG_write_data;
    assign REG_write = REG_write_WB;

    Forwarding Forwarding(
        .rs_EX(rs_EX),
        .rd_MEM(rs_MEM[4:0]),
        .rd_WB(rs_WB[4:0]),
        .REG_write_MEM(REG_write_MEM),
        .REG_write_WB(REG_write_WB),
        .fwd(fwd)
    );

    Hazard Hazard(
        .CTRL_EX(CTRL_EX_EX),
        .rd_EX(rs_EX[4:0]),
        .rs_ID(rs_ID),
        .stall_from_Load(stall_from_Load),
        .flush_from_Load(flush_from_Load)
    );


    Cache_MEM Cache_MEM(
        .clk(clk), .rst(rst),
        .stall_from_Load(stall_from_Load),
        .EX_Branch(EX_Branch),
        .Pre_Branch(Pre_Branch),

        .memory_valid_for_ICache(memory_valid_for_ICache),
        .load_inst_addr(load_inst_addr),
        .memory_ready_for_ICache(memory_ready_for_ICache),
        .inst_from_mem(inst_from_mem),


        .memory_valid_for_DCache(memory_valid_for_DCache),
        .memory_for_store(memory_for_store),
        .load_store_data_addr(load_store_data_addr),
        .data_to_store(data_to_mem),
        .memory_ready_for_DCache(memory_ready_for_DCache),
        .data_from_mem(data_from_mem),

        .base_ram_ce_n(base_ram_ce_n),
        .base_ram_oe_n(base_ram_oe_n),
        .base_ram_we_n(base_ram_we_n),
        .base_ram_addr(base_ram_addr),
        .base_ram_data(base_ram_data),

        .ext_ram_ce_n(ext_ram_ce_n),
        .ext_ram_oe_n(ext_ram_oe_n),
        .ext_ram_we_n(ext_ram_we_n),
        .ext_ram_addr(ext_ram_addr),
        .ext_ram_data_r(ext_ram_data_r),
        .ext_ram_data_w(ext_ram_data_w)
    );

    BRAM_SDPSC #(`WORD, `RAM_DEPTH, `RAM_PERFORMANCE, "D:/XorTrue/LoongArch/Project/Project.srcs/inst_init.txt") 
    I_MEM_btm(
        .clk(clk),
        .addr_w(0),
        .addr_r(base_ram_addr[`RAM_DEPTH_LOG+1:2]),
        .din_w(0),
        .we_w(~base_ram_we_n),
        .en_r(~base_ram_oe_n),
        .dout_r(base_ram_data)
    );

    BRAM_SDPSC #(`WORD, `RAM_DEPTH, `RAM_PERFORMANCE, "")
    D_MEM_btm(
        .clk(clk),
        .addr_w(ext_ram_addr[`RAM_DEPTH_LOG+1:2]),
        .addr_r(ext_ram_addr[`RAM_DEPTH_LOG+1:2]),
        .din_w(ext_ram_data_w),
        .we_w(~ext_ram_we_n),
        .en_r(~ext_ram_oe_n),
        .dout_r(ext_ram_data_r)
    );

    assign PC_IF0_out = PC_IF0;
    assign PC_IF1_out = PC_IF1;
    assign inst_IF1_out = inst_ICache;
    assign PC_ID_out = PC_ID;
    assign inst_ID_out = inst_ID;
    assign PC_EX_out = PC_EX;
    assign inst_EX_out = inst_EX;
    assign PC_MEM_out = PC_MEM;
    assign inst_MEM_out = inst_MEM;
    assign PC_WB_out = PC_WB;
    assign inst_WB_out = inst_WB;
    assign Pre_Branch_out = Pre_Branch;
    assign Pre_PC_out = Pre_PC;
    assign EX_Branch_out = EX_Branch;
    assign EX_PC_out = EX_PC;

endmodule
