module veripong(VGA_CLK, VGA_HS, VGA_VS, VGABlank, VGASync, red, green, blue, quadA, quadB);
output VGA_CLK;
output VGA_HS, VGA_VS, VGABlank, VGASync;
output reg [7:0] red, green, blue;
input quadA, quadB;

wire inDisplayArea;
wire [9:0] CounterX;
wire [8:0] CounterY;

VGASync Sync(.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_N(VGABlank), .VGA_SYNC_N(VGASync), .VGA_AREA(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));

/////////////////////////////////////////////////////////////////
reg [8:0] PaddlePosition;
reg [2:0] quadAr, quadBr;
always @(posedge VGA_CLK)
	quadAr <= {quadAr[1:0], quadA};
always @(posedge VGA_CLK)
	quadBr <= {quadBr[1:0], quadB};

always @(posedge VGA_CLK)
if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
begin
	if(quadAr[2] ^ quadBr[1])
	begin
		if(~&PaddlePosition)        // make sure the value doesn't overflow
			PaddlePosition <= PaddlePosition + 1;
	end
	else
	begin
		if(|PaddlePosition)        // make sure the value doesn't underflow
			PaddlePosition <= PaddlePosition - 1;
	end
end

/////////////////////////////////////////////////////////////////
reg [9:0] ballX;
reg [8:0] ballY;
reg ball_inX, ball_inY;

always @(posedge VGA_CLK)
if(ball_inX==0) ball_inX <= (CounterX==ballX) & ball_inY; else ball_inX <= !(CounterX==ballX+16);

always @(posedge VGA_CLK)
if(ball_inY==0) ball_inY <= (CounterY==ballY); else ball_inY <= !(CounterY==ballY+16);

wire ball = ball_inX & ball_inY;

/////////////////////////////////////////////////////////////////
wire border = (CounterX[9:3]==0) || (CounterX[9:3]==79) || (CounterY[8:3]==0) || (CounterY[8:3]==59);
wire paddle = (CounterX>=PaddlePosition+8) && (CounterX<=PaddlePosition+120) && (CounterY[8:4]==27);
wire BouncingObject = border | paddle; // active if the border or paddle is redrawing itself

reg ResetCollision;
always @(posedge VGA_CLK)
	ResetCollision <= (CounterY==500) & (CounterX==0);  // active only once for every video frame

reg CollisionX1, CollisionX2, CollisionY1, CollisionY2;
always @(posedge VGA_CLK)
	if(ResetCollision)
		CollisionX1<=0;
	else if(BouncingObject & (CounterX==ballX) & (CounterY==ballY + 8))
		CollisionX1<=1;
	
always @(posedge VGA_CLK)
	if(ResetCollision)
		CollisionX2<=0;
	else if(BouncingObject & (CounterX==ballX + 16) & (CounterY==ballY + 8))
		CollisionX2<=1;
	
always @(posedge VGA_CLK)
	if(ResetCollision)
		CollisionY1<=0;
	else if(BouncingObject & (CounterX==ballX + 8) & (CounterY==ballY))
		CollisionY1<=1;
		
always @(posedge VGA_CLK)
	if(ResetCollision)
		CollisionY2<=0;
	else if(BouncingObject & (CounterX==ballX + 8) & (CounterY==ballY + 16))
		CollisionY2<=1;

/////////////////////////////////////////////////////////////////
wire UpdateBallPosition = ResetCollision;  // update the ball position at the same time that we reset the collision detectors

reg ball_dirX, ball_dirY;
always @(posedge VGA_CLK)
if(UpdateBallPosition)
begin
	if(~(CollisionX1 & CollisionX2))        // if collision on both X-sides, don't move in the X direction
	begin
		ballX <= ballX + (ball_dirX ? -1 : 1);
		if(CollisionX2) ball_dirX <= 1; else if(CollisionX1) ball_dirX <= 0;
	end

	if(~(CollisionY1 & CollisionY2))        // if collision on both Y-sides, don't move in the Y direction
	begin
		ballY <= ballY + (ball_dirY ? -1 : 1);
		if(CollisionY2) ball_dirY <= 1; else if(CollisionY1) ball_dirY <= 0;
	end
end 

/////////////////////////////////////////////////////////////////
wire [7:0] R = BouncingObject | ball | (CounterX[3] ^ CounterY[3]);
wire [7:0] G = BouncingObject | ball;
wire [7:0] B = BouncingObject | ball;

always @(posedge VGA_CLK)
begin
	red <= R & inDisplayArea;
	green <= G & inDisplayArea;
	blue <= B & inDisplayArea;
end

endmodule