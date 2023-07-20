

`define UNDEFINE 32'h0

//the reset value of PC
`define PC_RST 32'h8000_0000 

`define DOUBLE 64
`define WORD   32
`define HALF   16
`define BYTE   8

`define REG_LOG 5

//opcode 
`define OPCODE_LEN 4
`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_AND  4'b0010
`define ALU_OR   4'b0011
`define ALU_XOR  4'b0100
`define ALU_SLL  4'b1000
`define ALU_SRL  4'b1001
//`define ALU_SRA 4'b1010
`define ALU_SLTU 4'b1100

`define CMP_EQ   4'b0000
`define CMP_NE   4'b0001
`define CMP_GE   4'b0010
`define CMP_B    4'b1111