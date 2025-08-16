`timescale 1ns / 1ps


module rectangle(
    input [6:0] x,                       //x coordinate of top left of rect
    input [5:0] y,                       //y coordinate of top left of rect
    input [6:0] width,
    input [5:0] height,
    input [15:0] colour,
    input clock,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    output reg is_within                //boolean that is 1 when pixel_index is within the rectangle region and 0 when the pixel index has exited the rectangle region
    );
    wire [6:0] pixel_index_x;
    wire [5:0] pixel_index_y;
    wire [6:0] end_x = (x + width >= 96) ? 0 : (x + width - 1);
    wire [5:0] end_y = (y + height >= 64) ? 0 : (y + height - 1);
     
    pixeltocoords start(pixel_index, pixel_index_x, pixel_index_y);
    
    always @ (posedge clock) begin
        if (pixel_index_x >= x && pixel_index_x <= end_x && pixel_index_y >= y && pixel_index_y <= end_y) begin
            pixel_data = colour;
            is_within = 1;
        end else begin
            pixel_data = 0;
            is_within = 0;
        end
    end
endmodule
