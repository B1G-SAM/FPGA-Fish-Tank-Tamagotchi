`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 15:00:39
// Design Name: 
// Module Name: parameter_logic
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
// Create Date: 27.03.2024 13:06:20
// Design Name: 
// Module Name: parameter_logic
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


module parameter_logic(
    input CLOCK,
    input [15:0] sw,
    input [12:0] pixel_index_wire,
    input [6:0] money,
    input [11:0] mouse_x, mouse_y,
    input left_mouse_btn_wire, right_mouse_btn_wire,
    input is_eaten,
    input bed_wire,
    input [6:0] score,
    input [6:0] high_score,
    output [15:0] OLED_Data_wire,
    output reg dp,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg [6:0] fatigue = 0
    );
    
    // timings for seven seg ///////////////////////////////////////////////////////
    wire clk_1KHz, clk_2s, clk_6_25Mhz;
    reg [1:0] seven_seg_refresh;
    // 20 states in one day
    reg [4:0] day_state = 6;
    CLK_Divider seven_seg_clk (.CLOCK(CLOCK), .M(49999), .out(clk_1KHz));
    CLK_Divider day_state_clk (.CLOCK(CLOCK), .M(99999999), .out(clk_2s));
    CLK_Divider feed_clk (.CLOCK(CLOCK), .M(7), .out(clk_6_25Mhz));

    // cycles through every milisecond
    always @ (posedge clk_1KHz) begin
        seven_seg_refresh = seven_seg_refresh + 1;
    end
    
    reg [6:0] health = 99;
    reg [6:0] hunger = 99;
    // updates every second
    always @ (posedge clk_2s) begin
        if (sw[0] == 1 && sw[1] == 0 && sw[2] == 0)
        begin
            // total of 24 states
            if (day_state == 24) begin
                day_state = 0;
            end
            day_state = day_state + 1;
            
            // checks for invalid param values
            // take note values cannot actually be negative
            
            // update health param values
            if (hunger <= 60) begin
                health = health - 1;
                if (hunger <= 50) begin
                    health = health - 2;
                    if (hunger <= 20) begin
                        health = health - 5;
                    end
                end
                if (health >= 100) begin
                    health = 0;
                end
            end
            if (hunger >= 70) begin
                health = health + 1;
                if (hunger >= 80) begin
                    health = health + 2;
                    if (hunger >= 90) begin
                        health = health + 5;
                    end
                end
                if (health >= 100) begin
                    health = 99;
                end
            end
            
            if (fatigue >= 60) begin
                health = health - 1;
                if (fatigue >= 70) begin
                    health = health - 2;
                    if (fatigue >= 90) begin
                        health = health - 5;
                    end
                end
                if (health >= 100) begin
                    health = 0;
                end
            end
            
            if (fatigue <= 40) begin
                health = health + 1;
                if (fatigue <= 30) begin
                    health = health + 2;
                    if (fatigue <= 10) begin
                        health = health + 5;
                    end
                end
                if (health >= 100) begin
                    health = 99;
                end
            end
            
            // update fatigue param
            fatigue = fatigue + 2;
            if (fatigue >= 100) begin
                fatigue = 99;
            end
            
            // update day_state
            if (day_state == 24) begin
                if (bed_wire == 1) begin
                    if (fatigue < 60) begin
                        fatigue = 0;
                    end
                    else begin
                        fatigue = fatigue - 60;
                    end
                end
                else begin
                    if (fatigue <= 14) begin
                        fatigue = 0;
                    end
                    else begin
                        fatigue = fatigue - 30;
                    end
                end
            end
        end
    end
    
    // being fed logic //////////////////////////////////////////////////////////////////////
    always @ (posedge is_eaten or posedge clk_2s) begin
        // update hunger param values
        
        if (is_eaten == 1) begin
//            if (hunger > 99) begin
//                hunger = 99;
//            end
//            else begin
//                hunger = hunger + 1;
//            end
            hunger = 99;
        end
        
        
        else if (sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            if (hunger == 0) begin
                hunger = 0;
            end
            else begin
                hunger = hunger - 1;
            end           
        end
    
    end
    
    // 0 represent cash, 1 represents health, 2 represents hunger, 3 represents fatigue, 5 represents null, 4 doesnt represent anything yet
    reg [2:0] param_state;
    reg [2:0] prev_param_state;
    reg [6:0] param_value;
    wire [6:0] seven_seg_first_digit, seven_seg_second_digit;
    reg seven_seg_counter;
    
    localparam H = 7'b0001001;
    localparam E = 7'b0000110;
    localparam U = 7'b1000001;
    localparam F = 7'b0001110;
    localparam A = 7'b0001000;
    localparam C = 7'b1000110;
    localparam O = 7'b1000000;
    localparam S = 7'b0010010;
    
    seven_seg_control controller (
        .CLOCK(CLOCK),
        .number(param_value),
        .seg1(seven_seg_first_digit),
        .seg2(seven_seg_second_digit)
    );
    
    // drawing logic //////////////////////////////////////////////////
    parameter_drawing_logic draw_logic (
        .clk          (CLOCK),
        .health       (health), 
        .hunger       (hunger), 
        .fatigue      (fatigue),
        .pixel_index  (pixel_index_wire),
        .mouse_x      (mouse_x),
        .mouse_y      (mouse_y),
        .sw           (sw[15:0]),
        .day_state    (day_state[4:0]),
        .OLED_DATA_OUT(OLED_Data_wire)
    );
    
    // 7 seg logic ////////////////////////////////////////////////////////////
    always @ (posedge CLOCK) begin
        // reset logic ////////////////////////////////////////////////////////
//        if (reset == 1) begin
//            param_state = 3'b000;
//            health = 99;
//            hunger = 99;
//            fatigue = 0;
//            day_state = 6;
//        end
        // click detection ////////////////////////////////////////////////////
        // to default to cash if in shop instead of aquarium or if right click
        if ((sw[1] == 1 && sw[0] == 0 && sw[2] == 0)) begin
            param_state = 3'b000;
        end
        else if (right_mouse_btn_wire == 1 && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            param_state = 3'b000;
            prev_param_state = 3'b000;
        end
        // area around heart
        else if (mouse_x>=0 && mouse_x<=20 && mouse_y>=0 && mouse_y<=6 && left_mouse_btn_wire == 1 && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            param_state = 3'b001;
            prev_param_state = 3'b001;
        end
        // area around hunger
        else if (mouse_x>=0 && mouse_x<=20 && mouse_y>=8 && mouse_y<=16 && left_mouse_btn_wire == 1 && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            param_state = 3'b010;
            prev_param_state = 3'b010;
        end
        // area around fatigue
        else if (mouse_x>=0 && mouse_x<=20 && mouse_y>=18 && mouse_y<=23 && left_mouse_btn_wire == 1 && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            param_state = 3'b011;
            prev_param_state = 3'b011;
        end
        // area around sun and moon
        else if (mouse_x>=85 && mouse_x<=96 && mouse_y>=0 && mouse_y<=10 && left_mouse_btn_wire == 1 && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
            param_state = 3'b101;
            prev_param_state = 3'b101;
        end
        else if (sw[0] == 1 && sw[1] == 0 && sw[2] == 0)begin
            param_state = prev_param_state;
        end
        else if (sw[15] == 1 && sw[1] == 0 && sw[2] == 1 && sw[0] == 0) begin
            param_state = 3'b110;
        end
        else if (sw[2] == 1 && sw[1] == 0 && sw[0] == 0) begin
            param_state = 3'b100;
        end
        else begin
            param_state = 3'b111;
        end
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        case (param_state)
            3'b000: param_value = money;
            3'b001: param_value = health;
            3'b010: param_value = hunger;
            3'b011: param_value = fatigue;
            3'b100: param_value = score;
            3'b110: param_value = high_score;
            3'b101: param_value = day_state;
        endcase
        
        case(seven_seg_refresh)
            2'b00: begin
                if (param_state == 3'b111) begin
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
                else begin
                    an = 4'b1110; // Activate the first anode (rightmost digit)
                    seg = seven_seg_first_digit;           
                end
                dp = 1'b1;
            end
            2'b01: begin
                if (param_state == 3'b111) begin
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
                else begin
                    an = 4'b1101; // Activate the second anode
                    seg = seven_seg_second_digit;
                end
                dp = 1'b1;
            end
            2'b10: begin
                if (param_state == 3'b111) begin
                    an = 4'b1111;
                    seg = 7'b1111111;
                    an = 1'b1;
                end
                else begin
                    an = 4'b1011; // Activate the third anode
                    dp = 1'b0;
                end
                if (param_state == 3'b000) begin
                    seg = A;
                end
                else if (param_state == 3'b001) begin
                    seg = E;
                end
                else if (param_state == 3'b010) begin
                    seg = U;
                end
                else if (param_state == 3'b011)begin
                    seg = A;
                end
                else if (param_state == 3'b101)begin
                    seg = O;
                end
                else if (param_state == 3'b100) begin
                    seg = C;
                end
                else if (param_state == 3'b110) begin
                    seg = S;
                end
            end
            2'b11: begin
                if (param_state == 3'b111) begin
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
                else begin
                    an = 4'b0111; // Activate the fourth anode
                end
                
                dp = 1'b1;
                if (param_state == 3'b000) begin
                    seg = C;
                end
                else if (param_state == 3'b001) begin
                    seg = H;
                end
                else if (param_state == 3'b010) begin
                    seg = H;
                end
                else if (param_state == 3'b011) begin
                    seg = F;
                end
                else if (param_state == 3'b101) begin
                    seg = H;
                end
                else if (param_state == 3'b100) begin
                    seg = S;
                end
                else if (param_state == 3'b110) begin
                    seg = H;
                end
            end
        endcase
            
            
    end
endmodule

