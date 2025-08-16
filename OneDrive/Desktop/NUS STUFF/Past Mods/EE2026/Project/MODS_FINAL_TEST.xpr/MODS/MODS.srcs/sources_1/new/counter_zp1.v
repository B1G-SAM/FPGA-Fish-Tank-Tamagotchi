`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2024 16:03:56
// Design Name: 
// Module Name: one_second_counter
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


module counter_zp1(
input CLOCK,

output reg [4:0] count = 0

    );
    
    wire zerop1_second_clock;
    CLK_Divider(CLOCK,4999999,zerop1_second_clock);
    
    always@(posedge zerop1_second_clock)
    begin
   

    count = (count == 11)? 0: count + 1;
    
    
    end
    
    
endmodule
