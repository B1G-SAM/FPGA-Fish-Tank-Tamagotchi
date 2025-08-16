`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 09:50:01
// Design Name: 
// Module Name: parameter_drawing_logic
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


module parameter_drawing_logic(
    input clk,
    input [6:0] health, hunger, fatigue,
    input [12:0] pixel_index,
    input [11:0] mouse_x, mouse_y,
    input [15:0] sw,
    input [4:0] day_state,
    output reg [15:0] OLED_DATA_OUT
    );
    
    wire [6:0] x; 
    wire [5:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    reg [15:0] day_colour;
    reg [3:0] health_unit, hunger_unit, fatigue_unit;
    
    // mouse control ///////////////////////////////////////////////////////////////
    parameter PURPLE = 16'b11111_000000_11110;
    wire within_cursor; wire [15:0] cursor_color;
    assign within_cursor = ((x == mouse_x) || ((x - mouse_x) == 1) || ((mouse_x - x) == 1)) && ((y == mouse_y) || ((y - mouse_y) == 1) || ((mouse_y - y) == 1)) && sw[0] == 1 && sw[1] == 0 && sw[2] == 0;
    assign cursor_color = ((x == mouse_x) || ((x - mouse_x) == 1) || ((mouse_x - x) == 1)) && ((y == mouse_y) || ((y - mouse_y) == 1) || ((mouse_y - y) == 1)) ? PURPLE : 0;
    
    // drawing logic ////////////////////////////////////////////////////////////
    always @ (posedge clk) begin
        // choosing background colour
        case(day_state)
            5'b00000: day_colour = 16'b00000_010000_01101; 
            5'b00010: day_colour = 16'b00001_010110_10000;
            5'b00100: day_colour = 16'b00011_011011_10010;
            5'b00110: day_colour = 16'b00101_100001_10100;
            5'b01000: day_colour = 16'b00111_100110_10110;
            5'b01010: day_colour = 16'b01101_101100_10111;
            5'b01100: day_colour = 16'b01101_101100_10111;
            5'b01110: day_colour = 16'b00111_100110_10110;
            5'b10000: day_colour = 16'b00101_100001_10100;
            5'b10010: day_colour = 16'b00011_011011_10010;
            5'b10100: day_colour = 16'b00001_010110_10000;
            5'b10110: day_colour = 16'b00000_010000_01101; 
        endcase
        // calculate bar length for parameters ////////////////////////////////////////////
        health_unit = health / 10;
        hunger_unit = hunger / 10;
        fatigue_unit = fatigue / 10;
        
        // mouse colour /////////////////////////////////////////////////////
        if (within_cursor) begin
            OLED_DATA_OUT = cursor_color;
        end
        // draw heart to represent health //////////////////////////////////////////////////
        else if ((x==1 && y==0) || (x==5 && y==0) ||
            (x>=0 && x<=2 && y==1) || (x>=4 && x<=6 && y==1) ||
            (x>=0 && x<=6 && y>=2 && y<=3) ||
            (x>=1 && x<=5 && y==4) || (x>=2 && x<=4 && y==5) ||
            (x==3 && y==6)) 
        begin
            //red
            OLED_DATA_OUT = 16'b11111_000000_00000;
        end 
        
        // draw meat to represent hunger /////////////////////////////////////////////////
        else if ((x>=2 && x<=3 && y==8) || (x==1 && y==9) || (x==4 && y==9) ||
                 (x==0 && y>=10 && y<=11) || (x==5 && y==10) ||(x==6 && y>=11 && y<=13) || (x==1 && y==12) ||
                 (x==2 && y==13) || (x>=3 && x<=5 && y==14) || (x==7 && y==14) || (x==6 && y==15) ||
                 (x>=6 && x<=7 && y==16) || (x==8 && y>=14 && y<=15))
        begin
            //black
            OLED_DATA_OUT = 16'b0;
        end 
        else if ((x==1 && y>=10 && y<=11) || (x>=2 && x<=3 && y>=9 && y<=12) ||
                     (x>=4 && x<=5 && y>=11 && y<=13) || (x==4 && y==10) || (x==3 && y==13))
        begin
            //brown
            OLED_DATA_OUT = 16'b10010_010011_00000; 
        end 
        else if (x==6 && y==14) 
        begin
            //peach
            OLED_DATA_OUT = 16'b11111_111001_10110;
        end
        else if (x==7 && y==15) begin
            //white
            OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
        // draw sleep Zs to represent fatigue//////////////////////////////////////////////////////////////
        else if ((x>=5 && x<=8 && y==18) || (x==7 && y==19) || (x==6 && y==20) || (x>=5 && x<=8 && y==21) || 
                 (x>=0 && x<=3 && y==20) || (x==2 && y==21) || (x==1 && y==22) || (x>=0 && x<=3 && y==23))
        begin
            //black
            OLED_DATA_OUT = 16'b0;
        end
        
        // draw bars for parameters //////////////////////////////////////////////////////////////////////
        else if ((x>=10 && x<=20 && y==2) || (x>=10 && x<=20 && y==4) || (x==10 && y==3) || (x==20 && y==3) ||
                 (x>=10 && x<=20 && y==11) || (x>=10 && x<=20 && y==13) || (x==10 && y==12) || (x==20 && y==12) ||
                 (x>=10 && x<=20 && y==20) || (x>=10 && x<=20 && y==22) || (x==10 && y==21) || (x==20 && y==21))
        begin
            //black
            OLED_DATA_OUT = 16'b0;
        end
        else if (x>=11 && x<=(health_unit + 11) && y==3) begin
            if (health_unit <= 2) begin 
                // red
                OLED_DATA_OUT = 16'b11111_000000_00000;
            end
            else if (health_unit <= 6) begin
                // yellow
                OLED_DATA_OUT = 16'b11111_111111_00000;
            end
            else begin
                // green
                OLED_DATA_OUT = 16'b00000_111111_00000;
            end
        end
        
        else if (x>=11 && x<=(hunger_unit + 11) && y==12) begin
            if (hunger_unit <= 2) begin 
                // red
                OLED_DATA_OUT = 16'b11111_000000_00000;
            end
            else if (hunger_unit <= 6) begin
                // yellow
                OLED_DATA_OUT = 16'b11111_111111_00000;
            end
            else begin
                // green
                OLED_DATA_OUT = 16'b00000_111111_00000;
            end
        end
        
        else if (x>=11 && x<=(fatigue_unit + 11) && y==21) begin
            if (fatigue_unit <= 2) begin 
                // green
                OLED_DATA_OUT = 16'b00000_111111_00000;
            end
            else if (fatigue_unit <= 6) begin
                // yellow
                OLED_DATA_OUT = 16'b11111_111111_00000;
            end
            else begin
                // red
                OLED_DATA_OUT = 16'b11111_000000_00000;
            end
        end
        
        else if ((x>=(health_unit + 11) && x<=19 && y==3) ||
                 (x>=(hunger_unit + 11) && x<=19 && y==12) ||
                 (x>=(fatigue_unit + 11) && x<=19 && y==21))
        begin
            //black
            OLED_DATA_OUT = 16'b0;
        end
        
        // draw sun and moon ////////////////////////////////////////////////////////////////////////////
        // draw sun
        else if (((x==89 && y>=0 && y<=1) || (x==85 && y==1) || (x==86 && y==2) || (x==93 && y==1) || (x==92 && y==2) ||
                 (x>=84 && x<=85 && y==5) || (x>=93 && x<=94 && y==5) || 
                 (x==89 && y>=9 && y<=10) || (x==85 && y==9) || (x==86 && y==8) || (x==93 && y==9) || (x==92 && y==8)) 
                 && day_state >= 6 && day_state <= 18)
        begin
            // red
            OLED_DATA_OUT = 16'b11111_000000_00000;
        end
        else if (((x>=88 && x<=90 && y==3) || (x>=87 && x<=91 && y>=4 && y<=6) || (x>=88 && x<=90 && y==7)) && day_state >=6 && day_state <= 18)
        begin
            // orange
            OLED_DATA_OUT = 16'b11111_101001_00000;
        end
        // draw moon
        else if (((x>=88 && x<=92 && y>=0 && y<=1) || (x==87 && y==1) || (x==93 && y==1) || (x>=86 && x<=89 && y>=2 && y<=6) ||
                 (x>=93 && x<=94 && y==2) ||
                 (x>=88 && x<=92 && y>=7 && y<=8) || (x==87 && y==7) || (x==93 && y==7) || 
                 (x>=93 && x<=94 && y==6) )
                 && (day_state <= 5 || day_state >= 19))
        begin
            // moon grey
            OLED_DATA_OUT = 16'b11110_111100_11010;
        end         

        // colour the background //////////////////////////////////////////////////////////////////////////
        else begin
            // colour the rest varying shades of blue
            OLED_DATA_OUT = day_colour;
        end
    end
endmodule
