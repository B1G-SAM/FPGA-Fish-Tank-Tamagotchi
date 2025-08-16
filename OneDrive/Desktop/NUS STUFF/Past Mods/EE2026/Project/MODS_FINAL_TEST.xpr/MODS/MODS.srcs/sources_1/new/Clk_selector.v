`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 19:22:20
// Design Name: 
// Module Name: Clk_selector
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


module Clk_selector(
input CLOCK,
output reg [1:0] selector

    );
  wire [1:0] counter_2000Hz_wire;
  counter_2000hz(CLOCK,counter_2000Hz_wire);
  
  always @(posedge CLOCK)
  begin
  if ( counter_2000Hz_wire == 0)
  begin
  selector = 2'b00;
  end
  
   if ( counter_2000Hz_wire == 1)
   begin
   selector = 2'b01;
   end
   
    if ( counter_2000Hz_wire == 2)
    begin
    selector = 2'b10;
    end
    
     if ( counter_2000Hz_wire == 3)
     begin
     selector = 2'b11;
     end
  
  end  
    
    
endmodule
