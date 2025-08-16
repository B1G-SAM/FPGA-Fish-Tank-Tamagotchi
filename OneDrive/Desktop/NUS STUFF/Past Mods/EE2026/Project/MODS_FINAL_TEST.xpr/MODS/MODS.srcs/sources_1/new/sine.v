`timescale 1ns / 1ps
module sine(
    input wire [4:0] index, // accepts values from 0 to 19
    output reg [15:0] sine_out // Scaled sine value output, ranges from 0 to 10
);
    
    always @(*) begin
        case(index)
            5'd0: sine_out = 5;       // sin(0)
            5'd1: sine_out = 6;       
            5'd2: sine_out = 7;       
            5'd3: sine_out = 8;       
            5'd4: sine_out = 9;       
            5'd5: sine_out = 10;      // sin(90 degrees) Max amplitude
            5'd6: sine_out = 9;       
            5'd7: sine_out = 8;       
            5'd8: sine_out = 7;       
            5'd9: sine_out = 6;       
            5'd10: sine_out = 5;      // sin(180 degrees)
            5'd11: sine_out = 4;     
            5'd12: sine_out = 3;     
            5'd13: sine_out = 2;     
            5'd14: sine_out = 1;     
            5'd15: sine_out = 0;      // sin(270 degrees) Min amplitude
            5'd16: sine_out = 1;     
            5'd17: sine_out = 2;     
            5'd18: sine_out = 3;     
            5'd19: sine_out = 4;     
            default: sine_out = 5;    // Default case, or sin(360 degrees)
        endcase
    end
endmodule
