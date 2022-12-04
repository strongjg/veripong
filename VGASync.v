module VGASync (VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_AREA, CounterX, CounterY);
output VGA_CLK;     // VGA Clock
output VGA_HS;      // VGA H_SYNC
output VGA_VS;      // VGA V_SYNC
output VGA_BLANK_N; // VGA BLANK
output VGA_SYNC_N;  // VGA SYNC
output reg VGA_AREA;
output reg [9:0] CounterX;
output reg [8:0] CounterY;

reg HSync, VSync;

wire CounterXmaxed = (CounterX==10'h2FF);

always @(posedge VGA_CLK)
if(CounterXmaxed)
	CounterX <= 0;
else
	CounterX <= CounterX + 1;

always @(posedge VGA_CLK)
if(CounterXmaxed)
	CounterY <= CounterY + 1;

always @(posedge VGA_CLK)
begin
	HSync <= (CounterX[9:4]==6'h0); // change this value to move the display horizontally
	VSync <= (CounterY==500); // change this value to move the display vertically
end

always @(posedge VGA_CLK)
if(VGA_AREA==0)
	VGA_AREA <= (CounterXmaxed) && (CounterY<478);
else
	VGA_AREA <= !(CounterX==629);
	
assign VGA_HS = ~HSync;
assign VGA_VS = ~VSync;

endmodule
