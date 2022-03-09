module tb_BCD_c;

    wire [9:0] in;
    wire nothing;
    wire [7:0] num2;
    wire [7:0] num1;
    wire [7:0] num0;
    reg clk = 0;
    reg [9:0] count;
    reg noth;
    always #1 clk=~clk;
    assign in=count;
    assign nothing = noth;
    BCD_c UUT(.in(in),.nothing(nothing),.clk(clk),.num2(num2),.num1(num1),.num0(num0));

    initial begin
     count = 10'b00_0000_0000;
     noth=0;
     repeat(1024) begin
      #50
      $display("in = %b, out = %b %b %b", count, num2, num1, num0);
      count = count + 10'b00_0000_0001;
    end
        end
  endmodule
