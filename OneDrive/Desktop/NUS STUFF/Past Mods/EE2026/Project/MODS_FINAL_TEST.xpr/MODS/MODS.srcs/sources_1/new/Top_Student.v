`timescale 1ns / 1ps


module Top_Student(
    input CLOCK,
    input [15:0] sw,
    input btnD, btnL, btnR, btnU, btnC,
    inout PS2Clk,
    inout PS2Data,
    output[15:0] led,
    output dp,
    output [6:0] seg,
    output [3:0] an,
    output [7:0] JC,
    input wire uart_rx,
    output wire uart_tx
    );
    
    
    //global variables for bed, fishes and rock
    reg bed_present;
    reg fish_1_present;
    reg fish_2_present;
    reg rock_present;
    wire [6:0] fatigue;
    
    initial begin
       bed_present = 0;
       fish_1_present = 1;
       fish_2_present = 0;
       rock_present = 0;
    end
    
    // instantiate OLED ////////////////////////////////////////////////////////////
    wire clk_6_25_MHz;
    CLK_Divider oled_clk (.CLOCK(CLOCK), .M(7), .out(clk_6_25_MHz));
    wire frame_begin_wire;
    wire sending_pixel_wire;
    wire sample_pixel_wire;
    wire [12:0] pixel_index_wire;
    wire [15:0] OLED_parameter_Data_wire;
    wire [15:0] OLED_Data_wire;
    
    Oled_Display (
        .clk          (clk_6_25_MHz),
        .reset        (0), 
        .frame_begin  (frame_begin_wire), 
        .sending_pixels(sending_pixel_wire),
        .sample_pixel (sample_pixel_wire), 
        .pixel_index  (pixel_index_wire),
        .pixel_data   (OLED_Data_wire),
        .cs           (JC[0]), 
        .sdin         (JC[1]),
        .sclk         (JC[3]),
        .d_cn         (JC[4]),
        .resn         (JC[5]),
        .vccen        (JC[6]),
        .pmoden       (JC[7])
    );
    
    //mouse instantiation
        wire [11:0] xpos_wire;
        wire [11:0] ypos_wire;
        wire [3:0]  zpos_wire;
        wire left_mouse_btn_wire;
        wire middle_mouse_btn_wire; 
        wire right_mouse_btn_wire;
        wire new_event_wire;
        
        MouseCtl mouse(
            .clk(CLOCK),
            .rst(0), 
            .value(0), 
            .setx(0), 
            .sety(0), 
            .setmax_x(0), 
            .setmax_y(0),
            .xpos(xpos_wire), 
            .ypos(ypos_wire), 
            .zpos(zpos_wire), 
            .left(left_mouse_btn_wire),
            .middle(middle_mouse_btn_wire), 
            .right(right_mouse_btn_wire), 
            .new_event(new_event_wire),
            .ps2_clk(PS2Clk),
            .ps2_data(PS2Data)
            );
    
    // instantiate shop /////////////////////////////////////////////////////////////
        wire [15:0] OLED_DATA_OUT_SHOP_wire;
        wire food_flag_wire;
        wire bed_wire;
        wire green_flag_wire;
        wire red_flag_wire;
        wire grey_flag_wire;
        wire [6:0] money;
        wire rock_wire;
        wire is_eaten;
        wire food_dropped;
        wire [15:0] colour_primary_fish;
        SHOP (
            .CLOCK        (CLOCK),
            .clk625       (clk_6_25_MHz),
            .btnD         (btnD),
            .btnU         (btnU),
            .sw           (sw),
            .JC           (JC),
            .pixel_index  (pixel_index_wire),
            .mouse_x      (xpos_wire),
            .mouse_y      (ypos_wire),
            .left         (left_mouse_btn_wire),
            .right        (right_mouse_btn_wire),
            .is_eaten_flag(is_eaten),
            .food_dropped (food_dropped),
            .led          (led),
            .OLED_DATA_OUT(OLED_DATA_OUT_SHOP_wire),
            .food_flag    (food_flag_wire),
            . bed_flag    (bed_wire),
            .rock_flag    (rock_wire),
            . green_flag  (green_flag_wire),
            . red_flag       (red_flag_wire),
            . grey_flag      (grey_flag_wire),
            .displayed_number (money),
            .colour_primary(colour_primary_fish)
            );
   
   wire [6:0] score;
   wire [6:0] high_score;
   
   // instantiate paramter logic ////////////////////////////////////////////////
   parameter_logic (
        .CLOCK               (CLOCK),
        .sw                  (sw[15:0]),
        .pixel_index_wire    (pixel_index_wire),
        .money               (money),
        .mouse_x             (xpos_wire),
        .mouse_y             (ypos_wire),
        .left_mouse_btn_wire (left_mouse_btn_wire),
        .right_mouse_btn_wire(right_mouse_btn_wire),
        .is_eaten            (is_eaten),
        .bed_wire            (bed_wire),
        .OLED_Data_wire      (OLED_parameter_Data_wire),
        .dp                  (dp),
        .seg                 (seg[6:0]),
        .an                  (an[3:0]),
        .score               (score),
        .high_score          (high_score),
        .fatigue             (fatigue)
        );
        
        
        
        reg [15:0] fish_colour;
        wire within_fish;
        wire [15:0] fish_osc_colour;
        wire [6:0] fish_x;
        wire [5:0] fish_y;
        wire [6:0] x1_coord, x2_coord;
        wire [5:0] y1_coord, y2_coord;
        wire [6:0] new_fish_x;
        wire [5:0] new_fish_y;
        wire fish_flip_wire;
        
  move_Fish_osc fish_instance_1(
       .pixel_index(pixel_index_wire),
       .CLK_6_25_MHz(clk_6_25_MHz),
       .enable(fish_1_present), .reset(0),
       .x(x1_coord), .y(y1_coord),
       .x_target(x2_coord),
       .y_target(y2_coord),
       .primarycolour(colour_primary_fish),
       .secondarycolour(16'b00000_111111_00000),
       .colour(fish_osc_colour),
       .iswithin(within_fish),
       .fish_x(fish_x),
       .fish_y(fish_y),
       .x_collision(new_fish_x),
       .y_collision(new_fish_y),
       .onclick(left_mouse_btn_wire),
       .mouse_x(xpos_wire),
       .mouse_y(ypos_wire)
       );     
       
       
//       wire [15:0] fish_tar_colour;
//       wire within_fish_tar;
//  move_Fish_target fish1(
//      .pixel_index(pixel_index_wire),
//      .CLK_6_25_MHz(clk_6_25_MHz),
//      .enable(fish_1_present), .reset(0),
//      .x(x1_coord), .y(y1_coord),
//      .x_target(xpos_wire),
//      .y_target(ypos_wire),
//      .primarycolour(colour_primary_fish),
//      .secondarycolour(16'b00000_111111_00000),
//      .colour(fish_tar_colour),
//      .iswithin(within_fish_tar),
//      .fish_x(fish_x),
//      .fish_y(fish_y),
//      .x_collision(new_fish_x),
//      .y_collision(new_fish_y)
//      ); 

//        wire [15:0] fish_colour_2;
//        wire within_fish_2;
//        wire [6:0] fish_x_2;
//        wire [5:0] fish_y_2;
//  move_Fish_osc fish_instance_2(.pixel_index(pixel_index_wire),
//     .CLK_6_25_MHz(clk_6_25_MHz),
//     .enable(fish_2_present), .reset(0),
//     .x(25), .y(25),
//     .x_target(65),
//     .y_target(45),
//     .primarycolour(colour_primary_fish),
//     .secondarycolour(16'b00000_111111_00000),
//     .colour(fish_colour_2),
//     .iswithin(within_fish_2),
//     .fish_x(fish_x_2),
//     .fish_y(fish_y_2)
//     );           
       
        wire [15:0] bubble_colour1;
        wire [6:0] bubble_x1;
        wire [5:0] bubble_y1;
        wire within_bubble1;  
        
   Bubble b1(
       .pixel_index(pixel_index_wire),
       .CLK_6_25_MHz(clk_6_25_MHz),
       .enable(1),
       .reset(0), 
       .x_center(bubble_x1), 
       .y_center(bubble_y1),
       .colour(bubble_colour1), 
       .iswithin(within_bubble1)
       );
   
   
   Bubble_gravity bg1(
       .CLK_6_25_MHz(clk_6_25_MHz), 
       .enable(1),
       .reset(0), 
       .initialx(75), 
       .initialy(58), 
       .fish_x(fish_x), 
       .fish_y(fish_y), 
       .x_center(bubble_x1), 
       .y_center(bubble_y1)
       );
       
       wire [15:0] bubble_colour2;
       wire [6:0] bubble_x2;
       wire [5:0] bubble_y2;
       wire within_bubble2;  
       
  Bubble b2(
      .pixel_index(pixel_index_wire),
      .CLK_6_25_MHz(clk_6_25_MHz),
      .enable(1),
      .reset(0), 
      .x_center(bubble_x2), 
      .y_center(bubble_y2),
      .colour(bubble_colour2), 
      .iswithin(within_bubble2)
      );
  
  
  Bubble_gravity bg2(
      .CLK_6_25_MHz(clk_6_25_MHz), 
      .enable(1),
      .reset(0), 
      .initialx(45), 
      .initialy(58), 
      .fish_x(fish_x), 
      .fish_y(fish_y), 
      .x_center(bubble_x2), 
      .y_center(bubble_y2)
      );
      
      
      
      wire [15:0] bubble_colour3;
      wire [6:0] bubble_x3;
      wire [5:0] bubble_y3;
      wire within_bubble3;  
      
 Bubble(
     .pixel_index(pixel_index_wire),
     .CLK_6_25_MHz(clk_6_25_MHz),
     .enable(1),
     .reset(0), 
     .x_center(bubble_x3), 
     .y_center(bubble_y3),
     .colour(bubble_colour3), 
     .iswithin(within_bubble3)
     );
 
 
 Bubble_gravity(
     .CLK_6_25_MHz(clk_6_25_MHz), 
     .enable(1),
     .reset(0), 
     .initialx(25), 
     .initialy(58), 
     .fish_x(fish_x), 
     .fish_y(fish_y), 
     .x_center(bubble_x3), 
     .y_center(bubble_y3)
     );
   
   
        wire [15:0] food_colour;
        wire [6:0] food_x;
        wire [5:0] food_y;
        wire within_food;
        wire food_visible;
        
   Food(
       .pixel_index(pixel_index_wire),
       .CLK_6_25_MHz(clk_6_25_MHz),
       .enable(food_visible),
       .reset(0),
       .x(food_x),
       .y(food_y),
       .colour(food_colour),
       .iswithin(within_food)
       );
   
   move_Food(
       .CLK_6_25_MHz(clk_6_25_MHz),
       .start_x(50),
       .btnL(btnL),
       .btnR(btnR),
       .btnC(btnC),
       .within_fish(within_fish),
       .within_food(within_food),
       .sw(sw),
       .food_purchased(food_flag_wire),
       .x_pos_reg(food_x),
       .y_pos_reg(food_y),
       .is_eaten(is_eaten),
       .food_visible(food_visible),
       .food_released(food_dropped)
       );
       
       wire [15:0] rock_colour;
       wire within_rock;
       
   Rock(
       .CLK(clk_6_25_MHz),
       .enable(rock_present),
       .x(70),
       .y(50),
       .pixel_index(pixel_index_wire),
       .colour(rock_colour),
       .is_within(within_rock)
       );
       
       

       wire within_rock_fish;
   move_Rock(
       .CLK_6_25_MHz(clk_6_25_MHz),
       .rock_purchased(rock_wire),
       .within_fish(within_fish),
       .within_rock(within_rock),
       .fishx(fish_x),
       .fishy(fish_y),
       .within_both(within_rock_fish),
       .new_fishx(new_fish_x),
       .new_fishy(new_fish_y)
       );
       
       wire [15:0] bed_colour;
       wire within_bed;
   Bed(
      .CLK_6_25_MHz(clk_6_25_MHz),
      .enable(bed_present),
      .x(20),
      .y(55),
      .pixel_index(pixel_index_wire),
      .colour(bed_colour),
      .iswithin(within_bed)
       );
       

   
   Double_coord_RNG(
       .clk(CLOCK),
       .x1_coord(x1_coord),
       .y1_coord(y1_coord),
       .x2_coord(x2_coord),
       .y2_coord(y2_coord)
   );
       
   wire [15:0] minigame_color;
   wire minigame_within;
   
   
   minigame minigame_instance (
       .CLK_6_25_MHz(clk_6_25_MHz),
       .reset(0),
       .btnU(btnU),
       .btnR(btnR),
       .btnL(btnL),
       .btnD(btnD),
       .pixel_index(pixel_index_wire),
       .minigame_color(minigame_color),
       .minigame_within(minigame_within),
       .score(score),
       .high_score(high_score),
       .sw(sw[15:0]),
       .btnC(btnC),
       .fatigue(fatigue),
       .fishcolor(colour_primary_fish)
   );
   
   
   wire within_seaweed;
   wire [15:0] seaweed_colour;
   seaweed(
        .clk(clk_6_25_MHz),
        .x_base(10),
        .pixel_index(pixel_index_wire),
        .fishx(fish_x),
        .fishy(fish_y),
        .fish_direction(fish_flip_wire),
        .iswithin(within_seaweed),
        .seaweed_colour(seaweed_colour),
        .ld(led[6])
   );
         
       
    
    reg [15:0] OLED_Data;
    assign OLED_Data_wire = OLED_Data;
    
    always @ (posedge CLOCK) begin     

        
        if (within_fish && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = fish_osc_colour;   
        end else if (within_seaweed && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = seaweed_colour;
        end else if (within_rock && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = rock_colour;
        end else if (within_food && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = food_colour;        
        end else if (within_bed && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = bed_colour;        
        end else if (within_bubble1 && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = bubble_colour1;        
        end else if (within_bubble2 && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = bubble_colour2;        
        end else if (within_bubble3 && sw[0] && ~sw[1] && ~sw[2]) begin
            OLED_Data = bubble_colour3;
        end else if (sw[0] == 1 && ~sw[1] && ~sw[2]) begin
            OLED_Data = OLED_parameter_Data_wire;
        end else if(sw[1] == 1 && ~sw[0] && ~sw[2]) begin
            OLED_Data = OLED_DATA_OUT_SHOP_wire;
        end else if (sw[2] && ~sw[1] && ~sw[0] && minigame_within) begin
            OLED_Data = minigame_color;  
        end else begin
            OLED_Data = 0;
        end 
     end
     
     // Update bed_present based on bed_flag
     always @(posedge CLOCK) begin
         if (bed_wire) begin
             bed_present <= 1;
             fish_2_present <= 1;
         end
         if (rock_wire) begin
            rock_present <= 1;
         end
     end

     // transmitting and receiving between Basys-3 boards //////////
     wire [7:0] tx_data;
     wire tx_valid;
     wire tx_ready;
     wire [7:0] rx_data;
     wire rx_valid;
     
     // instantiate the UART module ////////////////////////////
     uart_module uart_inst (
         .clk(CLOCK),
         .tx_data(tx_data),
         .tx_valid(tx_valid),
         .tx_ready(tx_ready),
         .rx_data(rx_data),
         .rx_valid(rx_valid),
         .uart_rx(uart_rx),
         .uart_tx(uart_tx)
     );
     
     // Assign the tx_data and tx_valid signals based on bed_present
     assign tx_data = bed_present ? 8'b00000001 : 8'b00000000; // Send 0xAA when bed is present, otherwise send 0x00
     //assign tx_valid = bed_present ? 1 : 0; // Set tx_valid to 1 when bed is present, otherwise 0
 
     // Update the fish_present variable based on the received data
     always @(posedge CLOCK) begin
         if (rx_valid) begin
             if (rx_data == 8'b00000001) begin
                 fish_1_present <= 0; // Set fish_present to 0 when the received data is 0xAA (bed present)
             end else begin
                 fish_1_present <= 1; // Set fish_present to 1 when the received data is not 0xAA (no bed)
             end
         end
     end
    
endmodule
