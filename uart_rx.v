module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    input baud_tick,
    output reg tx,
    output reg tx_busy
);

reg [3:0] bit_index;
reg [9:0] shift_reg;
reg [1:0] state;

parameter IDLE = 0,
          SEND = 1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1;
        tx_busy <= 0;
        state <= IDLE;
        bit_index <= 0;
        shift_reg <= 0;
    end 
    else if (baud_tick) begin
        case (state)

            IDLE: begin
                tx <= 1;
                tx_busy <= 0;
                if (tx_start) begin
                    shift_reg <= {1'b1, tx_data, 1'b0}; // stop + data + start
                    bit_index <= 0;
                    tx_busy <= 1;
                    state <= SEND;
                end
            end

            SEND: begin
                tx <= shift_reg[0];          // send LSB first
                shift_reg <= shift_reg >> 1; // shift right

                if (bit_index < 9)
                    bit_index <= bit_index + 1;
                else
                    state <= IDLE;
            end

        endcase
    end
end

endmodule
