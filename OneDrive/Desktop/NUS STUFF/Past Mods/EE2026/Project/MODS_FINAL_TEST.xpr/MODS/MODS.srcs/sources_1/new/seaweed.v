`timescale 1ns / 1ps
module seaweed(
    input clk,
    input [6:0] x_base,
    input [12:0] pixel_index,
    input [6:0] fishx,
    input [5:0] fishy,
    input fish_direction, //0 means fish coming from the left
    output reg iswithin,
    output reg [15:0] seaweed_colour,
    output reg ld
    );
    
    parameter green = 16'b00010_011100_00100;
    reg [4:0] oscillator;
    wire slow_clk;
    wire [4:0] sway_amt1, sway_amt2, sway_amt3, sway_amt4, sway_amt5, sway_amt6, sway_amt7, sway_amt8;
    reg [4:0] fish_override1, fish_override2, fish_override3, fish_override4, fish_override5, fish_override6, fish_override7, fish_override8;
    reg [4:0] fish_collision1, fish_collision2, fish_collision3, fish_collision4, fish_collision5, fish_collision6, fish_collision7, fish_collision8;
    reg [4:0] fish_collision1a, fish_collision2a, fish_collision3a, fish_collision4a, fish_collision5a, fish_collision6a, fish_collision7a, fish_collision8a;
    wire [15:0] r1colour, r2colour, r3colour, r4colour, r5colour, r6colour, r7colour, r8colour;
    wire withinr1, withinr2, withinr3, withinr4, withinr5, withinr6, withinr7, withinr8;

    CLK_Divider(clk, 62499 * 2, slow_clk);
    rectangle r1(.x(x_base + sway_amt1 - fish_override1 + fish_collision1 - fish_collision1a), .y(63), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r1colour), .is_within(withinr1));
    rectangle r2(.x(x_base + sway_amt2 - fish_override2 + fish_collision2 - fish_collision2a), .y(58), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r2colour), .is_within(withinr2));
    rectangle r3(.x(x_base + sway_amt3 - fish_override3 + fish_collision3 - fish_collision3a), .y(53), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r3colour), .is_within(withinr3));
    rectangle r4(.x(x_base + sway_amt4 - fish_override4 + fish_collision4 - fish_collision4a), .y(48), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r4colour), .is_within(withinr4));
    rectangle r5(.x(x_base + sway_amt5 - fish_override5 + fish_collision5 - fish_collision5a), .y(43), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r5colour), .is_within(withinr5));
    rectangle r6(.x(x_base + sway_amt6 - fish_override6 + fish_collision6 - fish_collision6a), .y(38), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r6colour), .is_within(withinr6));
    rectangle r7(.x(x_base + sway_amt7 - fish_override7 + fish_collision7 - fish_collision7a), .y(33), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r7colour), .is_within(withinr7));
    rectangle r8(.x(x_base + sway_amt8 - fish_override8 + fish_collision8 - fish_collision8a), .y(28), .width(5), .height(5), .colour(green), .clock(clk), .pixel_index(pixel_index), .pixel_data(r8colour), .is_within(withinr8));
    sine s1(.index(oscillator), .sine_out(sway_amt1));
    sine s2(.index((oscillator + 1) % 20), .sine_out(sway_amt2));
    sine s3(.index((oscillator + 2) % 20), .sine_out(sway_amt3));
    sine s4(.index((oscillator + 3) % 20), .sine_out(sway_amt4));
    sine s5(.index((oscillator + 4) % 20), .sine_out(sway_amt5));
    sine s6(.index((oscillator + 5) % 20), .sine_out(sway_amt6));
    sine s7(.index((oscillator + 6) % 20), .sine_out(sway_amt7));
    sine s8(.index((oscillator + 7) % 20), .sine_out(sway_amt8));
    
    always @(posedge slow_clk) begin
        oscillator <= (oscillator >= 19) ? 0 : oscillator + 1; // Fixed to correctly loop through 0 to 19
    end
    
    always @(posedge clk) begin    
        // Segment 1
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 58) && (fishy <= 63) && fish_direction == 0) begin
            fish_override1 = sway_amt1;
            fish_collision1 = 5;
            fish_collision1a = 0;            
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 58) && (fishy <= 63) && fish_direction == 1) begin
            fish_override1 = sway_amt1;
            fish_collision1 = 0;
            fish_collision1a = 4;
        end else begin
            fish_override1 = 0;
            fish_collision1 = 0;
            fish_collision1a = 0;
        end
    
        // Segment 2
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 53) && (fishy <= 58) && fish_direction == 0) begin
            fish_override2 = sway_amt2;
            fish_collision2 = 5;
            fish_collision2a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 53) && (fishy <= 58) && fish_direction == 1) begin
            fish_override2 = sway_amt2;
            fish_collision2 = 0;
            fish_collision2a = 4;
        end else begin
            fish_override2 = 0;
            fish_collision2 = 0;
            fish_collision2a = 0;
        end
    
        // Segment 3
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 48) && (fishy <=53) && fish_direction == 0) begin
            fish_override3 = sway_amt3;
            fish_collision3 = 5;
            fish_collision3a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 48) && (fishy <= 53) && fish_direction == 1) begin
            fish_override3 = sway_amt3;
            fish_collision3 = 0;
            fish_collision3a = 4;
        end else begin
            fish_override3 = 0;
            fish_collision3 = 0;
            fish_collision3a = 0;
        end
    
        // Segment 4
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 43) && (fishy <= 48) && fish_direction == 0) begin
            fish_override4 = sway_amt4;
            fish_collision4 = 5;
            fish_collision4a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 43) && (fishy <= 48) && fish_direction == 1) begin
            fish_override4 = sway_amt4;
            fish_collision4 = 0;
            fish_collision4a = 4;
        end else begin
            fish_override4 = 0;
            fish_collision4 = 0;
            fish_collision4a = 0;
        end
        
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 38) && (fishy <= 43) && fish_direction == 0) begin
            fish_override5 = sway_amt5;
            fish_collision5 = 5;
            fish_collision5a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 38) && (fishy <= 43) && fish_direction == 1) begin
            fish_override5 = sway_amt5;
            fish_collision5 = 0;
            fish_collision5a = 4;
        end else begin
            fish_override5 = 0;
            fish_collision5 = 0;
            fish_collision5a = 0;
        end
    
        // Segment 6
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 33) && (fishy <= 38) && fish_direction == 0) begin
            fish_override6 = sway_amt6;
            fish_collision6 = 5;
            fish_collision6a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 33) && (fishy <= 38) && fish_direction == 1) begin
            fish_override6 = sway_amt6;
            fish_collision6 = 0;
            fish_collision6a = 4;
        end else begin
            fish_override6 = 0;
            fish_collision6 = 0;
            fish_collision6a = 0;
        end
    
        // Segment 7
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 28) && (fishy <= 33) && fish_direction == 0) begin
            fish_override7 = sway_amt7;
            fish_collision7 = 5;
            fish_collision7a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 28) && (fishy <= 33) && fish_direction == 1) begin
            fish_override7 = sway_amt7;
            fish_collision7 = 0;
            fish_collision7a = 4;
        end else begin
            fish_override7 = 0;
            fish_collision7 = 0;
            fish_collision7a = 0;
        end
    
        // Segment 8
        if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 23) && (fishy <= 28) && fish_direction == 0) begin
            fish_override8 = sway_amt8;
            fish_collision8 = 5;
            fish_collision8a = 0;
        end else if ((fishx >= x_base - 5) && (fishx <= x_base + 10) && (fishy >= 23) && (fishy <= 28) && fish_direction == 1) begin
            fish_override8 = sway_amt8;
            fish_collision8 = 0;
            fish_collision8a = 4;
        end else begin
            fish_override8 = 0;
            fish_collision8 = 0;
            fish_collision8a = 0;
        end

    
    
    
        if (withinr1) begin
            seaweed_colour = r1colour;
            iswithin = 1;
        end else if (withinr2) begin
            seaweed_colour = r2colour;
            iswithin = 1;
        end else if (withinr3) begin
            seaweed_colour = r3colour;
            iswithin = 1;
        end else if (withinr4) begin
            seaweed_colour = r4colour;
            iswithin = 1;
        end else if (withinr5) begin
            seaweed_colour = r5colour;
            iswithin = 1;
        end else if (withinr6) begin
            seaweed_colour = r6colour;
            iswithin = 1;
        end else if (withinr7) begin
            seaweed_colour = r7colour;
            iswithin = 1;
        end else if (withinr8) begin
            seaweed_colour = r8colour;
            iswithin = 1;
        end else begin
            seaweed_colour = 0;
            iswithin = 0;
        end
    end
endmodule