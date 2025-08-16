`timescale 1ns / 1ps

module Rock(
    input CLK,
    input enable, // Enable signal to control when the rock is displayed
    input [6:0] x, // Top left x-coordinate of the rock
    input [5:0] y, // Top left y-coordinate of the rock
    input [12:0] pixel_index, // Current pixel being drawn
    output reg [15:0] colour, // Output color of the pixel
    output reg is_within // Flag to indicate if the current pixel is within the rock
);

    // Parameters for the rock's dimensions and color
    parameter ROCK_WIDTH = 20;
    parameter ROCK_HEIGHT = 12;
    parameter ROCK_COLOUR = 16'h7BEF; // A gray-ish color for the rock

    // Screen dimensions (assuming a specific resolution, adjust as necessary)
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;

    // Derived pixel coordinates from the pixel_index
    wire [6:0] pixel_x = pixel_index % SCREEN_WIDTH;
    wire [5:0] pixel_y = pixel_index / SCREEN_WIDTH;

    always @(posedge CLK) begin
        if (enable && (pixel_x >= x) && (pixel_x < x + ROCK_WIDTH) &&
            (pixel_y >= y) && (pixel_y < y + ROCK_HEIGHT)) begin
            colour <= ROCK_COLOUR; // Set the color to the rock color
            is_within <= 1; // Indicate the pixel is within the rock
        end else begin
            colour <= 0; // Default color (e.g., black or transparent)
            is_within <= 0; // Not within the rock
        end
    end

endmodule
