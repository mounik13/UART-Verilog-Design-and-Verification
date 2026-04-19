`timescale 1ns/1ps

module uart_tb;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire baud_tick;

// Baud generator
baud_gen bg (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

// UART TX
uart_tx uut (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .baud_tick(baud_tick),
    .tx(tx),
    .tx_busy()
);

// Clock (10ns period ? 100 MHz)
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'b10101010;

    #20 reset = 0;

    #20 tx_start = 1;
    #200 tx_start = 0;

    #1000000; // 1 ms simulation

    $finish;
end
