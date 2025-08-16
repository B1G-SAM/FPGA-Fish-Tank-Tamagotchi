`timescale 1ns / 1ps

module Bubble(
    input wire [12:0] pixel_index, // Assumes a 160x120 screen resolution
    input wire CLK_6_25_MHz,
    input wire enable,
    input wire reset,
    input wire [6:0] x_center, // Bubble center X coordinate
    input wire [5:0] y_center, // Bubble center Y coordinate
    output reg [15:0] colour, // RGB565 color format
    output reg iswithin
);

// Parameters for the screen resolution, bubble radius, and thickness of the bubble line
parameter screen_width = 96, screen_height = 64;
parameter bubble_radius_squared = 5 * 5; // Square of the bubble radius to avoid square root calculation
parameter bubble_thickness = 1; // Thickness of the bubble's line
parameter bubble_color = 16'h07FF; // Light blue color for the bubble

wire [6:0] current_x = pixel_index % screen_width;
wire [5:0] current_y = pixel_index / screen_width;


wire signed [7:0] x_diff = current_x - x_center;
wire signed [7:0] y_diff = current_y - y_center;


wire signed [15:0] distance_squared = x_diff * x_diff + y_diff * y_diff;

parameter inner_radius_squared = (5 - bubble_thickness) * (5 - bubble_thickness);
parameter outer_radius_squared = bubble_radius_squared;

always @(posedge CLK_6_25_MHz) begin
    if (enable && !reset) begin
        if (distance_squared <= outer_radius_squared && distance_squared >= inner_radius_squared) begin
            colour <= bubble_color; 
            iswithin <= 1;
        end else begin
            colour <= 16'h0000; 
            iswithin <= 0;
        end
    end else if (reset) begin
        colour <= 16'h0000;
        iswithin <= 0;
    end
end

endmodule
