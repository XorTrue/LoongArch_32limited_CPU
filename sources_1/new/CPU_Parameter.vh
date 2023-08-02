

`define UNDEFINE 32'h0

//the reset value of PC
`define PC_RST 32'h8000_0000 

`define RAM_WIDTH 32
`define RAM_DEPTH 64
`define RAM_DEPTH_LOG 6
`define RAM_PERFORMANCE "LOW_LATENCY"

`define CACHE_WAY 2
`define CACHE_WORD_NUM 4
`define CACHE_LINE_BYTE 16
`define CACHE_LINE_BYTE_LOG 4
`define CACHE_LINE_WIDTH (32<<2)
`define CACHE_WAIT_CYCLE 3


 
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

// Result MUX
`define RES_ALU 2'b00
`define RES_CMP 2'b01
`define RES_MEM 2'b1x