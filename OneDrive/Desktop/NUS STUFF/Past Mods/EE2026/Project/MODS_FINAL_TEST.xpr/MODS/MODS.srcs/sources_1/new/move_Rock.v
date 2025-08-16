`timescale 1ns / 1ps


module move_Rock(
    input CLK_6_25_MHz,
    input rock_purchased,
    input within_fish,
    input within_rock,
    input [6:0] fishx,
    input [5:0] fishy,
    output reg within_both,
    output reg [6:0] new_fishx,
    output reg [5:0] new_fishy
    );



    always @ (posedge CLK_6_25_MHz) begin
    if (rock_purchased) begin
            if (within_fish && within_rock) begin
                new_fishx = new_fishx - 1; //assume rock always on right of screen
                new_fishy = new_fishy - 1;
                within_both = 1;
            end else begin
                new_fishx = 0;
                new_fishy = 0;
                within_both = 0;
            end
        end
    end
endmodule