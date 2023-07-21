`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 21:41:25
// Design Name: 
// Module Name: Pre_Branch
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


module Pre_Branch(
    input clk, rst,
    input is_branch, branch,
    output reg [1:0] predict
    );

    always@(posedge clk)
    begin
        if(rst)
        begin
            predict <= 2'b00;
        end
        else
        begin
            if(is_branch)
            begin
                predict <= predict + (predict[1] ^ branch);
            end
        end
    end

endmodule
