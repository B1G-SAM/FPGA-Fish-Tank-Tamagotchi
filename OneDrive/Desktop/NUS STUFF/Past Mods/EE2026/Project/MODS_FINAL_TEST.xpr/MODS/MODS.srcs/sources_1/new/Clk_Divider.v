`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 16:07:53
// Design Name: 
// Module Name: Clk_Divider
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
// Create Date: 19.02.2024 10:42:02
// Design Name: 
// Module Name: CLK_Divider
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


module CLK_Divider(
    input CLOCK,
    input [31: 0] M,
    
    output reg out = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK) 
    begin
        COUNT <= (COUNT == M) ? 0 : COUNT + 1;
        out <= (COUNT == 0) ? ~out : out;
    end
    
    
endmodule
