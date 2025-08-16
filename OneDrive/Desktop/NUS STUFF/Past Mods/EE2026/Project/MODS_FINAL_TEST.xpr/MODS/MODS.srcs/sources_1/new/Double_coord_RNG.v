`timescale 1ns / 1ps

module Double_coord_RNG(
    input clk, // Assume a 50 MHz clock input
    output reg [6:0] x1_coord,
    output reg [5:0] y1_coord,
    output reg [6:0] x2_coord,
    output reg [5:0] y2_coord
);

// Parameters for the 20-second interval and LFSR
parameter INTERVAL = 100_000_000 * 4; // 20 seconds at 50 MHz clock
reg [31:0] counter = 0;
reg [31:0] lfsr = 32'hBADA55; // Initial seed for LFSR, using a 32-bit LFSR for more values
wire feedback = lfsr[0] ^ lfsr[1] ^ lfsr[21] ^ lfsr[31]; // Example feedback function

always @(posedge clk) begin
    if (counter < INTERVAL) begin
        counter <= counter + 1;
    end else begin
        counter <= 0;
        // Update the LFSR value every 20 seconds
        lfsr <= {lfsr[30:0], feedback};
        

        x1_coord <= (lfsr[7:0] % 80) + 1;  
        x2_coord <= (lfsr[23:16] % 80) + 1; 
        y1_coord <= (lfsr[15:8] % 55) + 1;  
        y2_coord <= (lfsr[31:24] % 55) + 1;  
    end
end

endmodule

