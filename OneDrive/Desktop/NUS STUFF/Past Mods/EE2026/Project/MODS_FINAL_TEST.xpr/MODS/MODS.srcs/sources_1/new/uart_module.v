`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2024 00:34:47
// Design Name: 
// Module Name: uart_module
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

module uart_module #(
    parameter BAUD_RATE = 9600,
    parameter DATA_BITS = 8,
    parameter STOP_BITS = 1
)(
    input wire clk,
    input wire [DATA_BITS-1:0] tx_data,
    input wire tx_valid,
    output reg tx_ready,
    output reg [DATA_BITS-1:0] rx_data,
    output reg rx_valid,
    input wire uart_rx,
    output reg uart_tx
);

    // Clock frequency and baud rate parameters
    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_PERIOD = CLK_FREQ / BAUD_RATE;

    // Transmitter logic
    reg [DATA_BITS-1:0] tx_shift_reg;
    reg [$clog2(BAUD_PERIOD)-1:0] tx_baud_counter;
    reg tx_state;

    always @(posedge clk) begin
        case (tx_state)
            0: begin
                tx_ready <= 1;
                uart_tx <= 1; // Idle state
                if (tx_valid) begin
                    tx_shift_reg <= tx_data;
                    tx_baud_counter <= BAUD_PERIOD - 1;
                    tx_state <= 1;
                    uart_tx <= 0; // Start bit
                    tx_ready <= 0;
                end
            end
            1: begin
                if (tx_baud_counter == 0) begin
                    if (tx_shift_reg == 0) begin
                        tx_state <= 0;
                        uart_tx <= 1; // Stop bit
                        tx_ready <= 1;
                    end else begin
                        uart_tx <= tx_shift_reg[0]; // Transmit data bit
                        tx_shift_reg <= tx_shift_reg >> 1;
                        tx_baud_counter <= BAUD_PERIOD - 1;
                    end
                end else begin
                    tx_baud_counter <= tx_baud_counter - 1;
                end
            end
        endcase
    end
    
// Receiver logic
    reg [DATA_BITS-1:0] rx_shift_reg;
    reg [$clog2(BAUD_PERIOD)-1:0] rx_baud_counter;
    reg rx_state;
    reg [16:0] rx_valid_counter;
    
    always @(posedge clk) begin
        case (rx_state)
            0: begin
                if (!uart_rx && rx_baud_counter == 0) begin
                    rx_baud_counter <= BAUD_PERIOD - 1;
                    rx_state <= 1;
                end
            end
            1: begin
                if (rx_baud_counter == BAUD_PERIOD/2) begin // Sample at the middle of the baud period
                    rx_shift_reg <= {uart_rx, rx_shift_reg[DATA_BITS-1:1]};
                    if (rx_shift_reg[0] == 0) begin // Check for a valid stop bit
                        rx_data <= rx_shift_reg[DATA_BITS-1:1];
                        rx_valid <= 1;
                        rx_valid_counter <= 16'd65535;
                        rx_state <= 2;
                    end else begin
                        rx_baud_counter <= BAUD_PERIOD - 1;
                    end
                end else begin
                    rx_baud_counter <= rx_baud_counter - 1;
                end
            end
            2: begin
                if (rx_valid_counter == 0) begin
                    rx_valid <= 0;
                    rx_state <= 0;
                end else begin
                    rx_valid_counter <= rx_valid_counter - 1;
                end
            end
        endcase
    end

    // old Receiver logic
//    reg [DATA_BITS-1:0] rx_shift_reg;
//    reg [$clog2(BAUD_PERIOD)-1:0] rx_baud_counter;
//    reg rx_state;

//    always @(posedge clk) begin
//        case (rx_state)
//            0: begin
//                if (!uart_rx && rx_baud_counter == 0) begin
//                    rx_baud_counter <= BAUD_PERIOD - 1;
//                    rx_state <= 1;
//                end
//            end
//            1: begin
//                if (rx_baud_counter == 0) begin
//                    if (rx_shift_reg[0] == 0) begin
//                        rx_shift_reg <= {uart_rx, rx_shift_reg[DATA_BITS-1:1]};
//                        if (rx_shift_reg[DATA_BITS-1] == 1) begin
//                            rx_data <= rx_shift_reg[DATA_BITS-2:0];
//                            rx_valid <= 1;
//                            rx_state <= 0;
//                        end else begin
//                            rx_baud_counter <= BAUD_PERIOD - 1;
//                        end
//                    end else begin
//                        rx_state <= 0;
//                        rx_valid <= 0;
//                    end
//                end else begin
//                    rx_baud_counter <= rx_baud_counter - 1;
//                end
//            end
//        endcase
//    end
    
    
///////v2 transmit///////////

//always @(posedge clk) begin
//    case (tx_state)
//        0: begin
//            if (tx_valid) begin
//                tx_shift_reg <= tx_data;
//                tx_baud_counter <= BAUD_PERIOD - 1;
//                tx_state <= 1;
//                uart_tx <= 0; // Start bit
//                tx_ready <= 0;
//            end else begin
//                tx_ready <= 1;
//                uart_tx <= 1; // Idle state
//            end
//        end
//        1: begin
//            if (tx_baud_counter == 0) begin
//                if (tx_shift_reg == 0) begin
//                    tx_state <= 0;
//                    uart_tx <= 1; // Stop bit
//                    tx_ready <= 1;
//                end else begin
//                    uart_tx <= tx_shift_reg[0]; // Transmit data bit
//                    tx_shift_reg <= tx_shift_reg >> 1;
//                    tx_baud_counter <= BAUD_PERIOD - 1;
//                end
//            end else begin
//                tx_baud_counter <= tx_baud_counter - 1;
//            end
//        end
//    endcase
//end
    
    

endmodule




