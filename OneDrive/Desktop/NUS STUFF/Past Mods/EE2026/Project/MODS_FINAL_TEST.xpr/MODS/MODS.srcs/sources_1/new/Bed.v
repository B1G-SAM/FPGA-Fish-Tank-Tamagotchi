`timescale 1ns / 1ps

module Bed(
    input CLK_6_25_MHz,
    input enable,
    input [6:0] x, // Upper left x-coordinate of the bed
    input [5:0] y, // Upper left y-coordinate of the bed
    input [12:0] pixel_index, // Current pixel being drawn
    output reg [15:0] colour, // Output color of the pixel
    output reg iswithin 
    );

    // Parameters for the bed's dimensions and color
    parameter BED_WIDTH = 10;
    parameter BED_HEIGHT = 5;
    parameter BED_COLOUR = 16'h07E0; // A color for the bed, e.g., green
    parameter BED_FRAME_WIDTH = 3;
    parameter BED_FRAME_HEIGHT = 10;

    // Screen dimensions (assuming a specific resolution)
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;

    // Derived pixel coordinates from the pixel_index
    wire [6:0] pixel_x = pixel_index % SCREEN_WIDTH;
    wire [5:0] pixel_y = pixel_index / SCREEN_WIDTH;

always @(posedge CLK_6_25_MHz) begin
    // Reset values at the beginning
    colour <= 0;
    iswithin <= 0;

    if (enable) begin
        // First, check if the current pixel is within the bed's area
        if ((pixel_x >= x) && (pixel_x < x + BED_WIDTH) &&
            (pixel_y >= y) && (pixel_y < y + BED_HEIGHT)) begin
            colour <= BED_COLOUR; 
            iswithin <= 1;
        end
        // Then, check for the frame drawing condition
        else if (((pixel_x >= x - BED_FRAME_WIDTH) && (pixel_x < x) && 
                  (pixel_y >= y - BED_FRAME_HEIGHT / 2) && (pixel_y < y + BED_FRAME_HEIGHT / 2)) ||
                 ((pixel_x > x + BED_WIDTH - 1) && (pixel_x <= x + BED_WIDTH + BED_FRAME_WIDTH - 1) &&
                  (pixel_y >= y - BED_FRAME_HEIGHT / 2) && (pixel_y < y + BED_FRAME_HEIGHT / 2))) begin
            colour <= 16'b01000_001010_00010; // brown
            iswithin <= 1;
        end
        // No need for an additional else block since colour and iswithin are reset at the beginning.
    end
end


endmodule