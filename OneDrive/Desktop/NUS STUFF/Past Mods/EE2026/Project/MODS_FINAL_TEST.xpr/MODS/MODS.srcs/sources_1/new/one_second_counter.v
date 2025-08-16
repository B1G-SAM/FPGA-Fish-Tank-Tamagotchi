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


module one_second_counter(
input CLOCK,
output reg [5:0] count = 0

    );
    
    wire one_second_clock;
    CLK_Divider(CLOCK,49999999,one_second_clock);
    
    always@(posedge one_second_clock)
    begin
    
    count =  count + 1;
    
    if(count == 49)
    begin
    count = 0;
    end
    
    end
    
    
endmodule
