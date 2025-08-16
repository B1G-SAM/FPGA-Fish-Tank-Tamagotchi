`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 11:13:27
// Design Name: 
// Module Name: seven_seg_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_control(
    input CLOCK,
    input [7:0] number, // Input register containing the number to display (0-99)
    output reg [6:0] seg1, // Output for the first seven-segment display
    output reg [6:0] seg2 // Output for the second seven-segment display
    );
    
    reg [6:0] digit1, digit2; // Individual digits to be displayed
    
    // Divide the input number into two digits
    always @ (posedge CLOCK) begin
        digit1 = number % 10;
        digit2 = number / 10;
    end
    
    // Seven-segment decoder for digit 1
    always @ (digit1)
        case(digit1)
            4'd0: seg1 = 7'b1000000; // Display 0
            4'd1: seg1 = 7'b1111001; // Display 1
            4'd2: seg1 = 7'b0100100; // Display 2
            4'd3: seg1 = 7'b0110000; // Display 3
            4'd4: seg1 = 7'b0011001; // Display 4
            4'd5: seg1 = 7'b0010010; // Display 5
            4'd6: seg1 = 7'b0000010; // Display 6
            4'd7: seg1 = 7'b1111000; // Display 7
            4'd8: seg1 = 7'b0000000; // Display 8
            4'd9: seg1 = 7'b0010000; // Display 9
            default: seg1 = 7'b1111111; // Turn off all segments if invalid input
        endcase
    
    // Seven-segment decoder for digit 2
    always @ (digit2)
        case(digit2)
            4'd0: seg2 = 7'b1000000; // Display 0
            4'd1: seg2 = 7'b1111001; // Display 1
            4'd2: seg2 = 7'b0100100; // Display 2
            4'd3: seg2 = 7'b0110000; // Display 3
            4'd4: seg2 = 7'b0011001; // Display 4
            4'd5: seg2 = 7'b0010010; // Display 5
            4'd6: seg2 = 7'b0000010; // Display 6
            4'd7: seg2 = 7'b1111000; // Display 7
            4'd8: seg2 = 7'b0000000; // Display 8
            4'd9: seg2 = 7'b0010000; // Display 9
            default: seg2 = 7'b1111111; // Turn off all segments if invalid input
        endcase
endmodule
