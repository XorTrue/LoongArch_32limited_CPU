`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/16 16:16:53
// Design Name: 
// Module Name: decoder
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

module decoder(
    input [`WORD-1:0] inst,
    output reg [`OPCODE_LEN-1:0] ALU_opcode,
    output reg [`OPCODE_LEN-1:0] CMP_opcode,
    output [1:0] REG_WB,
    output [1:0] MEM,
    output [8:0] EX
    );

    wire REG_write = 
        (inst[31:26] == 6'b010011) |    // JIRL
        (inst[31:26] == 6'b010101) |    // BL
        ~inst[30];                      // 其他非跳转指令
    reg [1:0] RES_MUX;
    always@(*)
    begin
        casex({inst[30:29]})
            2'b1x   : RES_MUX = `RES_CMP; // 跳转指令
            2'b01   : RES_MUX = `RES_MEM; // 访存指令
            default : RES_MUX = `RES_ALU; // 默认来自 ALU
        endcase
    end
    assign REG_WB = {REG_write, RES_MUX};
    

    wire MEM_read  = (inst[31:24] == 8'b00101000); // Load 
    wire MEM_write = (inst[31:24] == 8'b00101001); // Store
    assign MEM = {MEM_read, MEM_write};

    wire branch = (inst[31:30] == 2'b01);  //只有跳转指令需要 branch 
    reg ALU_in0_MUX, ALU_in1_MUX;
    
    





endmodule
