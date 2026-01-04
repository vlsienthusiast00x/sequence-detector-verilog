module sequence_detector #(
    parameter SEQ_WIDTH = 4,                        // width of the sequence to be matched
    parameter [SEQ_WIDTH-1:0] MATCH_SEQ = 4'b1001,  // Change this according to the required sequence to be matched
    parameter overlapping = 1                       // Toggle this for 1 for overlapping detection and 0 for non-overlapping detection
)(
    input  wire clk,
    input  wire rst,
    input  wire inp_stream,                         // Input bitstream
    output wire out_stream                          // Output bitstream
);

reg [SEQ_WIDTH-1:0] matcher;

always @(posedge clk or posedge rst) begin
   if (rst) begin
      matcher <= {SEQ_WIDTH{1'b0}};
   end
   else if (overlapping) begin
      matcher <= {matcher[SEQ_WIDTH-2:0], inp_stream};
   end
   else begin
      if (matcher == MATCH_SEQ) begin
         matcher <= {SEQ_WIDTH{1'b0}};
      end
      else begin
         matcher <= {matcher[SEQ_WIDTH-2:0], inp_stream};
      end
   end
end

assign out_stream = (matcher == MATCH_SEQ);

endmodule
