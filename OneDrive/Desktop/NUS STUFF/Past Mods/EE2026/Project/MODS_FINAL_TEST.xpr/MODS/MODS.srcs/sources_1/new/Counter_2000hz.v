`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 17:22:04
// Design Name: 
// Module Name: Counter_2000hz
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2024 14:08:45
// Design Name: 
// Module Name: counter
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


module counter_2000hz(
    input CLOCK,
    output reg [31:0] COUNT_2hz = 0
    );
    
    wire clk_2;
    CLK_Divider(CLOCK,249999,clk_2);
    
    always @ (posedge clk_2)
    begin
    
    COUNT_2hz = COUNT_2hz + 1;
   
    
    end
endmodule

