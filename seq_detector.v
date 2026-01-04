module sequence_detector #(
    parameter SEQ_WIDTH = 4,
    parameter [SEQ_WIDTH-1:0] MATCH_SEQ = 4'b1001, 
    parameter overlapping = 0
)(
    input  wire clk,
    input  wire rst,
    input  wire inp_stream,
    output wire out_stream
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
