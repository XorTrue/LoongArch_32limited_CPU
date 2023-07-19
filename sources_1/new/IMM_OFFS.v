`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 20:00:35
// Design Name: 
// Module Name: IMM
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

module IMM(
    input [`WORD-1:0] inst,
    output reg [`WORD-1:0] imm,
    output [`WORD-1:0] offs
    );
 
    wire [`WORD-1:0] si12  = { {21{inst[21]}}, inst[20:10] };
    wire [`WORD-1:0] ui12  = { {20{1'b0}},     inst[21:10] };
    wire [`WORD-1:0] si20  = { {13{inst[24]}}, inst[23: 5] };
    wire [`WORD-1:0] ui5   = { {27{1'b0}},     inst[14:10] };
    wire [`WORD-1:0] usi12 = { {21{inst[24] & inst[21]}}, inst[20:10] };
    
    always@(*)
    begin
        casex({inst[30:28], inst[25], inst[22]})
            5'b1xxxx : imm = 32'h4;
            5'b01xxx : imm = si12;
            5'b001xx : imm = si20;
            5'b0001x : imm = usi12;
            5'b00001 : imm = ui5;
            default : imm = `UNDEFINE;
        endcase
    end

    assign offs  = { {17{inst[25]}}, inst[24:10] };

    /*always@(*)
    begin
        if(     inst[31])
            imm = `UNDEFINE;
        else if(inst[30]) //跳转指令
            imm = 32'h4; 
        else if(inst[29]) //访存指令
        begin
            if(~inst[28] & inst[27])
                imm = si12;  
            else
                imm = `UNDEFINE;
        end
        else if(inst[28]) //加载立即数指令
            imm = si20;
        else if(|inst[27:26]) //TLB & 特权指令
            imm = `UNDEFINE;
        else if(inst[25]) //整型立即数运算指令
        begin
            if(inst[24])
                imm = si12;
            else
                imm = ui12;
        end
        else if(|inst[24:23]) //浮点运算指令
            imm = `UNDEFINE;
        else if(inst[22]) //移位指令
            imm = ui5;
        else
            imm = `UNDEFINE;
    end*/

endmodule
