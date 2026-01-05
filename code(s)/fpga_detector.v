`timescale 1ns/1ps

module sequence_detector #(
    parameter SEQ_WIDTH = 4,
    parameter [SEQ_WIDTH-1:0] MATCH_SEQ = 4'b1001, 
    parameter overlapping = 0,
    parameter DIVISOR = 1_000_000   // divide 1 MHz down to 1 Hz
)(
    input  wire clk,       // 1 MHz input clock
    input  wire rst,
    input  wire inp_stream,
    output wire out_stream
);

    // Divider registers
    reg [$clog2(DIVISOR)-1:0] counter = 0;
    reg slow_clk = 0;

    // Generate slow clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter  <= 0;
            slow_clk <= 0;
        end else begin
            if (counter == DIVISOR-1) begin
                counter  <= 0;
                slow_clk <= ~slow_clk; // toggle every DIVISOR cycles
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Sequence matcher
    reg [SEQ_WIDTH-1:0] matcher;

    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            matcher <= {SEQ_WIDTH{1'b0}};
        end else if (overlapping) begin
            matcher <= {matcher[SEQ_WIDTH-2:0], inp_stream};
        end else begin
            if (matcher == MATCH_SEQ) begin
                matcher <= {SEQ_WIDTH{1'b0}};
            end else begin
                matcher <= {matcher[SEQ_WIDTH-2:0], inp_stream};
            end
        end
    end

    assign out_stream = (matcher == MATCH_SEQ);

endmodule
