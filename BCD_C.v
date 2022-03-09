module BCD_c (
	input	[9:0] in,
	input	nothing,
	input clk,
	
	//output [7:0] num3, //sign bit
	output [7:0] num2, //Hundreds
	output [7:0] num1, //Tens
	output [7:0] num0  //Ones
);

	reg [10:0] in_ext;
	reg [4:0] i =0;
	reg [22:0] shift_register =0;
	reg [3:0] hundreds =0;
	reg [3:0] tens =0;
	reg [3:0] ones =0;
	reg [10:0] old_in_ext =0;
	reg [7:0] tnum2;
	reg [7:0] tnum1;
	reg [7:0] tnum0;
	
	wire [7:0] ttnum2;
	wire [7:0] ttnum1;
	wire [7:0] ttnum0;
	
	seg7a hun(.in(hundreds),.out(ttnum2));
	seg7 t(.in(tens),.out(ttnum1));
	seg7 o(.in(ones),.out(ttnum0));
	
	
	// The idea for binary to BCD 
	//below is from 
	//youtube channel:
	//Simply Embeded
	//link:https:
	//www.youtube.com/watch?v=2JJxeKe5e5o
	always @(posedge clk) begin
		if (nothing==0) begin
		
			if (i==0 & (old_in_ext != in_ext)) begin
				shift_register = 23'd0;
				old_in_ext = in_ext;
				shift_register[10:0] = in_ext;
				hundreds = shift_register[22:19];
				tens = shift_register[18:15];
				ones = shift_register[14:11];
				i=i+1;
			end
			
			if (i>0 & i<12) begin
				if (hundreds >= 5) begin
					hundreds = hundreds+3;
				end
				if (tens >= 5) begin
					tens = tens+3;
				end
				if (ones >= 5) begin
					ones = ones+3;
				end
				
				shift_register [22:11] = {hundreds,tens,ones};
				shift_register = shift_register << 1;
				hundreds = shift_register[22:19];
				tens = shift_register[18:15];
				ones = shift_register[14:11];
				i=i+1;
			end
			
			if (i==12) begin
				i=0;
			end
		end
	end 
	
	always @(*) begin
		tnum2=ttnum2;
		tnum1=ttnum1;
		tnum0=ttnum0;
		if	(nothing) begin 
			tnum2= 8'b00111111;
			tnum1= 8'b10111111;
			tnum0= 8'b10111111;	
		end
		else if(in>10'b1111100111) begin
			tnum2= 8'b00010000;
			tnum1= 8'b10010000;
			tnum0= 8'b10010000;
		end
		else begin
			in_ext = {in[9],in};
		end

	end
	
	assign num2 = tnum2;
	assign num1 = tnum1;
	assign num0 = tnum0;
	
	
endmodule 		