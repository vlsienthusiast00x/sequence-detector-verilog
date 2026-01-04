`timescale 1ns/1ps

module tb_sequence_detector;

  reg clk;
  reg rst;
  reg inp_stream;
  wire out_stream;

  sequence_detector uut (
    .clk(clk),
    .rst(rst),
    .inp_stream(inp_stream),
    .out_stream(out_stream)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    inp_stream = 0;
    @(posedge clk);
    rst = 0;

    // Input bitstream. Change this as per your needs
    inp_stream = 1; @(posedge clk);
    inp_stream = 1; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 1; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 1; @(posedge clk);
    inp_stream = 1; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 0; @(posedge clk);
    inp_stream = 1; @(posedge clk);

    #20 $finish;
  end

  initial begin
    $monitor("Time=%0t | rst=%b | inp_stream=%b | matcher=%b | out_stream=%b",
              $time, rst, inp_stream, uut.matcher, out_stream);
  end

endmodule
