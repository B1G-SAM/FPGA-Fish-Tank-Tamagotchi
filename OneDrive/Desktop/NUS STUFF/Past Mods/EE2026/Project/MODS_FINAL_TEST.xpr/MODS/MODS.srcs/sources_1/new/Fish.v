`timescale 1ns / 1ps


module Fish(
    input [12:0] pixel_index,
    input CLK_6_25_MHz,
    input enable,
    input reset,
    input [6:0] x,
    input [5:0] y,
    input [15:0] primary_colour,
    input [15:0] secondary_colour,
    input flip,
    output reg [15:0] colour,
    output reg iswithin
    );

    
    wire [6:0] pixel_index_x;
    wire [5:0] pixel_index_y;
    wire [15:0] rec_colour;
    wire [15:0] tail_colour;
    wire iswithin_tail;
    wire iswithin_rec;
    
    
    pixeltocoords coords(pixel_index, pixel_index_x, pixel_index_y);
    rectangle(x , y, 8, 6, primary_colour, CLK_6_25_MHz, pixel_index, rec_colour, iswithin_rec);
    move_tail(CLK_6_25_MHz, x , y, secondary_colour, flip, 1, pixel_index, iswithin_tail, tail_colour);
    
    always @ (posedge CLK_6_25_MHz) begin
        if (iswithin_rec) begin
            colour = rec_colour;
            iswithin = 1;
        end else if (iswithin_tail) begin
            colour = tail_colour;
            iswithin = 1;
        end else begin
            colour = 0;
            iswithin = 0;
        end
    end
endmodule