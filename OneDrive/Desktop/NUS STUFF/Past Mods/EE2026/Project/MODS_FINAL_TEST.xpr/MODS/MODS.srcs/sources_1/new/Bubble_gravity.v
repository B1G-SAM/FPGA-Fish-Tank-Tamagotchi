`timescale 1ns / 1ps

module Bubble_gravity(
    input CLK_6_25_MHz,
    input enable,
    input reset,
    input [6:0] initialx,
    input [5:0] initialy,
    input [6:0] fish_x,
    input [5:0] fish_y,
    output reg [6:0] x_center,
    output reg [5:0] y_center
);

parameter screen_top = 0;
parameter initial_tick_duration = 800000; // Slower initial movement
parameter min_tick_duration = 10000;
parameter tick_decrement_start = 3000; // Less aggressive initial acceleration
parameter tick_decrement_acceleration = 100; // Gradual increase in acceleration
parameter fish_width = 8;
parameter fish_height = 5;

// Assuming bubble width as 5 pixels
parameter bubble_width_half = 2; // Half width of bubble for collision detection

reg [20:0] position;
reg [24:0] counter = 0;
reg [20:0] tick_duration = initial_tick_duration;
reg [20:0] tick_decrement = tick_decrement_start;
reg init = 0;



always @(posedge CLK_6_25_MHz) begin
    if (init == 0) begin
        position <= initialy;
        x_center <= initialx;
        init = 1;
    end
    if (reset) begin
        position <= initialy;
        x_center <= initialx;
        counter <= 0;
        tick_duration <= initial_tick_duration;
        tick_decrement <= tick_decrement_start;
    end else if (enable) begin
        if (counter < tick_duration) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;

            // Expand collision check to account for bubble's width
            if ((x_center + bubble_width_half >= fish_x && x_center - bubble_width_half <= fish_x + fish_width - 1) &&
                (position >= fish_y && position <= fish_y + fish_height - 1)) begin
                position <= position + 1;
                x_center <= x_center + 1;
            end else begin
                position <= position - 1;
            end

            if (tick_duration > min_tick_duration) begin
                tick_duration <= tick_duration - tick_decrement;
                tick_decrement <= tick_decrement + tick_decrement_acceleration;
            end

            if (position <= screen_top || position > initialy) begin
                position <= initialy;
                tick_duration <= initial_tick_duration;
                tick_decrement <= tick_decrement_start;
                x_center <= initialx;
            end
        end
    end

    y_center <= position[5:0];
end

endmodule
