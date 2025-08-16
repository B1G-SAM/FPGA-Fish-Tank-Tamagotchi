`timescale 1ns / 1ps


module Food(
    input [12:0] pixel_index,
    input CLK_6_25_MHz,
    input enable,
    input reset,
    input [6:0] x, // X coordinate of the top-left corner of the food
    input [5:0] y, // Y coordinate of the top-left corner of the food
    output reg [15:0] colour = 0,
    output reg iswithin
);
    // Food pellet dimensions
    parameter food_width = 3; // Width of the food pellet in pixels
    parameter food_height = 3; // Height of the food pellet in pixels
    parameter [15:0] brown = 16'b10101_000000_00110;
    wire [6:0] pixel_x;
    wire [5:0] pixel_y;
    pixeltocoords(pixel_index, pixel_x, pixel_y);
    always @(posedge CLK_6_25_MHz) begin
        if (reset) begin
            colour <= 0;
            iswithin <= 0;
        end else if (enable) begin
            if (pixel_x >= x && pixel_x < x + food_width &&
                pixel_y >= y && pixel_y < y + food_height) begin
                colour <= brown;
                iswithin <= 1;
            end else begin
                colour <= 0; 
                iswithin <= 0;
            end
        end else begin
            colour <= 0;
            iswithin <= 0;
        end 
    end

endmodule