
//=======================================================
// Puchen Zheng
// University of California, Davis
//pzheng@ucdavis.edu
//=======================================================

module whac-a-more(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		 reg    [7:0]		HEX4,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		 reg    [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
	reg [19:0] c50Hz = 0;
	reg out_50Hz = 0;
	reg wt30 = 0;
	reg wt02 = 0;
	reg endwt30;
	reg endwt02;
	reg [7:0] count_30;
	reg [3:0] count_02;
	reg [9:0] pos = 10'b10_0000_0000;
	reg [9:0] mpos;
	reg [9:0] timecount = 10'b00_0000_0000;
	reg sttime;
	reg [9:0] display;
	reg nothing;
	reg [4:0] count_c;
	reg [4:0] count;
	reg [9:0] mem1;
	reg [9:0] mem2;
	reg [9:0] mem3;
	reg [9:0] mem4;
//===== Declarations
   localparam SPI_CLK_FREQ  = 200;  // SPI Clock (Hz)
   localparam UPDATE_FREQ   = 1;    // Sampling frequency (Hz)

   // clks and reset
   wire reset_n;
   wire clk, spi_clk, spi_clk_out;

   // output data
   wire data_update;
   wire [15:0] data_x, data_y;
	wire [15:0] so;
	wire [9:0] hammer;

//===== Phase-locked Loop (PLL) instantiation. Code was copied from a module
//      produced by Quartus' IP Catalog tool.
pll pll_inst (
   .inclk0 ( MAX10_CLK1_50 ),
   .c0 ( clk ),                 // 25 MHz, phase   0 degrees
   .c1 ( spi_clk ),             //  2 MHz, phase   0 degrees
   .c2 ( spi_clk_out )          //  2 MHz, phase 270 degrees
   );

//===== Instantiation of the spi_control module which provides the logic to 
//      interface to the accelerometer.
spi_control #(     // parameters
      .SPI_CLK_FREQ   (SPI_CLK_FREQ),
      .UPDATE_FREQ    (UPDATE_FREQ))
   spi_ctrl (      // port connections
      .reset_n    (reset_n),
      .clk        (clk),
      .spi_clk    (spi_clk),
      .spi_clk_out(spi_clk_out),
      .data_update(data_update),
      .data_x     (data_x),
      .data_y     (data_y),
      .SPI_SDI    (GSENSOR_SDI),
      .SPI_SDO    (GSENSOR_SDO),
      .SPI_CSN    (GSENSOR_CS_N),
      .SPI_CLK    (GSENSOR_SCLK),
      .interrupt  (GSENSOR_INT)
   );

	
//50 Hz clock generator from lab6
always @(posedge clk) begin
	if (KEY[0]==0) begin
		c50Hz <=0;
		out_50Hz <=0;
	end
	else begin
		out_50Hz <= 0;
		if (c50Hz<499999) begin
			c50Hz <= c50Hz+1;
		end
		else begin
			c50Hz <= 0;
			out_50Hz <= 1;
		end
	end
end
	
//3s wait
/* 
always @(posedge out_50Hz) begin
	if (KEY[0]==1) begin
		if (wt30) begin
			endwt30 <=0;
			count_30 <= 8'b0000_0000;
			if (count_30<150) begin 
				count_30<=count_30 + 1;
			end
			else begin
				count_30 <= 8'b0000_0000;
				endwt30 <=1;
			end
		end
	end
	else if (KEY[0]==0) begin
		endwt30 <= 0;
		count_30 <= 8'b0000_0000;
	end
end	
*/
//30wait

always @(posedge out_50Hz) begin
	if(wt30) begin
		endwt30 <=0;
		count_30 <= 8'b0000_0000;
		if (count_30<150) begin 
			count_30<=count_30 + 1;
		end
		else begin
			endwt30 <=1;
		end
	end
	else begin
		endwt30 <= 0;
		count_30 <= 8'b0000_0000;
	end
end
	
//0.2s wait	
/*
always @(posedge out_50Hz) begin
	if (KEY[0]==0) begin
		endwt02 <= 0;
		count_02 <= 4'b0000;
	end
	else if (wt02) begin
		endwt02 <=0;
		if (count_02<10) begin 
			count_02<=count_02 + 1;
		end
		else begin
			endwt02 <=1;
		end
	end
end		
*/
//new 0,2 wait

always @(posedge out_50Hz) begin
	if(wt02) begin
		endwt02 <=0;
		count_02 <= 4'b0000;
		if (count_02<10) begin 
			count_02<=count_02 + 1;
		end
		else begin
			endwt02 <=1;
		end
	end
	else begin
		endwt02 <= 0;
		count_02 <= 4'b0000;
	end
end

//0.00-9.99  timmer
/*
always @(posedge out_50Hz) begin
	if (KEY[0]==1) begin
		if (sttime) begin
			timecount <= 10'b00_0000_0000;
			if (timecount < 10'b11_1111_1000) begin
				timecount <= timecount+2'b10;
			end
			else begin
				timecount <=10'b11_1111_1111;
			end
		end
	end
	else begin
		timecount <= 10'b00_0000_0000;
	end
end
*/
//new 0-999 timmer
always @(posedge out_50Hz) begin
	if (sttime) begin
			timecount <= 10'b00_0000_0000;
			if (timecount < 10'b11_1111_1000) begin
				timecount <= timecount+2'b10;
			end
			else begin
				timecount <=10'b11_1111_1111;
			end
	end
	else begin
		timecount <= 10'b00_0000_0000;
	end
end


//shift register to generate random position
always @(posedge out_50Hz) begin
		pos <= (pos >> 1);
		if (pos == 10'b00_0000_0001) begin
			pos <= 10'b10_0000_0000;
		end
end




	
SF sfalways(.select(SW[9:8]),.acc_in(data_x[15:0]),.clk(clk),.enclk(out_50Hz),.reset(~KEY[0]),.smooth_out(so));	
remapper rm(.tcmpl(so),.board_posit(hammer));
BCD_c dsp(.in(display),.nothing(nothing),.clk(clk),.num2(HEX2),.num1(HEX1),.num0(HEX0));
assign reset_n = KEY[0];

//finite state machine

//next state logic
always @(*) begin
	count_c = count;
	case (count)
		5'b0_0000: begin
			HEX4= 8'b1111_1111;
			LEDR= 10'b00_0000_0000;
			nothing = 1;
			//count_30 = 8'b0000_0000;
			wt30 = 1;
			
			if (endwt30) begin
				wt30=0;
				mpos=pos;
				count_c=5'b0_0001;
			end
		end
		
		5'b0_0001: begin
			nothing = 1;
			LEDR = mpos;
			HEX4 = 8'b11111001; //1
			//count_02 = 4'b0000;
			wt02=1;
			
			if (endwt02) begin
				wt02=0;
				count_c=5'b0_0010;
			end
		end
		
		5'b0_0010: begin
			HEX4 = 8'b11111001; //1
			LEDR = hammer;
			nothing = 0;
			//timecount = 10'b00_0000_0000;
			sttime = 1;
			display = timecount;
			
			if((hammer==mpos)&&(KEY[1]==0)) begin
				sttime = 0;
				mem1 = timecount;
				count_c=5'b0_0011;
			end
		end
		
		5'b0_0011: begin
			HEX4 = 8'b11111001; //1
			LEDR = 10'b00_0000_0000;
			display = mem1;
			nothing = 0;
			//count_30 = 8'b0000_0000;
			wt30 =1;
			if (endwt30) begin
				wt30 = 0;
				mpos = pos;
				count_c = 5'b0_0100;
			end
		end
		
		5'b0_0100: begin
			nothing = 1;
			LEDR = mpos;
			HEX4 = 8'b10100100;         //2
			//count_02 = 4'b0000;
			wt02=1;
			
			if (endwt02) begin
				wt02=0;
				count_c=5'b0_0101;
			end
		end
		
		5'b0_0101: begin
			HEX4 = 8'b10100100;         //2
			LEDR = hammer;
			nothing = 0;
			//timecount = 10'b00_0000_0000;
			sttime = 1;
			display = timecount;
			
			if((hammer==mpos)&&(KEY[1]==0)) begin
				sttime = 0;
				mem2 = timecount;
				count_c=5'b0_0110;
			end
		end
		
		5'b0_0110: begin
			HEX4 = 8'b10100100;         //2
			LEDR = 10'b00_0000_0000;
			display = mem2;
			nothing = 0;
			//count_30 = 8'b0000_0000;
			wt30 =1;
			if (endwt30) begin
				wt30 = 0;
				mpos = pos;
				count_c = 5'b0_0111;
			end
		end
		
		5'b0_0111: begin
			nothing = 1;
			LEDR = mpos;
			HEX4 = 8'b10110000;         //3
			//count_02 = 4'b0000;
			wt02=1;
			
			if (endwt02) begin
				wt02=0;
				count_c=5'b0_1000;
			end
		end
		
		5'b0_1000: begin
			HEX4 = 8'b10110000;         //3
			LEDR = hammer;
			nothing = 0;
			//timecount = 10'b00_0000_0000;
			sttime = 1;
			display = timecount;
			
			if((hammer==mpos)&&(KEY[1]==0)) begin
				sttime = 0;
				mem3 = timecount;
				count_c=5'b0_1001;
			end
		end
		
		5'b0_1001: begin
			HEX4 = 8'b10110000;         //3
			LEDR = 10'b00_0000_0000;
			display = mem3;
			nothing = 0;
			//count_30 = 8'b0000_0000;
			wt30 =1;
			if (endwt30) begin
				wt30 = 0;
				mpos = pos;
				count_c = 5'b0_1010;
			end
		end
				
		5'b0_1010: begin
			nothing = 1;
			LEDR = mpos;
			HEX4 = 8'b10011001;         //4
			//count_02 = 4'b0000;
			wt02=1;
			
			if (endwt02) begin
				wt02=0;
				count_c=5'b0_1011;
			end
		end
		
		5'b0_1011: begin
			HEX4 = 8'b10011001;         //4
			LEDR = hammer;
			nothing = 0;
			//timecount = 10'b00_0000_0000;
			sttime = 1;
			display = timecount;
			
			if((hammer==mpos)&&(KEY[1]==0)) begin
				sttime = 0;
				mem4 = timecount;
				count_c=5'b0_1100;
			end
		end
		
		5'b0_1100: begin
			HEX4 = 8'b10011001;         //4
			LEDR = 10'b00_0000_0000;
			display = mem4;
			nothing = 0;
			//count_30 = 8'b0000_0000;
			wt30 = 1;
			if (endwt30) begin
				wt30 = 0;
				count_c = 5'b0_1101;
			end
		end
		
		5'b0_1101: begin
			HEX4 = 8'b10001000;         //A
			nothing = 0;
			display = mem1;
			//count_30 = 8'b0000_0000;
			wt02 = 1;
			if (endwt02) begin
				wt02=0;
				count_c = 5'b0_1110;
			end
		end
		
		5'b0_1110: begin
			HEX4 = 8'b10001000;         //A
			nothing = 0;
			display = mem1;
			//count_02 = 4'b0000;
			wt30=1;
			
			if (endwt30) begin
				wt30=0;
				count_c=5'b0_1111;
			end
		end
		
		
		5'b0_1111: begin
			HEX4 = 8'b10000011;         //B
			nothing = 0;
			display = mem2;
			//count_30 = 8'b0000_0000;
			wt02 = 1;
			if (endwt02) begin
				wt02=0;
				count_c = 5'b1_0000;
			end
		end
		
		5'b1_0000: begin
			HEX4 = 8'b10000011;         //B
			nothing = 0;
			display = mem2;
			//count_02 = 4'b0000;
			wt30=1;
			
			if (endwt30) begin
				wt30=0;
				count_c=5'b1_0001;
			end
		end
		
		5'b1_0001: begin
			HEX4 = 8'b11000110;         //C
			nothing = 0;
			display = mem3;
			//count_30 = 8'b0000_0000;
			wt02 = 1;
			if (endwt02) begin
				wt02=0;
				count_c = 5'b1_0010;
			end
		end
		5'b1_0010: begin
			HEX4 = 8'b11000110;         //C
			nothing = 0;
			display = mem3;
			//count_02 = 4'b0000;
			wt30=1;
			
			if (endwt30) begin
				wt30=0;
				count_c=5'b1_0011;
			end
		end
		
		5'b1_0011: begin
			HEX4 = 8'b11000000;         //D
			nothing = 0;
			display = mem4;
			//count_30 = 8'b0000_0000;
			wt02 = 1;
			if (endwt02) begin
				wt02=0;
				count_c = 5'b1_0100;
			end
		end
		5'b1_0100: begin
			HEX4 = 8'b11000000;         //D
			nothing = 0;
			display = mem4;
			//count_02 = 4'b0000;
			wt30=1;
			
			if (endwt30) begin
				wt30=0;
				count_c=5'b0_1101;
			end
		end
		
	endcase
	
	if (KEY[0]==0) begin
		count_c = 5'b0_0000;
		nothing = 1;
		HEX4= 8'b1111_1111;
		LEDR= 10'b00_0000_0000;
		//count_30 = 8'b0000_0000;
		//count_02 = 4'b0000;
		wt30=0;
		wt02=0;
		sttime=0;
	end
end

// flipflop

always @(posedge clk) begin
	if (KEY[0]==1) begin
		count <= count_c;
	end
	else begin
		count <= 5'b00000;
	end
end
		
endmodule
