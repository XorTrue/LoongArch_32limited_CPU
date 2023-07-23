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

module Decoder(
    input [`WORD-1:0] inst,
    output reg [`OPCODE_LEN-1:0] ALU_opcode,
    output reg [`OPCODE_LEN-1:0] CMP_opcode,
    output [1:0] REG_WB,
    output [1:0] MEM,
    output [3:0] EX
    );

    wire REG_write = 
        (inst[31:26] == 6'b010011) |    // JIRL
        (inst[31:26] == 6'b010101) |    // BL
        ~inst[30];                      // 其他非跳转指令
    /*reg [1:0] RES_MUX;
    always@(*)
    begin
        casex({inst[30:29]})
            2'b1x   : RES_MUX = `RES_CMP; // 跳转指令
            2'b01   : RES_MUX = `RES_MEM; // 访存指令
            default : RES_MUX = `RES_ALU; // 默认来自 ALU
        endcase
    end*/
    wire RES_MUX = (inst[30:29] == 2'b01); // 访存指令 
    assign REG_WB = {REG_write, RES_MUX};
    

    wire MEM_read  = (inst[31:24] == 8'b00101000); // Load 
    wire MEM_write = (inst[31:24] == 8'b00101001); // Store
    assign MEM = {MEM_read, MEM_write};

    wire is_branch = (inst[31:30] == 2'b01);  //只有跳转指令需要 branch  
    wire is_MUL = (inst[31:15] == 17'b0000_0000_0001_1100_0); // MUL 指令
    wire ALU_in0_MUX, ALU_in1_MUX;
    assign ALU_in0_MUX = 
        (inst[31:28] == 4'b0001) | // 加载立即数指令
        (inst[31:30] == 2'b01)   ; // 跳转指令
    assign ALU_in1_MUX = (inst[31:20] != 12'b000000000001); // 有立即数
    assign EX = {is_branch, is_MUL, ALU_in0_MUX, ALU_in1_MUX};

    always@(*) //ALU_opcode
    begin
        if(~|inst[31:26] & inst[25]) //整形立即数 7'b0000001
        begin
            case(inst[24:22])
                3'b001:  ALU_opcode = `ALU_SLTU; //SLTUI
                3'b010:  ALU_opcode = `ALU_ADD;  //ADDI
                3'b101:  ALU_opcode = `ALU_AND;  //ANDI
                3'b110:  ALU_opcode = `ALU_OR;   //ORI
                default: ALU_opcode = 4'h0;  //其他整形立即数指令
            endcase
        end
        else if(~|inst[31:21] & inst[20]) // 12'b000000000001
        begin
            case(inst[18:15])
                4'b0000: ALU_opcode = `ALU_ADD; //ADD
                4'b0010: ALU_opcode = `ALU_SUB; //SUB
                4'b1001: ALU_opcode = `ALU_AND; //AND
                4'b1010: ALU_opcode = `ALU_OR;  //OR
                4'b1011: ALU_opcode = `ALU_XOR; //XOR
                4'b1111: ALU_opcode = `ALU_SRL; //SRL
                default: ALU_opcode = 4'h0;  //其他移位指令
            endcase
        end
        else
        begin
            ALU_opcode = `ALU_ADD; //ADD
        end
    end

    always@(*) //CMP_opcode
    begin
        casex(inst[29:26])
            4'b0110: CMP_opcode = `CMP_EQ; //BEQ
            4'b0111: CMP_opcode = `CMP_NE; //BNE
            4'b1001: CMP_opcode = `CMP_GE; //BGE
            4'b010x: CMP_opcode = `CMP_B;  //B BL
            4'b0011: CMP_opcode = `CMP_B;  //JIRL
            default: CMP_opcode = 4'h0;  //其他跳转指令
        endcase
    end

    
endmodule
