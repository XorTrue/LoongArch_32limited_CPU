`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 16:28:41
// Design Name: 
// Module Name: IO
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

module IO(
    input is_io,
    input is_state,
    input is_dmem,
    input [`WORD-1:0] r_data,
    input [`WORD-1:0] data_to_t,
    input ready,
    input busy,
    output reg clear = 0,
    output reg start = 0,
    output reg [`WORD-1:0] data_out = 0
    );

    wire [`WORD-1:0] io_state = {30'b0, ready, ~busy};

    wire is_load, is_store;
    assign {is_store, is_load} = is_dmem;

    always@(*)
    begin
        clear = 0;
        start = 0;
        data_out = 0;
        if(is_io)
        begin
            if(is_load)
            begin
                data_out = is_state ? io_state : r_data;
                clear = ~is_state;
            end
            else if(is_store)
            begin
                data_out = data_to_t;
                start = 1;
            end
        end
    end
    
endmodule
