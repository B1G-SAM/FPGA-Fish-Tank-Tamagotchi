`timescale 1ns / 1ps
module minigame (
    input CLK_6_25_MHz,
    input reset,
    input btnU, btnR, btnL, btnD,btnC,
    input [15:0] sw,
    input [12:0] pixel_index,
    input [6:0] fatigue,
    input [15:0] fishcolor,
    output reg [15:0] minigame_color,
    output reg minigame_within,
    output reg [6:0] score,
    output reg [6:0] high_score
);

    // Fish position and movement
    reg [6:0] fish_x;
    reg [5:0] fish_y;
    wire [15:0] fish_color;
    wire fish_within;
    reg flip = 0;

    // Parameters for fish movement
    parameter screen_width = 96;
    parameter screen_height = 64;
    parameter fish_speed = 1;
    reg [23:0] update_delay; 
    reg [23:0] delay_counter = 0;
    reg game_start = 0;
    reg game_over = 0;

    // Obstacle generation and movement
    reg [6:0] level = 0;
    reg [6:0] obstacle_x = screen_width;
    reg [5:0] obstacle_y = 0;
    reg [5:0] obstacle_height = 35;
    wire [15:0] obstacle_color;
    wire [15:0] obstacle_color_2;
    wire obstacle_within;
    wire obstacle_within_2;
    reg [31:0] obstacle_speed = 32'd500000;
    parameter initial_speed = 32'd500000;
    parameter speed_increment_1_5 = 32'd60000;
    parameter speed_increment_6_10 = 32'd20000;
    parameter speed_increment_11_15 = 32'd6000;
    parameter speed_increment_16_20 = 32'd2000;
    parameter speed_increment_21_100 = 32'd1500; 
    reg [31:0] obstacle_counter;
    reg [4:0] obstacle_no;
    reg start = 0;

    parameter NUM_OBSTACLES = 10;
    reg [5:0] obstacle_y_array [0:NUM_OBSTACLES-1];
    reg [5:0] obstacle_height_array [0:NUM_OBSTACLES-1];

    initial begin
    obstacle_height_array[0] = 20;
    obstacle_height_array[1] = 40;
    obstacle_height_array[2] = 5;
    obstacle_height_array[3] = 10;
    obstacle_height_array[4] = 42;
    obstacle_height_array[5] = 30;
    obstacle_height_array[6] = 12;
    obstacle_height_array[7] = 22;
    obstacle_height_array[8] = 44;
    obstacle_height_array[9] = 5;
    end

    always @(posedge CLK_6_25_MHz) begin
    
        // Update the update_delay value based on the fatigue level
        if (fatigue >= 0 && fatigue <= 10)
            update_delay <= 100000;
        else if (fatigue >= 11 && fatigue <= 20)
            update_delay <= 150000;
        else if (fatigue >= 21 && fatigue <= 40)
            update_delay <= 200000;
        else if (fatigue >= 41 && fatigue <= 70)
            update_delay <= 400000;
        else if (fatigue >= 71 && fatigue <= 100)
            update_delay <= 500000;
        
        //Game logic    
        if (!game_start) begin
            flip <= 0;
            score <= 0;
            fish_x <= 50;
            fish_y <= 30;
            obstacle_no <= 0;
            level <= 0;
            obstacle_x <= screen_width;
            obstacle_speed <= initial_speed;
            if (btnC) begin
                game_start <= 1;
                level <= 0;
                obstacle_no <= 0;
                obstacle_speed <= initial_speed;
            end
        end else if (~sw[2]) begin
            game_start <= 0;
        end
        else if (game_over) begin
            fish_x <= fish_x;
            fish_y <= fish_y;
            delay_counter <= 0;
            if (btnC) begin
                game_over <= 0;
                game_start <= 0;
                obstacle_x <= screen_width;
                obstacle_no <= 0;
                level <= 0;
                obstacle_speed <= initial_speed;
                score <= 0;
            end
        end else if (sw[2]) begin
            if (delay_counter < update_delay) begin
                delay_counter <= delay_counter + 1;
            end else begin
                delay_counter <= 0;
                // Update fish position based on button presses
                if (btnU && ~sw[1] && ~sw[0] && fish_y > 0)
                    fish_y <= fish_y - fish_speed;
                if (btnD && ~sw[1] && ~sw[0] && fish_y < screen_height - 7)
                    fish_y <= fish_y + fish_speed;
                if (btnL && ~sw[1] && ~sw[0] && fish_x > 0) begin
                    fish_x <= fish_x - fish_speed;
                    flip <= 1;
                end
                if (btnR && ~sw[1] && ~sw[0] && fish_x < screen_width - 12) begin
                    fish_x <= fish_x + fish_speed; 
                    flip <= 0;
                end
            end
            obstacle_counter <= obstacle_counter + 1;
            if (obstacle_counter >= obstacle_speed) begin
                obstacle_counter <= 0;
                obstacle_x <= (obstacle_x > 0) ? obstacle_x - 1 : screen_width;

                // Generate new obstacle position when it goes off the screen
                if (obstacle_x == 0) begin
                    obstacle_no <= (obstacle_no + 1) % NUM_OBSTACLES;
                    obstacle_height <= obstacle_height_array[obstacle_no];
                    score <= score + 1;
                    
                    if (obstacle_no >= 0) begin
                    level <= level + 1;
                        if (level >= 1 && level <= 5) begin
                            obstacle_speed <= initial_speed - ((level - 1) * speed_increment_1_5);
                        end else if (level >= 6 && level <= 10) begin
                            obstacle_speed <= initial_speed - (4 * speed_increment_1_5) - ((level - 6) * speed_increment_6_10);
                        end else if (level >= 11 && level <= 15) begin
                            obstacle_speed <= initial_speed - (4 * speed_increment_1_5) - (4 * speed_increment_6_10) - ((level - 11) * speed_increment_11_15);
                        end else if (level >= 16 && level <= 20) begin
                            obstacle_speed <= initial_speed - (4 * speed_increment_1_5) - (4 * speed_increment_6_10) - (4 * speed_increment_11_15) - ((level - 16) * speed_increment_16_20);
                        end else if (level >= 20 && level <= 100) begin
                            obstacle_speed <= initial_speed - (4 * speed_increment_1_5) - (4 * speed_increment_6_10) - (4 * speed_increment_11_15) - ((level - 16) * speed_increment_16_20) - ((level - 20) * speed_increment_21_100);
                        end
                    end
                end
            end
         if ((fish_x < obstacle_x + 8 && fish_x + 10 > obstacle_x &&
              fish_y <= obstacle_height && fish_y + 7 > 0)||
             (fish_x < obstacle_x + 8 && fish_x + 10 > obstacle_x &&
              fish_y <= screen_height && fish_y + 7 > obstacle_height + 16)) begin
            game_over <= 1;
            level <= 0;
            obstacle_speed <= initial_speed;
            obstacle_no <= 0;
            if (score > high_score) begin
                high_score <= score;
            end
        end
    end
        
        
    end

    Fish fish_instance (
        .pixel_index(pixel_index),
        .CLK_6_25_MHz(CLK_6_25_MHz),
        .enable(1),
        .reset(reset),
        .x(fish_x),
        .y(fish_y),
        .primary_colour(fishcolor),
        .secondary_colour(16'b00000_111111_00000),
        .flip(flip),
        .colour(fish_color),
        .iswithin(fish_within)
    );

    // Obstacle rectangle
    rectangle obstacle (
        .x(obstacle_x),
        .y(0),
        .width(8),
        .height(obstacle_height),
        .colour(level < 6 ? 16'b11111_000000_00000 :
                level < 11 ? 16'b00000_111111_11111 :
                level < 16 ? 16'b11111_111111_00000 : 
                level < 100? 16'b11111_000000_11111 : 16'b00000_000000_00000), 
        .clock(CLK_6_25_MHz),
        .pixel_index(pixel_index),
        .pixel_data(obstacle_color),
        .is_within(obstacle_within)
    );
    
    // Obstacle rectangle 2
    rectangle obstacle_2 (
        .x(obstacle_x),
        .y(obstacle_height + 16), //Gap of 25
        .width(8),
        .height(screen_height - (obstacle_height + 17)),
        .colour(level < 6 ? 16'b11111_000000_00000 :
                level < 11 ? 16'b00000_111111_11111 :
                level < 16 ? 16'b11111_111111_00000 : 
                level < 100? 16'b11111_000000_11111 : 16'b00000_000000_00000),
        .clock(CLK_6_25_MHz),
        .pixel_index(pixel_index),
        .pixel_data(obstacle_color_2),
        .is_within(obstacle_within_2)
    );
    
    // Display minigame
    always @(*) begin
        if (fish_within) begin
            minigame_color = fish_color;
            minigame_within = 1;
        end else if (obstacle_within) begin
            minigame_color = obstacle_color;
            minigame_within = 1;
        end else if (obstacle_within_2) begin
            minigame_color = obstacle_color_2;
            minigame_within = 1;
        end else begin
            minigame_color = 16'b00000_000000_00000; // Background color
            minigame_within = 0;
        end 
    end
    
endmodule