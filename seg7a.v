module seg7a(
  input     [3:0]     in,
  output    [7:0]     out
);

	reg [7:0] temp;

  always @(*) begin
	 case (in)
      4'b0000: temp=8'b01000000;         //0
      4'b0001: temp=8'b01111001;         //1
		4'b0010: temp=8'b00100100;         //2
		4'b0011: temp=8'b00110000;         //3
	   4'b0100: temp=8'b00011001;         //4
		4'b0101: temp=8'b00010010;         //5
		4'b0110: temp=8'b00000010;         //6
		4'b0111: temp=8'b01111000;         //7
	  	4'b1000: temp=8'b00000000;         //8
	  	4'b1001: temp=8'b00010000;         //9
	  	4'b1010: temp=8'b00001000;         //A
	  	4'b1011: temp=8'b00000011;         //B
	  	4'b1100: temp=8'b01000110;         //C
	  	4'b1101: temp=8'b01000000;         //D
	  	4'b1110: temp=8'b00000110;         //E
	  	4'b1111: temp=8'b00001110;         //F
	 endcase
  end
  assign out = temp;

endmodule
