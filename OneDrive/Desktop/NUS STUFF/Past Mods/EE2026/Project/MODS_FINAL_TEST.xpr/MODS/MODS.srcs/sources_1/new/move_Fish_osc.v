`timescale 1ns / 1ps


module move_Fish_osc(
    input [12:0] pixel_index,
    input [31:0] CLK_6_25_MHz,
    input enable,
    input reset,
    input [6:0] x,
    input [5:0] y,
    input [6:0] x_target,
    input [5:0] y_target,
    input [6:0] mouse_x,
    input [5:0] mouse_y,
    input [15:0] primarycolour,
    input [15:0] secondarycolour,
    input [6:0] x_collision,
    input [5:0] y_collision,
    input onclick, // Input to trigger the fish movement towards mouse coordinates
    output reg [15:0] colour,
    output reg iswithin,
    output reg [6:0] fish_x,
    output reg [5:0] fish_y,
    output reg flipreg 
);
    reg [31:0] counter = 0;
    reg [6:0] x_reg;
    reg [5:0] y_reg;
    reg [6:0] real_targetx;
    reg [5:0] real_targety;
    wire [15:0] fishcolour;
    wire iswithin_wire;
    reg target_set = 0; // Indicates if a new target has been set

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
        fish_x = x_reg;
        fish_y = y_reg;
        if (reset) begin
            x_reg <= x;
            y_reg <= y;
            flipreg <= 0;
            counter <= 0;
            target_set <= 0; // Reset target on reset
        end
        else if (enable) begin
            if (onclick) begin
                real_targetx = mouse_x;
                real_targety = mouse_y;
                target_set <= 1; // Prevent continuous resetting of the target
            end else begin
                target_set = 0;
                real_targetx = x_target;
                real_targety = y_target;
            end

            // Collision logic (unchanged)
            if (x_collision - 1 < x_reg && x_collision != 0) begin
                x_reg = x_reg - 1;
            end
            if (y_collision - 1 > y_reg && y_collision != 0) begin
                y_reg = y_reg - 1;
            end
            
            counter <= counter + 1;
            if (counter >= 625000) begin // Timing adjustment placeholder
                counter <= 0;
                if (x_reg < real_targetx) begin
                        flipreg <= 0; // Moving right
                    end else if (x_reg > real_targetx) begin
                        flipreg <= 1; // Moving left
                    end
                    
                // Direct movement towards the mouse click point without oscillation
                if (target_set) begin
                    
                    // Movement logic
                    if (x_reg != real_targetx || y_reg != real_targety) begin
                        x_reg <= (x_reg < real_targetx) ? x_reg + 1 : (x_reg > real_targetx) ? x_reg - 1 : x_reg;
                        y_reg <= (y_reg < real_targety) ? y_reg + 1 : (y_reg > real_targety) ? y_reg - 1 : y_reg;
                    end
                end else begin
                    // Oscillation movement logic
                    if (x_reg != real_targetx || y_reg != real_targety) begin
                        x_reg <= (x_reg < real_targetx) ? x_reg + 1 : (x_reg > real_targetx) ? x_reg - 1 : x_reg;
                        y_reg <= (y_reg < real_targety) ? y_reg + 1 : (y_reg > real_targety) ? y_reg - 1 : y_reg;
                    end
                end
            end
        end
    end

    always @* begin
        if (iswithin_wire) begin
            colour = fishcolour;
            iswithin = 1;
        end else begin
            colour = 16'b0; // Default/background colour
            iswithin = 0;
        end
    end
endmodule





