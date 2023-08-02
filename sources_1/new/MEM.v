`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 21:32:53
// Design Name: 
// Module Name: MEM
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

module MEM(
    input clk, rst,
    input [1:0] io_info,
    input [1:0] is_dmem,
    input CAL_SEL,
    input [`WORD-1:0] ALU_res,
    input [`WORD-1:0] MUL_res,
    input DCache_ready,
    input [7:0] CTRL_EX,
    input [`WORD-1:0] data_DCache,
    input [`WORD-1:0] r_data,
    input [`WORD-1:0] data_to_t,
    input ready,
    input busy,

    output REG_write_MEM,
    output [`WORD-1:0] CAL_res,
    output stall_from_DCache,
    output flush_from_DCache,
    output clear,
    output start,
    output [`WORD-1:0] t_data,
    output [`WORD-1:0] data_out
    );

    wire [1:0] REG_WB;
    wire [1:0] MEM;
    wire [3:0] EX;
    assign {REG_WB, MEM, EX} = CTRL_EX;
    wire RES_MUX;
    assign {REG_write_MEM, RES_MUX} = REG_WB;

    SEL_2 ALU_or_MUL(
        .sel(CAL_SEL),
        .in0(ALU_res),
        .in1(MUL_res),
        .out(CAL_res)
    );

    CTRL_from_DCache CTRL_from_DCache(
        .DCache_valid(|is_dmem),
        .DCache_ready(DCache_ready),
        .stall_from_DCache(stall_from_DCache),
        .flush_from_DCache(flush_from_DCache)
    );


    wire is_io, is_state;
    assign {is_state, is_io} = io_info;
    IO IO(
        .is_io(is_io),
        .is_state(is_state),
        .is_dmem(is_dmem),
        .r_data(r_data),
        .data_to_t(data_to_t),
        .ready(ready),
        .busy(busy),
        .clear(clear),
        .start(start),
        .data_out(t_data)
    );

    SEL2 MEM_or_IO(
        .sel(is_io),
        .in0(data_DCache),
        .in1(t_data),
        .out(data_out)
    );

endmodule
