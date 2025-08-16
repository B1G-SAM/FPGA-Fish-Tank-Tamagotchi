`timescale 1ns / 1ps
module move_Food(
    input CLK_6_25_MHz,
    input food_purchased,
    input [6:0] start_x,
    input btnL,
    input btnR,
    input btnC,
    input within_fish,
    input within_food,
    input [15:0] sw,
    output reg [6:0] x_pos_reg,
    output reg [5:0] y_pos_reg,
    output reg is_eaten,
    output reg food_visible,
    output reg food_released = 0
);

parameter screen_height = 64;
parameter constant_speed = 1;
parameter update_delay = 1000000;

reg [23:0] delay_counter = 0;

always @(posedge CLK_6_25_MHz) begin
    if (btnC && food_purchased && !food_visible && sw[0] == 1 && sw[1] == 0 && sw[2] == 0) begin
        food_released <= 1;
        x_pos_reg <= start_x;
        y_pos_reg <= 0;
        delay_counter <= 0;
        is_eaten <= 0;
        food_visible <= 1;
    end
    
    if (food_released) begin
        if (within_food && within_fish) begin
            is_eaten <= 1;
            food_visible = 0;
            food_released = 0; // Ensure we reset this to allow for new pellets to be released.
            // Reset position to avoid unintended interactions after being eaten.
            x_pos_reg <= 0;
            y_pos_reg <= 0;
        end else if (delay_counter < update_delay) begin
            delay_counter <= delay_counter + 1;
        end else begin
            delay_counter <= 0;
            if (y_pos_reg < screen_height - 1) begin
                y_pos_reg <= y_pos_reg + constant_speed;
            end else begin
                // If the pellet reaches the bottom without being eaten, make it disappear
                food_visible <= 0;
                food_released <= 0; // Reset to allow a new pellet to be released.
                x_pos_reg <= start_x; // Reset x position for next pellet.
                y_pos_reg <= 0; // Reset y position for next pellet.
            end

            if (btnL && x_pos_reg > 0) begin
                x_pos_reg <= x_pos_reg - 1;
            end
            if (btnR && x_pos_reg < 127) begin // Assuming 128 is the width of the screen
                x_pos_reg <= x_pos_reg + 1;
            end
        end
    end else if (!food_visible && !food_released && is_eaten) begin
        // Reset state after food has been eaten and is no longer visible.
        is_eaten <= 0; // This line ensures that 'is_eaten' is reset, allowing the cycle to begin anew.
    end
end

endmodule

