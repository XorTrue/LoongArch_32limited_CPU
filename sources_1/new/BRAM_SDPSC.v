`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/30 16:42:05
// Design Name: 
// Module Name: BRAM_SDPSC
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

module BRAM_SDPSC # (
    parameter RAM_WIDTH = `RAM_WIDTH,                 
    parameter RAM_DEPTH = `RAM_DEPTH,                
    parameter RAM_PERFORMANCE = "LOW_LATENCY",
    parameter INIT_FILE = ""                      
)(  input clk,
    input [clogb2(RAM_DEPTH-1)-1:0] addr_w, 
    input [clogb2(RAM_DEPTH-1)-1:0] addr_r, 
    input [RAM_WIDTH-1:0] din_w,                                  
    input we_w,
    input en_r,   
    input rst_r,
    input reg_ce_r,                                                                                              
    output [RAM_WIDTH-1:0] dout_r              
    );

    reg [RAM_WIDTH-1:0] ram [RAM_DEPTH-1:0];
    reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

    generate
        if (INIT_FILE != "") 
        begin: use_init_file
            initial
                $readmemh(INIT_FILE, ram, 0, RAM_DEPTH-1);
        end 
        else 
        begin: init_bram_to_zero
            integer ram_index;
            initial
                for(ram_index = 0;ram_index < RAM_DEPTH;ram_index = ram_index + 1)
                    ram[ram_index] = {RAM_WIDTH{1'b0}};
        end
    endgenerate

    always@(posedge clk) 
    begin
        if(we_w)
            ram[addr_w] <= din_w;
        if(en_r)
            ram_data <= ram[addr_r];
    end

    generate
        if (RAM_PERFORMANCE == "LOW_LATENCY") 
        begin: no_output_register
            assign dout_r = ram_data;
        end 
        else 
        begin: output_register //"HIGH_PERFORMANCE"
            reg [RAM_WIDTH-1:0] dout_r_reg = {RAM_WIDTH{1'b0}};
            always@(posedge clk)
            begin
                if (rst_r)
                    dout_r_reg <= {RAM_WIDTH{1'b0}};
                else if (reg_ce_r)
                    dout_r_reg <= ram_data;
            end
            assign dout_r = dout_r_reg;
        end
    endgenerate

    function integer clogb2;
        input integer depth;
        for(clogb2 = 0;depth > 0;clogb2 = clogb2 + 1)
            depth = depth >> 1;
    endfunction

endmodule


