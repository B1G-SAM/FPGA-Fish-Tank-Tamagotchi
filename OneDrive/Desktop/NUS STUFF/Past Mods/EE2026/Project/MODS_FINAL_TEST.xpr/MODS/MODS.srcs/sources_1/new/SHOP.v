`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 16:04:39
// Design Name: 
// Module Name: SHOP
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

module SHOP (
input CLOCK,
input clk625,
input [15:0] sw,
input btnD,
input btnU,

input [12:0] pixel_index,

input [11:0] mouse_x, mouse_y,
input left, right,
input is_eaten_flag,
input food_dropped,
output reg [15:0] led,


output [7:0] JC,
output reg [15:0] OLED_DATA_OUT,

output reg food_flag = 0,
output reg bed_flag = 0,
output reg green_flag = 0,
output reg red_flag = 0,
output reg grey_flag = 0,
output reg [6:0] displayed_number = 99,
output reg rock_flag = 0,
output reg [15:0] colour_primary = 16'b11111_000000_00000
);

wire [12:0] pixel_index_wire;
assign pixel_index_wire = pixel_index;
wire [6:0] x_wire;
reg [31:0] scroll_count;
wire [5:0] y_wire;

assign x_wire = pixel_index_wire % 96;
assign y_wire = (pixel_index_wire + 96*scroll_count)/96;
//assign y_wire = (pixel_index_wire /96)  + 96*scroll_count;


wire [6:0] row, col;
assign col = pixel_index % 96;
assign row = pixel_index / 96;  

reg buy_clicked_flag = 0;
reg scrolled_flag = 0;
reg scrolled_up_flag = 0;
reg purchase_start_flag = 0;

reg page_2_flag = 0;
reg page_1_flag = 0;


reg purchase_food_flag = 0;

reg day_flag = 0;
reg added_flag = 0;

    
parameter PURPLE = 16'b11111_000000_11110;
parameter background_color = 16'b11111_111111_11111;  

wire within_cursor; wire [15:0] cursor_color;
assign within_cursor = ((col == mouse_x) || ((col - mouse_x) == 1) || ((mouse_x - col) == 1)) && ((row == mouse_y) || ((row - mouse_y) == 1) || ((mouse_y - row) == 1)) && sw[1] == 1;
assign cursor_color = ((col == mouse_x) || ((col - mouse_x) == 1) || ((mouse_x - col) == 1)) && ((row == mouse_y) || ((row - mouse_y) == 1) || ((mouse_y - row) == 1)) ? PURPLE : 0; 



reg [3:0] LED_OUT;

; // counting number to be displayed
wire clk_A;
wire clk_2000;
wire clk_10;
wire clk_1;
CLK_Divider(CLOCK,999999,clk_A);
CLK_Divider(CLOCK,24999,clk_2000);
CLK_Divider(CLOCK,4999999,clk_10);
CLK_Divider(CLOCK,49999999,clk_1);
reg  counter;

wire [5:0] one_second_count;
wire [3:0] zp1_second_count;
one_second_counter(CLOCK,one_second_count);
counter_zp1(CLOCK,zp1_second_count);

always @(posedge clk_1)
begin
 if(one_second_count == 48)
    begin
    day_flag =1;
    end
 
 if(one_second_count == 0)
 begin
 day_flag = 0;
 end   
               

end

always @ (posedge clk625)
begin

if( day_flag == 1) begin
    if(displayed_number < 99) begin
        displayed_number = displayed_number + 2;
    end
end

if (is_eaten_flag) begin
    food_flag = 0;
    purchase_food_flag = 0;
    purchase_start_flag = 0;
end

if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=9  && mouse_y <= 19 && page_1_flag == 1 && buy_clicked_flag == 1 && displayed_number >=5  && !purchase_food_flag && sw[1] == 1 && sw[0] == 0 && sw[2] == 0  && led[7] == 0) 
      begin
      food_flag = 1;
      purchase_food_flag = 1;
      purchase_start_flag = 1;
      
      if( purchase_start_flag == 1)
      begin
      displayed_number = displayed_number - 5;
      end
     // OLED_DATA_OUT = 16'b11111_111111_00000;
      end

      if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=20  && mouse_y <= 29 && page_1_flag == 1  && buy_clicked_flag == 1 && displayed_number >=10 && bed_flag ==0 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
         begin
         bed_flag = 1;
         purchase_start_flag = 1;
          if( purchase_start_flag == 1)
              begin
              displayed_number = displayed_number - 10;
              end
         //displayed_number = displayed_number - 10;
        // OLED_DATA_OUT = 16'b00000_000000_11111;
         end 
      
      if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=30  && mouse_y <= 39 && page_1_flag == 1 && buy_clicked_flag == 1  && displayed_number >=10 && green_flag == 0 && colour_primary != 16'b00000_111111_00000 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
            begin
            green_flag = 1;
            purchase_start_flag = 1;
             if( purchase_start_flag == 1)
                 begin
                 displayed_number = displayed_number - 10;
                 colour_primary = 16'b00000_111111_00000;
                 red_flag = 0;
                 grey_flag = 0;
                 end
            //displayed_number = displayed_number - 10;
          //  OLED_DATA_OUT = 16'b00000_111111_00000;
            end  
        
     if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=40  && mouse_y <= 49 && page_1_flag == 1 && buy_clicked_flag == 1  && displayed_number >=10 && red_flag ==0 && colour_primary != 16'b11111_000000_00000 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
               begin
               red_flag = 1;
               purchase_start_flag = 1;
                if( purchase_start_flag == 1)
                    begin
                    displayed_number = displayed_number - 10;
                    colour_primary = 16'b11111_000000_00000;
                    green_flag = 0;
                    grey_flag = 0;
                    end
              // displayed_number = displayed_number - 10;
            //   OLED_DATA_OUT = 16'b11111_000000_00000;
               end  
     
     
    if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=50  && mouse_y <= 59 && page_1_flag == 1 && buy_clicked_flag == 1  && displayed_number >=10 && grey_flag ==0 && colour_primary != 16'b01100_011010_01100 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
                           begin
                           grey_flag = 1;
                           purchase_start_flag = 1;
                            if( purchase_start_flag == 1)
                                begin
                                displayed_number = displayed_number - 10;
                                colour_primary = 16'b01100_011010_01100;
                                red_flag = 0;
                                green_flag = 0;
                                end
                          // displayed_number = displayed_number - 10;
                 //          OLED_DATA_OUT = 16'b11111_111100_01100;
                           end           
               
               
               
       //page 2                              
      if (left == 1 & mouse_x >= 12 && mouse_x <79  && mouse_y >=9  && mouse_y <= 19 && page_2_flag == 1 && buy_clicked_flag == 1  && displayed_number >=10 && rock_flag ==0 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
                 begin
                 rock_flag = 1;
                  purchase_start_flag = 1;
                                            if( purchase_start_flag == 1)
                                                begin
                                                displayed_number = displayed_number - 5;
                                                end
               //  displayed_number = displayed_number - 5;
              //   OLED_DATA_OUT = 16'b00000_111111_11111;
                 end
   
    

  if(displayed_number >= 99)
  begin
  displayed_number =99;
  end     
       
   
end


always @ (posedge clk_A)
begin

if(buy_clicked_flag == 0)
begin
scroll_count = 0;
end

if(btnD == 1 && buy_clicked_flag == 1)
begin
scrolled_flag = 1;
end

if(btnD == 0 && buy_clicked_flag == 1)
begin
scrolled_flag = 0;
end

if(scrolled_flag ==1 && buy_clicked_flag == 1 && sw[1] && ~sw[0] &&~sw[2])
begin
scroll_count = scroll_count + 1;
end


if(btnU == 1 && buy_clicked_flag == 1)
begin
scrolled_up_flag = 1;
end

if(btnU == 0 && buy_clicked_flag == 1)
begin
scrolled_up_flag = 0;
end

if(scrolled_up_flag ==1 && buy_clicked_flag == 1 && sw[1] && ~sw[0] &&~sw[2])
begin
scroll_count = scroll_count - 1;
end

if(scroll_count >=65 && buy_clicked_flag == 1)
begin
page_2_flag = 1;
page_1_flag = 0;
end

if(scroll_count < 65 && buy_clicked_flag == 1)
begin
page_2_flag = 0;
page_1_flag = 1;
end

end

always @ (posedge CLOCK)
begin
if (food_flag == 1) begin
    led[7] = 1;
end
else begin
    led[7] = 0;
end


if( x_wire >=0 && x_wire <= 95 && y_wire >=40 && y_wire <= 63  && buy_clicked_flag == 0 )
begin
OLED_DATA_OUT = 16'b11111_010001_00000;
end

else if (x_wire >= 20 && x_wire <=22 && y_wire >=0  && y_wire <= 10  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end

else if (x_wire >= 75 && x_wire <=77 && y_wire >=0  && y_wire <= 10  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end

else if (x_wire >= 20 && x_wire <=77 && y_wire >=10  && y_wire <= 12  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end

//Writing SHOP

else if (x_wire >= 32 && x_wire <=36 && y_wire >=0  && y_wire <= 0  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 32 && x_wire <=34 && y_wire >=1  && y_wire <= 2  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 32 && x_wire <=36 && y_wire >=3  && y_wire <= 3  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 34 && x_wire <=36 && y_wire >=4  && y_wire <= 5  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 32 && x_wire <=36 && y_wire >=6  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 40 && x_wire <=42 && y_wire >=0  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 43 && x_wire <=46 && y_wire >=3  && y_wire <= 4  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 47 && x_wire <=49 && y_wire >=0  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 


else if (x_wire >= 53 && x_wire <=54 && y_wire >=0  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 53 && x_wire <=58 && y_wire >=0  && y_wire <= 1  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 58 && x_wire <=59 && y_wire >=0  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 53 && x_wire <=58 && y_wire >=5  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 63 && x_wire <=64 && y_wire >=0  && y_wire <= 6  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 63 && x_wire <=67 && y_wire >=0  && y_wire <= 0  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 66 && x_wire <=67 && y_wire >=0  && y_wire <= 3  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

else if (x_wire >= 63 && x_wire <=67 && y_wire >=3  && y_wire <= 4  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_100111_00000;
end 

//Make Man

else if (x_wire >= 70 && x_wire <=89 && y_wire >=15  && y_wire <= 15  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 70 && x_wire <=71 && y_wire >=15  && y_wire <= 35  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 88 && x_wire <=89 && y_wire >=15  && y_wire <= 35  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 70 && x_wire <=89 && y_wire >=35  && y_wire <= 35  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 


else if (x_wire >= 75 && x_wire <=76 && y_wire >=18  && y_wire <= 20  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 83 && x_wire <=84 && y_wire >=18  && y_wire <= 20  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 75 && x_wire <=76  && y_wire >=28  && y_wire <= 32  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 75 && x_wire <=84  && y_wire >=32  && y_wire <= 32  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else if (x_wire >= 83 && x_wire <=84  && y_wire >=28  && y_wire <= 32  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11101_001111_00000;
end 

else
begin
OLED_DATA_OUT = 16'b00000_000000_00000;
end

//buy button

if (x_wire >= 0 && x_wire <=13  && y_wire >=20  && y_wire <= 32  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b10001_001111_00000;
end 

if (x_wire >= 2 && x_wire <=10  && y_wire >=22  && y_wire <= 22  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 2 && x_wire <=2  && y_wire >=22  && y_wire <= 26  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 2 && x_wire <=10  && y_wire >=26  && y_wire <= 26  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 10 && x_wire <=10  && y_wire >=26  && y_wire <= 30  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 2 && x_wire <=10  && y_wire >=30  && y_wire <= 30  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 4 && x_wire <=4  && y_wire >=21  && y_wire <= 31  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

if (x_wire >= 8 && x_wire <=8  && y_wire >=21  && y_wire <= 31  && buy_clicked_flag == 0)
begin
OLED_DATA_OUT = 16'b11111_111111_11111;
end 

//old buy button

//if (x_wire >= 15 && x_wire <=45  && y_wire >=20  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b10001_001111_00000;
//end 

//if (x_wire >= 17 && x_wire <=18  && y_wire >=20  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 17 && x_wire <=23  && y_wire >=20  && y_wire <= 20  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 22 && x_wire <=23  && y_wire >=20  && y_wire <= 24  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 17 && x_wire <=23  && y_wire >=24  && y_wire <= 24  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 17 && x_wire <=23  && y_wire >=31  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 22 && x_wire <=23  && y_wire >=26  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 17 && x_wire <=23  && y_wire >=26  && y_wire <= 27  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 
////Letter U
//if (x_wire >= 26 && x_wire <=27  && y_wire >=20  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 26 && x_wire <=31  && y_wire >=31  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 30 && x_wire <=31  && y_wire >=20  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 34 && x_wire <=35  && y_wire >=20  && y_wire <= 25  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 34 && x_wire <=40  && y_wire >=25  && y_wire <= 25  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 39 && x_wire <=40  && y_wire >=20  && y_wire <= 25  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 39 && x_wire <=40  && y_wire >=25  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end 

//if (x_wire >= 34 && x_wire <=40  && y_wire >=31  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end

//if (x_wire >= 34 && x_wire <=35  && y_wire >=27  && y_wire <= 32  && buy_clicked_flag == 0)
//begin
//OLED_DATA_OUT = 16'b11111_111111_11111;
//end

if (within_cursor && cursor_color != 16'b1111_11111_1111) 
begin
OLED_DATA_OUT = cursor_color;
end

//hover over buy button
if (left == 1 & mouse_x >= 0 && mouse_x <=13  && mouse_y >=23  && mouse_y <= 32  && buy_clicked_flag == 0 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0) 
begin
buy_clicked_flag = 1;
end

if(buy_clicked_flag == 1)
begin

    if(x_wire >=11 && x_wire <=12 && y_wire >=0 && y_wire <= 63 && page_1_flag == 1)   //left column ends at 13
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=9 && y_wire <= 9 && page_1_flag == 1)
    begin
     OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=20 && y_wire <= 20 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=30 && y_wire <= 30 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=40 && y_wire <= 40 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
     
    else if(x_wire >=0 && x_wire <=95 && y_wire >= 50 && y_wire <= 50 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >= 60 && y_wire <= 60 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    

      
    else if(x_wire >=80 && x_wire <=81 && y_wire >= 0 && y_wire <= 63 && page_1_flag == 1)  //right column ends 82
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
      
    //input first items and headers  
    else if(x_wire >=20 && x_wire <=27 && y_wire >= 1 && y_wire <= 1 && page_1_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=24 && x_wire <=24 && y_wire >= 1 && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if(x_wire >=20 && x_wire <=27 && y_wire >= 8 && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    
    else if (x_wire >= 30 && x_wire <=37  && y_wire >=1  && y_wire <= 1 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 33 && x_wire <=33  && y_wire >=1  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=1  && y_wire <= 1 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end    
    
    else if (x_wire >= 40 && x_wire <=40  && y_wire >=1  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=4  && y_wire <= 4 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=8  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 52 && x_wire <=52  && y_wire >=1  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 52 && x_wire <=59  && y_wire >=1  && y_wire <= 1 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 55 && x_wire <=55  && y_wire >=1  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 59 && x_wire <=59  && y_wire >=1  && y_wire <= 8 && page_1_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        //dollar sign
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=1  && y_wire <= 1 && page_1_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 86 && x_wire <=86  && y_wire >=1  && y_wire <= 3 && page_1_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
                
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=3  && y_wire <= 3 && page_1_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 93 && x_wire <=93  && y_wire >=3  && y_wire <= 7 && page_1_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=7  && y_wire <= 7 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
             
    else if (x_wire >= 90 && x_wire <=90  && y_wire >=0  && y_wire <= 8 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
                 
    else if (x_wire >= 88 && x_wire <=88  && y_wire >=0  && y_wire <= 8 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
             
     else if (x_wire >= 20 && x_wire <=27  && y_wire >=11  && y_wire <= 11 && page_1_flag == 1)  //Write F in Food
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
             
     else if (x_wire >= 20 && x_wire <= 27  && y_wire >=14  && y_wire <= 14 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
             
     else if (x_wire >= 20 && x_wire <= 20  && y_wire >=11  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end

     else if (x_wire >= 29 && x_wire <= 33  && y_wire >=14  && y_wire <= 14 && page_1_flag == 1) //First O
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end     
             
    else if (x_wire >= 29 && x_wire <= 33  && y_wire >=18  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end  
             
    else if (x_wire >= 29 && x_wire <= 29  && y_wire >=14  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
   
    else if (x_wire >= 33 && x_wire <= 33  && y_wire >=14  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
             
    else if (x_wire >= 35 && x_wire <= 39  && y_wire >=14  && y_wire <= 14 && page_1_flag == 1) // 2nd O
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end     
                         
    else if (x_wire >= 35 && x_wire <= 39  && y_wire >=18  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end  
                         
    else if (x_wire >= 35 && x_wire <= 35  && y_wire >=14  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
               
    else if (x_wire >= 39 && x_wire <= 39  && y_wire >=14  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end            

    else if (x_wire >= 41 && x_wire <= 45  && y_wire >=14  && y_wire <= 14 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end   
                        
    else if (x_wire >= 41 && x_wire <= 41  && y_wire >=14  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end                 
             
     else if (x_wire >= 41 && x_wire <= 45  && y_wire >=18  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end 
             
     else if (x_wire >= 45 && x_wire <= 45  && y_wire >=11  && y_wire <= 18 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
             
    //price of food
    
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=11  && y_wire <= 11 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end
                
        else if (x_wire >= 86 && x_wire <=86  && y_wire >=11  && y_wire <= 13 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end
                    
        else if (x_wire >= 86 && x_wire <=93  && y_wire >=13  && y_wire <= 13 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end
                
        else if (x_wire >= 93 && x_wire <=93  && y_wire >=13  && y_wire <= 17 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end
                
        else if (x_wire >= 86 && x_wire <=93  && y_wire >=17  && y_wire <= 17 && page_1_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end
    
    //Bed
     else if (x_wire >= 20 && x_wire <=27  && y_wire >=22  && y_wire <= 22 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end
     else if (x_wire >= 20 && x_wire <=20 && y_wire >=21  && y_wire <= 28 && page_1_flag == 1) 
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end
       
     else if (x_wire >= 27 && x_wire <=27  && y_wire >=22  && y_wire <= 24 && page_1_flag == 1) 
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end    
    
     else if (x_wire >= 20 && x_wire <=27  && y_wire >=24  && y_wire <= 24 && page_1_flag == 1) 
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end
    
     else if (x_wire >= 20 && x_wire <=27  && y_wire >=28  && y_wire <= 28 && page_1_flag == 1) 
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end        
    
  else if (x_wire >= 27 && x_wire <=27  && y_wire >=26  && y_wire <= 28 && page_1_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end    
 
 else if (x_wire >= 20 && x_wire <=27  && y_wire >=26  && y_wire <= 26 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end 
             
   //letter E
   
       else if (x_wire >= 29 && x_wire <= 33  && y_wire >=24  && y_wire <= 24 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end     
                
       else if (x_wire >= 29 && x_wire <= 33  && y_wire >=26  && y_wire <= 26 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end  
                
       else if (x_wire >= 29 && x_wire <= 29  && y_wire >=24  && y_wire <= 28 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end
      
       else if (x_wire >= 33 && x_wire <= 33  && y_wire >=24  && y_wire <= 26 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end    
    
   else if (x_wire >= 29 && x_wire <= 33  && y_wire >=28  && y_wire <= 28 && page_1_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end    
   
   //d
  else if (x_wire >= 35 && x_wire <= 39  && y_wire >=24  && y_wire <= 24 && page_1_flag == 1) 
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                             end   
                                        
  else if (x_wire >= 39 && x_wire <= 39  && y_wire >=21  && y_wire <= 28 && page_1_flag == 1) 
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                             end                 
                             
  else if (x_wire >= 35 && x_wire <= 39  && y_wire >=28  && y_wire <= 28 && page_1_flag == 1) 
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                             end 
                             
  else if (x_wire >= 35 && x_wire <= 35  && y_wire >=24  && y_wire <= 28 && page_1_flag == 1) 
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                             end 
                             
    //cost                         
   else if(x_wire >=86 && x_wire <=86 && y_wire>=21 && y_wire <=28 && page_1_flag == 1)
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                             end 
                            
   else if(x_wire >=89 && x_wire <=93 && y_wire>=21 && y_wire <=21 && page_1_flag == 1)
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                              end 
   
   else if(x_wire >=89 && x_wire <=93 && y_wire>=28 && y_wire <=28 && page_1_flag == 1)
                           begin
                           OLED_DATA_OUT = 16'b11111_111111_00000;
                           end 
   else if(x_wire >=89 && x_wire <=89 && y_wire>=21 && y_wire <=28 && page_1_flag == 1)
                           begin
                           OLED_DATA_OUT = 16'b11111_111111_00000;
                           end  
   else if(x_wire >=93 && x_wire <=93 && y_wire>=21 && y_wire <=28 && page_1_flag == 1)
                           begin
                           OLED_DATA_OUT = 16'b11111_111111_00000;
                           end                        
    //Colours
    else if(x_wire >=20 && x_wire <=24 && y_wire>=31 && y_wire <=31 && page_1_flag == 1)
              begin
              OLED_DATA_OUT = 16'b11111_111111_00000;
              end 
              
    else if(x_wire >=20 && x_wire <=20 && y_wire>=31 && y_wire <=38 && page_1_flag == 1)
               begin
               OLED_DATA_OUT = 16'b11111_111111_00000;
               end 
                                      
 else if(x_wire >=20 && x_wire <=27 && y_wire>=38 && y_wire <=38 && page_1_flag == 1)
               begin
               OLED_DATA_OUT = 16'b11111_111111_00000;
               end             
   else if(x_wire >=27 && x_wire <=27 && y_wire>=34 && y_wire <=38 && page_1_flag == 1)
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end 
 else if(x_wire >=23 && x_wire <=27 && y_wire>=34 && y_wire <=34 && page_1_flag == 1)
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end  
   
   //r
   else if(x_wire >=29 && x_wire <=29 && y_wire>=32 && y_wire <=38 && page_1_flag == 1)
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end
   
   else if(x_wire >=29 && x_wire <=33 && y_wire>=32 && y_wire <=32 && page_1_flag == 1)
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end
  //e
   else if (x_wire >= 35 && x_wire <= 39  && y_wire >=34  && y_wire <= 34 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end     
                                  
                         else if (x_wire >= 35 && x_wire <= 39  && y_wire >=36  && y_wire <= 36 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end  
                                  
                         else if (x_wire >= 35 && x_wire <= 35  && y_wire >=34  && y_wire <= 38 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end
                        
                         else if (x_wire >= 39 && x_wire <= 39  && y_wire >=34  && y_wire <= 36 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end    
                      
                     else if (x_wire >= 35 && x_wire <= 39  && y_wire >=38  && y_wire <= 38 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end
  
  else if (x_wire >= 41 && x_wire <= 45  && y_wire >=34  && y_wire <= 34 && page_1_flag == 1) 
                                   begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end     
                                                                    
  else if (x_wire >= 41 && x_wire <= 45  && y_wire >=36  && y_wire <= 36 && page_1_flag == 1) 
                                   begin
                                   OLED_DATA_OUT = 16'b11111_111111_00000;
                                   end  
   
   else if (x_wire >= 41 && x_wire <= 41  && y_wire >=34  && y_wire <= 38 && page_1_flag == 1) 
                                   begin
                                   OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end
   
  else if (x_wire >= 45 && x_wire <= 45  && y_wire >=34  && y_wire <= 36 && page_1_flag == 1) 
                                   begin
                                   OLED_DATA_OUT = 16'b11111_111111_00000;
                                   end    
                                                        
  else if (x_wire >= 41 && x_wire <= 45  && y_wire >=38  && y_wire <= 38 && page_1_flag == 1) 
                                   begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                   end
                                   
                                   
  
  else if (x_wire >= 47 && x_wire <= 51  && y_wire >=34  && y_wire <= 34 && page_1_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_00000;
             end    
    
  else if (x_wire >= 47 && x_wire <= 47  && y_wire >=34  && y_wire <= 38 && page_1_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end 
    
  else if (x_wire >= 51 && x_wire <= 51  && y_wire >=34  && y_wire <= 38 && page_1_flag == 1) 
         begin
         OLED_DATA_OUT = 16'b11111_111111_00000;
         end  
         
   else if(x_wire >=86 && x_wire <=86 && y_wire>=31 && y_wire <=38 && page_1_flag == 1)
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end       
         
   else if(x_wire >=89 && x_wire <=93 && y_wire>=31 && y_wire <=31 && page_1_flag == 1)
                                      begin
                                      OLED_DATA_OUT = 16'b11111_111111_00000;
                                      end 
            
            else if(x_wire >=89 && x_wire <=93 && y_wire>=38 && y_wire <=38 && page_1_flag == 1)
                                    begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end 
            else if(x_wire >=89 && x_wire <=89 && y_wire>=31 && y_wire <=38 && page_1_flag == 1)
                                    begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end  
            else if(x_wire >=93 && x_wire <=93 && y_wire>=31 && y_wire <=38 && page_1_flag == 1)
                                    begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end           
    
    
else if (x_wire >= 20 && x_wire <= 25  && y_wire >=41  && y_wire <= 41 && page_1_flag == 1) 
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end   
                    
else if (x_wire >= 20 && x_wire <= 20  && y_wire >=41  && y_wire <= 48 && page_1_flag == 1) 
                                    begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end    
   
else if (x_wire >= 25 && x_wire <= 25  && y_wire >=41  && y_wire <= 43 && page_1_flag == 1) 
                                                      begin
                                                      OLED_DATA_OUT = 16'b11111_111111_00000;
                                                      end   
  else if (x_wire >= 20 && x_wire <= 25  && y_wire >=43  && y_wire <= 43 && page_1_flag == 1) 
                        begin
                        OLED_DATA_OUT = 16'b11111_111111_00000;
                         end  
                         
  else if(x_wire >= 21 && x_wire <= 21  && y_wire >=44  && y_wire <= 44 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end                        
           
  else if(x_wire >= 22 && x_wire <= 22  && y_wire >=45  && y_wire <= 45 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
           
  else if(x_wire >= 23 && x_wire <= 23  && y_wire >=46  && y_wire <= 46 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
  
  else if(x_wire >= 24 && x_wire <= 24  && y_wire >=47  && y_wire <= 47 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
   else if(x_wire >= 25 && x_wire <= 25  && y_wire >=48  && y_wire <= 48 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end
     //e in red         
  else if (x_wire >= 29 && x_wire <= 33  && y_wire >=44  && y_wire <= 44 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end     
                    
           else if (x_wire >= 29 && x_wire <= 33  && y_wire >=46  && y_wire <= 46 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end  
                    
           else if (x_wire >= 29 && x_wire <= 29  && y_wire >=44  && y_wire <= 48 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end
          
           else if (x_wire >= 33 && x_wire <= 33  && y_wire >=44  && y_wire <= 46 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end    
        
       else if (x_wire >= 29 && x_wire <= 33  && y_wire >=48  && y_wire <= 48 && page_1_flag == 1) 
                    begin
                    OLED_DATA_OUT = 16'b11111_111111_00000;
                    end        
     
     //d
     else if (x_wire >= 35 && x_wire <= 39  && y_wire >=44  && y_wire <= 44 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end   
                                             
       else if (x_wire >= 39 && x_wire <= 39  && y_wire >=41  && y_wire <= 48 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end                 
                                  
       else if (x_wire >= 35 && x_wire <= 39  && y_wire >=48  && y_wire <= 48 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end 
                                  
       else if (x_wire >= 35 && x_wire <= 35  && y_wire >=44  && y_wire <= 48 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end 
        else if(x_wire >=86 && x_wire <=86 && y_wire>=41 && y_wire <=48 && page_1_flag == 1)
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end 
     
     
   else if(x_wire >=86 && x_wire <=86 && y_wire>=41 && y_wire <=48 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
                                                              
   else if(x_wire >=89 && x_wire <=93 && y_wire>=41 && y_wire <=41 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
                                     
   else if(x_wire >=89 && x_wire <=93 && y_wire>=48 && y_wire <=48 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
   else if(x_wire >=89 && x_wire <=89 && y_wire>=41 && y_wire <=48 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end  
   else if(x_wire >=93 && x_wire <=93 && y_wire>=41 && y_wire <=48 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end  
                       
   //GRAY
   else if(x_wire >=20 && x_wire <=24 && y_wire>=51 && y_wire <=51 && page_1_flag == 1)
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end 
                 
       else if(x_wire >=20 && x_wire <=20 && y_wire>=51 && y_wire <=58 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end 
                                         
    else if(x_wire >=20 && x_wire <=27 && y_wire>=58 && y_wire <=58 && page_1_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end              
      else if(x_wire >=27 && x_wire <=27 && y_wire>=54 && y_wire <=58 && page_1_flag == 1)
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end 
    else if(x_wire >=23 && x_wire <=27 && y_wire>=54 && y_wire <=54 && page_1_flag == 1)
                   begin
                   OLED_DATA_OUT = 16'b11111_111111_00000;
                   end   
    
    
    else if(x_wire >=29 && x_wire <=29 && y_wire>=52 && y_wire <=58 && page_1_flag == 1)
                                      begin
                                      OLED_DATA_OUT = 16'b11111_111111_00000;
                                      end
                      
                      else if(x_wire >=29 && x_wire <=33 && y_wire>=52 && y_wire <=52 && page_1_flag == 1)
                                      begin
                                      OLED_DATA_OUT = 16'b11111_111111_00000;
                                      end
    
    
//   else if (x_wire >= 35 && x_wire <= 39  && y_wire >=54  && y_wire <= 54 && page_1_flag == 1) //First a
//                                                  begin
//                                                  OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                  end     
                                                  
//                                         else if (x_wire >= 35 && x_wire <= 39  && y_wire >=58  && y_wire <= 58 && page_1_flag == 1) 
//                                                  begin
//                                                  OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                  end  
                                                  
//                                         else if (x_wire >= 35 && x_wire <= 35  && y_wire >=54  && y_wire <= 58 && page_1_flag == 1) 
//                                                  begin
//                                                  OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                  end
                                        
//                                         else if (x_wire >= 39 && x_wire <= 39  && y_wire >=54  && y_wire <= 58 && page_1_flag == 1) 
//                                                  begin
//                                                  OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                  end  





//e

 else if (x_wire >= 35 && x_wire <= 39  && y_wire >=54  && y_wire <= 54 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end     
                                  
                         else if (x_wire >= 35 && x_wire <= 39  && y_wire >=56  && y_wire <= 56 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end  
                                  
                         else if (x_wire >= 35 && x_wire <= 35  && y_wire >=54  && y_wire <= 58 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end
                        
                         else if (x_wire >= 39 && x_wire <= 39  && y_wire >=54  && y_wire <= 56 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end    
                      
                     else if (x_wire >= 35 && x_wire <= 39  && y_wire >=58  && y_wire <= 58 && page_1_flag == 1) 
                                  begin
                                  OLED_DATA_OUT = 16'b11111_111111_00000;
                                  end



//e end














//              else if (x_wire >= 40 && x_wire <= 41  && y_wire >=56  && y_wire <= 57 && page_1_flag == 1) 
//                                                  begin
//                                                  OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                  end                                  
//     else if (x_wire >= 42 && x_wire <= 43  && y_wire >=57  && y_wire <= 58 && page_1_flag == 1) 
//                                                    begin
//                                                    OLED_DATA_OUT = 16'b11111_111111_00000;
//                                                    end 
    
    else if (x_wire >= 41 && x_wire <= 41  && y_wire >=51  && y_wire <= 54 && page_1_flag == 1) 
                                   begin
                                   OLED_DATA_OUT = 16'b11111_111111_00000;
                                   end
  
  else if (x_wire >= 41 && x_wire <= 45  && y_wire >=54  && y_wire <= 54 && page_1_flag == 1) 
                                     begin
                                     OLED_DATA_OUT = 16'b11111_111111_00000;
                                     end  
   
else if (x_wire >= 45 && x_wire <= 45  && y_wire >=51  && y_wire <= 58 && page_1_flag == 1) 
                              begin
                              OLED_DATA_OUT = 16'b11111_111111_00000;
                              end     
    
else if (x_wire >= 41 && x_wire <= 45  && y_wire >=58  && y_wire <= 58 && page_1_flag == 1) 
                             begin
                             OLED_DATA_OUT = 16'b11111_111111_00000;
                              end    
      

else if(x_wire >=86 && x_wire <=86 && y_wire>=51 && y_wire <=58 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
                                                              
   else if(x_wire >=89 && x_wire <=93 && y_wire>=51 && y_wire <=51 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
                                     
   else if(x_wire >=89 && x_wire <=93 && y_wire>=58 && y_wire <=58 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 
   else if(x_wire >=89 && x_wire <=89 && y_wire>=51 && y_wire <=58 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end  
   else if(x_wire >=93 && x_wire <=93 && y_wire>=51 && y_wire <=58 && page_1_flag == 1)
                       begin
                       OLED_DATA_OUT = 16'b11111_111111_00000;
                       end 



//page 2 trial

 else if(x_wire >=11 && x_wire <=12 && y_wire >=0 && y_wire <= 63 && page_2_flag == 1)   //left column ends at 13
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=9 && y_wire <= 9 && page_2_flag == 1)
    begin
     OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=20 && y_wire <= 20 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=30 && y_wire <= 30 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >=40 && y_wire <= 40 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
     
    else if(x_wire >=0 && x_wire <=95 && y_wire >= 50 && y_wire <= 50 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=0 && x_wire <=95 && y_wire >= 60 && y_wire <= 60 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    

      
    else if(x_wire >=80 && x_wire <=81 && y_wire >= 0 && y_wire <= 63 && page_2_flag == 1)  //right column ends 82
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
      
    //input first items and headers  
    else if(x_wire >=20 && x_wire <=27 && y_wire >= 1 && y_wire <= 1 && page_2_flag == 1)
    begin
    OLED_DATA_OUT = 16'b11111_111111_11111;
    end
    
    else if(x_wire >=24 && x_wire <=24 && y_wire >= 1 && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if(x_wire >=20 && x_wire <=27 && y_wire >= 8 && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    
    else if (x_wire >= 30 && x_wire <=37  && y_wire >=1  && y_wire <= 1 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 33 && x_wire <=33  && y_wire >=1  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=1  && y_wire <= 1 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end    
    
    else if (x_wire >= 40 && x_wire <=40  && y_wire >=1  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=4  && y_wire <= 4 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 40 && x_wire <=47  && y_wire >=8  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 52 && x_wire <=52  && y_wire >=1  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        
    else if (x_wire >= 52 && x_wire <=59  && y_wire >=1  && y_wire <= 1 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 55 && x_wire <=55  && y_wire >=1  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
    
    else if (x_wire >= 59 && x_wire <=59  && y_wire >=1  && y_wire <= 8 && page_2_flag == 1)
        begin
        OLED_DATA_OUT = 16'b11111_111111_11111;
        end
        //dollar sign
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=1  && y_wire <= 1 && page_2_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 86 && x_wire <=86  && y_wire >=1  && y_wire <= 3 && page_2_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
                
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=3  && y_wire <= 3 && page_2_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 93 && x_wire <=93  && y_wire >=3  && y_wire <= 7 && page_2_flag == 1) 
            begin
            OLED_DATA_OUT = 16'b11111_111111_11111;
            end
            
    else if (x_wire >= 86 && x_wire <=93  && y_wire >=7  && y_wire <= 7 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
             
    else if (x_wire >= 90 && x_wire <=90  && y_wire >=0  && y_wire <= 8 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
                 
    else if (x_wire >= 88 && x_wire <=88  && y_wire >=0  && y_wire <= 8 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_11111;
             end
             















//R


 else if (x_wire >= 20 && x_wire <= 25  && y_wire >=11  && y_wire <= 11 && page_2_flag == 1) 
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end   
 
                    
else if (x_wire >= 20 && x_wire <= 20  && y_wire >=11  && y_wire <= 18 && page_2_flag == 1) 
                                    begin
                                    OLED_DATA_OUT = 16'b11111_111111_00000;
                                    end    
   
else if (x_wire >= 25 && x_wire <= 25  && y_wire >=11  && y_wire <= 13 && page_2_flag == 1) 
                                                      begin
                                                      OLED_DATA_OUT = 16'b11111_111111_00000;
                                                      end   
  else if (x_wire >= 20 && x_wire <= 25  && y_wire >=13  && y_wire <= 13 && page_2_flag == 1) 
                        begin
                        OLED_DATA_OUT = 16'b11111_111111_00000;
                         end  
                         
  else if(x_wire >= 21 && x_wire <= 21  && y_wire >=14  && y_wire <= 14 && page_2_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end                        
           
  else if(x_wire >= 22 && x_wire <= 22  && y_wire >=15  && y_wire <= 15 && page_2_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
           
  else if(x_wire >= 23 && x_wire <= 23  && y_wire >=16  && y_wire <= 16 && page_2_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
  
  else if(x_wire >= 24 && x_wire <= 24  && y_wire >=17  && y_wire <= 17 && page_2_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end          
   else if(x_wire >= 25 && x_wire <= 25  && y_wire >=18  && y_wire <= 18 && page_2_flag == 1)
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end

//O

 else if (x_wire >= 29 && x_wire <= 33  && y_wire >=14  && y_wire <= 14 && page_2_flag == 1) //First O
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end     
             
    else if (x_wire >= 29 && x_wire <= 33  && y_wire >=18  && y_wire <= 18 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end  
             
    else if (x_wire >= 29 && x_wire <= 29  && y_wire >=14  && y_wire <= 18 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
   
    else if (x_wire >= 33 && x_wire <= 33  && y_wire >=14  && y_wire <= 18 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
//C

else if (x_wire >= 35 && x_wire <= 39  && y_wire >=14  && y_wire <= 14 && page_2_flag == 1) // 2nd O
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end     
                         
    else if (x_wire >= 35 && x_wire <= 39  && y_wire >=18  && y_wire <= 18 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end  
                         
    else if (x_wire >= 35 && x_wire <= 35  && y_wire >=14  && y_wire <= 18 && page_2_flag == 1) 
             begin
             OLED_DATA_OUT = 16'b11111_111111_00000;
             end
               
 //k
else if (x_wire >= 41 && x_wire <= 41  && y_wire >=11  && y_wire <= 18 && page_2_flag == 1) 
              begin
              OLED_DATA_OUT = 16'b11111_111111_00000;
              end
 
 else if (x_wire >= 42 && x_wire <= 43  && y_wire >=14  && y_wire <= 14 && page_2_flag == 1) 
              begin
              OLED_DATA_OUT = 16'b11111_111111_00000;
              end
              
 else if (x_wire >= 44 && x_wire <= 44  && y_wire >=13  && y_wire <= 13 && page_2_flag == 1) 
               begin
               OLED_DATA_OUT = 16'b11111_111111_00000;
                end             
else if (x_wire >= 45 && x_wire <= 45  && y_wire >=12  && y_wire <= 12 && page_2_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end              
              
 else if (x_wire >= 46 && x_wire <= 46  && y_wire >=11  && y_wire <= 11 && page_2_flag == 1) 
               begin
               OLED_DATA_OUT = 16'b11111_111111_00000;
               end              
              
 
 else if (x_wire >= 44 && x_wire <= 44  && y_wire >=15  && y_wire <= 15 && page_2_flag == 1) 
              begin
              OLED_DATA_OUT = 16'b11111_111111_00000;
              end             
 else if (x_wire >= 45 && x_wire <= 45  && y_wire >=16  && y_wire <= 16 && page_2_flag == 1) 
               begin
               OLED_DATA_OUT = 16'b11111_111111_00000;
               end              
                             
  else if (x_wire >= 46 && x_wire <= 46  && y_wire >=17  && y_wire <= 17 && page_2_flag == 1) 
                begin
                OLED_DATA_OUT = 16'b11111_111111_00000;
                end   
  //price of rock
  
  
   else if (x_wire >= 86 && x_wire <=93  && y_wire >=11  && y_wire <= 11 && page_2_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end
                 
         else if (x_wire >= 86 && x_wire <=86  && y_wire >=11  && y_wire <= 13 && page_2_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end
                     
         else if (x_wire >= 86 && x_wire <=93  && y_wire >=13  && y_wire <= 13 && page_2_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end
                 
         else if (x_wire >= 93 && x_wire <=93  && y_wire >=13  && y_wire <= 17 && page_2_flag == 1) 
                 begin
                 OLED_DATA_OUT = 16'b11111_111111_00000;
                 end
                 
         else if (x_wire >= 86 && x_wire <=93  && y_wire >=17  && y_wire <= 17 && page_2_flag == 1) 
                  begin
                  OLED_DATA_OUT = 16'b11111_111111_00000;
                  end
              
    
    else
    begin
    OLED_DATA_OUT = 16'b00000_000000_00000;
    end 
    
     if (within_cursor && cursor_color != 16'b1111_11111_1111) 
       begin
       OLED_DATA_OUT = cursor_color;
       end
       
    if(right == 1 && sw[1] == 1 && sw[0] == 0 && sw[2] == 0)
       begin
       buy_clicked_flag = 0;
       purchase_start_flag = 0;
       
       end
   
   
end //buy click flag end


end

endmodule
