`timescale 1ns / 1ps


module pixeltocoords(
    input [12:0]pixel,
    output reg [6:0] x,
    output reg [5:0] y
    );
    
    always @ (pixel) begin
    x = pixel % 96;
    y = pixel / 96;
    end
endmodule