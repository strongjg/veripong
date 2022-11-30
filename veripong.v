module veripong (clk, rst, input LeftUpIn, input LeftDownIn, input RightUpIn, input RightDownIn, input [9:0] height, input [9:0] width);
input clk, rst;

/* Referenced Paddle Code by daveisyofav */
/* https://github.com/daveisyofav/Pong-Game-on-FPGA-Verilog- */

reg [8:0] LeftMove = 240;
reg [8:0] RightMove = 240;

reg LeftUpOut = 0;
reg LeftDownOut = 0;
reg RightUpOut = 0;
reg RightDownOut = 0;

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
	else if ((RightUpDown == 0) && (RightUpIn == 1))
		begin
		if (RightMove > 31)
			RightMove <= RightMove - 30;
		else
			RightMove <= 450;
		end
	else
		RightMove <= RightMove;
	end

endmodule
