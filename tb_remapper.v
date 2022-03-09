module tb_remapper;
wire [15:0] tcmpl;
wire [9:0] board_posit;
reg [15:0] count;


assign tcmpl = count;

remapper UUT(.tcmpl(tcmpl),.board_posit(board_posit));

initial begin
count = 16'b0000_0000_0000_0000;
repeat (65536) begin
  #20
  $display("in = %b, out = %b",count,board_posit);
  count=count + 16'b0000_0000_0000_0001;
  end
  end
endmodule
