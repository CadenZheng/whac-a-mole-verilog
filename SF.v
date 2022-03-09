module SF(
	input [1:0] select,
	input [15:0] acc_in,
	input clk,
	input enclk,
	input reset,
	
	output [15:0] smooth_out
);

	reg [15:0] r0;
	reg [15:0] r1; 
	reg [15:0] r2;
	reg [15:0] r3;
	reg [15:0] r4; 
	reg [15:0] r5;
	reg [15:0] r6;
	reg [15:0] r7;
	reg [15:0] r8;
	reg [15:0] r9;
	reg [15:0] r10;
	reg [15:0] r11;
	reg [15:0] r12;
	reg [15:0] r13;
	reg [15:0] r14;
	reg [15:0] r15;
	reg [19:0] sum1;
	reg [19:0] sum2;
	reg [19:0] sum3;
	reg [19:0] st1;
	reg [19:0] st2;
	reg [19:0] st3;
	reg [15:0] temp;
	
	always @(posedge clk) begin
		if(reset) begin
			r0=0;
			r1=0; 
			r2=0;
			r3=0;
			r4=0; 
			r5=0;
			r6=0;
			r7=0;
			r8=0;
			r9=0;
			r10=0;
			r11=0;
			r12=0;
			r13=0;
			r14=0;
			r15=0;
			sum1=0;
			sum2=0;
			sum3=0;
			st1=0;
			st2=0;
			st3=0;
		end
		
		 else if(enclk) begin
		
			case(select) 
				2'b00: begin
					temp=acc_in;
				end
				2'b01:begin
					r0<=acc_in;
					r1<=r0;
					sum1 = r0+r1;
					st1 = sum1 >>1;
					temp= st1[15:0];
				end
				2'b10:begin
					r0<=acc_in;
					r1<=r0;
					r2<=r1;
					r3<=r2;
					sum2 = r0+r1+r2+r3;
					st2 = sum2 >>2;
					temp= st2[15:0];
				end	
				2'b11:begin
					r0<=acc_in;
					r1<=r0;
					r2<=r1;
					r3<=r2;
					r4<=r3;
					r5<=r4;
					r6<=r5;
					r7<=r6;
					r8<=r7;
					r9<=r8;
					r10<=r9;
					r11<=r10;
					r12<=r11;
					r13<=r12;
					r14<=r13;
					r15<=r14;
					sum3 = r0+r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15;
					st3 = sum3 >>4;
					temp= st3[15:0];
				end
			endcase
		end
	end
	assign smooth_out = temp;
	
endmodule 