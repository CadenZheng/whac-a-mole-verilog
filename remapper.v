module remapper (
	input [15:0] tcmpl,
	output [9:0] board_posit
);

reg [15:0] unsgn;
reg [9:0] temp;

always @(*) begin
	if(tcmpl[15]==1'b1) begin
		unsgn = (~tcmpl+1'b1);
		if (unsgn >=16'b0000_0000_0101_0000) begin
			temp = 10'b00_0000_0001;
		end
		else if (unsgn >=16'b0000_0000_0011_1100) begin
			temp = 10'b00_0000_0010;
		end
		else if (unsgn >=16'b0000_0000_0010_1000) begin
			temp = 10'b00_0000_0100;
		end
		else if (unsgn >=16'b0000_0000_0001_0100) begin
			temp = 10'b00_0000_1000;
		end
		else if (unsgn >=16'b0000_0000_0000_0000) begin
			temp = 10'b00_0001_0000;
		end
	end
	else if(tcmpl[15]==1'b0) begin
		if (tcmpl >=16'b0000_0000_0101_0000) begin
			temp = 10'b10_0000_0000;
		end
		else if (tcmpl >=16'b0000_0000_0011_1100) begin
			temp = 10'b01_0000_0000;
		end
		else if (tcmpl >=16'b0000_0000_0010_1000) begin
			temp = 10'b00_1000_0000;
		end
		else if (tcmpl >=16'b0000_0000_0001_0100) begin
			temp = 10'b00_0100_0000;
		end
		else if (tcmpl >=16'b0000_0000_0000_0000) begin
			temp = 10'b00_0010_0000;
		end
	end
end

assign board_posit = temp;

endmodule
