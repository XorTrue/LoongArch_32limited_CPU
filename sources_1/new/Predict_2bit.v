`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 17:34:36
// Design Name: 
// Module Name: Predict_2bit
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


module Predict_2bit(
    input clk, rst,
    input is_branch, branch,
    output predict_out
    );

    reg [1:0] predict;

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

    assign predict_out = predict[1];
    
endmodule
