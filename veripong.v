module veripong (clk, rst, LeftUpIn, LeftDownIn, RightUpIn, RightDownIn, height, width);
input clk, rst, LeftUpIn, LeftDownIn, RightUpIn, RightDownIn;
input [9:0] height;
input [9:0] width;

parameter LiveHeight = 640;
parameter LiveWidth = 480;

reg [8:0] LeftMove = 240;
reg [8:0] RightMove = 240;

reg LeftUpOut = 0;
reg LeftDownOut = 0;
reg RightUpOut = 0;
reg RightDownOut = 0;

reg [7:0] RightBlue;
reg [7:0] RightGreen;
reg [7:0] RightRed;

reg [7:0] LeftBlue;
reg [7:0] LeftGreen;
reg [7:0] LeftRed;

/* Referenced Paddle Code by daveisyofav */
/* https://github.com/daveisyofav/Pong-Game-on-FPGA-Verilog- */

always @ (posedge clk)
	begin
	LeftUpOut <= LeftUpIn;
	LeftDownOut <= LeftDownIn;
	if ((LeftUpOut == 0) && (LeftUpIn == 1)) // If left up button is pushed
		begin
		if (LeftMove > 31)
			LeftMove <= LeftMove - 30;
		else
			LeftMove <= 450;
		end
	else if ((LeftDownOut == 0) && (LeftDownIn == 1)) //If left down button is pushed
		begin
		if (LeftMove < 449)
			LeftMove <= LeftMove + 30;
		else
			LeftMove <= 30;
		end
	else
		LeftMove <= LeftMove;
	end

always @ (posedge clk)
	begin
	RightUpOut <= RightUpIn;
	RightDownOut <= RightDownIn;	
	if ((RightDownOut == 0) && (RightDownIn == 1))	// If right up button is pushed
		begin
		if (RightMove < 449)
			RightMove <= RightMove + 30;
		else
			RightMove <= 30;
		end
	else if ((RightUpOut == 0) && (RightUpIn == 1))
		begin
		if (RightMove > 31)
			RightMove <= RightMove - 30;
		else
			RightMove <= 450;
		end
	else
		RightMove <= RightMove;
	end
	
always @ (posedge clk)
	begin
	// move the ball right and return it if it hits the paddle State Machine?
	
	//create left paddle in columns 5 - 10
	if (height > 5 && height < 10)
		begin
		if (width > (LeftMove - 30) && width < (LeftMove + 30))
			begin
			LeftBlue <= 8'b11111111;
			LeftGreen <= 8'b11111111;
			LeftRed <= 8'b11111111;
			end
		else
			begin
			LeftBlue <= 8'b00000000;
			LeftGreen <= 8'b00000000;
			LeftRed <= 8'b00000000;
			end
		end	

	//create right paddles in columns 630 - 635
	else if (height > (LiveHeight - 10) && height < (LiveHeight - 5))
		begin
		if (width > (RightMove - 30) && width < (RightMove + 30))
			begin
			RightBlue <= 8'b11111111;
			RightGreen <= 8'b11111111;
			RightRed <= 8'b11111111;
			end
		else
			begin
			RightBlue <= 8'b00000000;
			RightGreen <= 8'b00000000;
			RightRed <= 8'b00000000;
			end
		end
	
	// in any other columns these are zero
	else
		begin
		RightBlue <= 8'b00000000;
		RightGreen <= 8'b00000000;
		RightRed <= 8'b00000000;
		LeftBlue <= 8'b00000000;
		LeftGreen <= 8'b00000000;
		LeftRed <= 8'b00000000;
		end
	end
	
endmodule
