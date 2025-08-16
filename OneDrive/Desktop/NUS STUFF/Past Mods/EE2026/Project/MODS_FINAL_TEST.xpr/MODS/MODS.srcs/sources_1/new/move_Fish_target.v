`timescale 1ns / 1ps


module move_Fish_target(
    input [12:0] pixel_index,
    input [31:0] CLK_6_25_MHz,
    input enable,
    input reset,
    input [6:0] x,
    input [5:0] y,
    input [6:0] x_target,
    input [5:0] y_target,
    input [15:0] primarycolour,
    input [15:0] secondarycolour,
    input [6:0] x_collision,
    input [5:0] y_collision,
    output reg [15:0] colour,
    output reg iswithin,
    output reg [6:0] fish_x,
    output reg [5:0] fish_y
    );
    reg [31:0] counter = 0;
    reg [6:0] x_reg;
    reg [5:0] y_reg;
    reg flipreg; // Direction based on initial target direction
    wire [15:0] fishcolour;
    wire iswithin_wire;
    reg isMoving = 1; // 1 when moving towards target, 0 when stopped at target

    Fish fish_instance (
        .pixel_index(pixel_index),
        .CLK_6_25_MHz(CLK_6_25_MHz),
        .enable(enable),
        .reset(reset),
        .x(x_reg),
        .y(y_reg),
        .primary_colour(primarycolour),
        .secondary_colour(secondarycolour),
        .flip(flipreg),
        .colour(fishcolour),
        .iswithin(iswithin_wire)
    );

    always @(posedge CLK_6_25_MHz) begin
        if (reset) begin
            x_reg <= x;
            y_reg <= y;
            flipreg <= (x_target < x); // Flip based on initial direction towards target
            counter <= 0;
            isMoving <= 1;
        end else if (enable && isMoving) begin
            counter <= counter + 1;
            if (counter >= 62500) begin // Adjust timing based on your clock rate and desired speed
                counter <= 0;
                // Continue moving towards target
                if (x_reg != x_target || y_reg != y_target) begin
                    x_reg <= (x_reg < x_target) ? x_reg + 1 : (x_reg > x_target) ? x_reg - 1 : x_reg;
                    y_reg <= (y_reg < y_target) ? y_reg + 1 : (y_reg > y_target) ? y_reg - 1 : y_reg;
                end else begin
                    isMoving <= 0; // Stop movement once target is reached
                end
            end
        end
    end

    always @* begin
        if (iswithin_wire) begin
            colour = fishcolour;
        end else begin
            colour = 16'b0; // Default/background colour
        end
    end
endmodule