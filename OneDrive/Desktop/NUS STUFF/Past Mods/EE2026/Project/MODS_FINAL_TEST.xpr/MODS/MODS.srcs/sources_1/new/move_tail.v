`timescale 1ns / 1ps

module move_tail(
    input CLK_6_25_MHz,
    input [6:0] x,
    input [5:0] y,
    input [15:0] colour,
    input flip,
    input ismoving,
    input [12:0] pixel_index,
    output reg iswithin,
    output reg [15:0] colourout
);
    wire [6:0] pixel_x;
    wire [5:0] pixel_y;
    reg [5:0] max_y_diff;


    pixeltocoords(pixel_index, pixel_x, pixel_y); 

    always @ (posedge CLK_6_25_MHz) begin
if (flip == 0) begin
        iswithin = 0;
        if (pixel_x <= x && pixel_x > x - 5) begin
            max_y_diff = x - pixel_x;
    
            if (pixel_y >= y + 3 - max_y_diff && pixel_y <= y + 3 + max_y_diff) begin
                colourout = colour;
                iswithin = 1;
            end else begin
                colourout = 0;
                iswithin = 0;
            end
        end else begin
            colourout = 0;
            iswithin = 0;
        end
    end else begin
        iswithin = 0;
        if (pixel_x >= x + 8 && pixel_x < x + 13) begin 
            max_y_diff = pixel_x - (x + 8);
    
            if (pixel_y >= y + 3 - max_y_diff && pixel_y <= y + 3 + max_y_diff) begin
                colourout = colour;
                iswithin = 1;
            end else begin
                colourout = 0;
                iswithin = 0;
            end
        end else begin
            colourout = 0;
            iswithin = 0;
        end
    end
end
endmodule