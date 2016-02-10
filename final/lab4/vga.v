`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: UCF_EEL5722C
// Engineer: Syed Ahmed 
// 
// Create Date:    15:02:08 09/28/2015 
// Design Name: 
// Module Name:    vga 
// Project Name: LAB 2 Assignment
// Target Devices: VGA monitor 640x480@(25Mhz)
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga(
input [3:0] char_addr,
input clock, // the clock signal and the reset push buttons on board
output reg [7:0] red,blue,green,
output reg hsync, vsync, pixel_clock, 
output wire blank,comp_sync
);


assign blank = 1; //initialize the  this signal to 1
assign comp_sync = 1; //initialize the  this signal to 1
// pixel clock = 25Mhz
parameter a = 800; //31.77 * pixel clock 
parameter b = 96;
parameter c = 48;
parameter d = 640;
parameter e = 16;
parameter o = 525; // 16.6 * pixel clock / a
parameter p = 2;
parameter q = 33;
parameter r = 480;
parameter s = 10;

//=====SETTING Pixel Clock @ 25Mhz==============================START=====================
reg [1:0] pcount;
always @ (posedge clock)
begin
	pcount<= pcount+1;
	if (pcount[0]==1)
		pixel_clock <= ~pixel_clock;
	end
//=====SETTING Pixel Clock @ 25Mhz==============================END=======================

reg [9:0] hsync_count; // the count for the horizontal synchronization signal for 1 cycle || It goes from 0 to 794
reg [8:0] vsync_count; // the count for the vertical synchronization signal for 1 cycle || It goes from 0 to 523

wire [6:0] rom_addr;
wire [2:0] row_addr;
wire [2:0] bit_addr;
wire [7:0] font_word;
wire font_bit; 
//wire text_bit_on;

assign row_addr = vsync_count [2:0] ;
assign rom_addr = {char_addr,row_addr};
assign bit_addr = hsync_count [2:0] ;
assign font_bit = font_word [~bit_addr] ;
//assign text_bit_on = (hsync_count [9:8]==0 && vsync_count [8:6] ==0) ? font_bit : 1'b0;

font_rom rom_unit
(.clka(pixel_clock), .addra(rom_addr), .douta(font_word));

always @ (posedge pixel_clock) // When the clock ticks
begin
	hsync_count <= hsync_count + 1; // keep counting buddy and keep up the good work ;)
	// the value for hsync and vsynce is either 1 or 0 and this is output from the board and input to the vga monitor
	// lets now handle this value within each cycle
	//============== Determine the horizontal and vertical synchronization values ===========START======
	//============== At the begining of the cycle =================== START =========
	if (hsync_count >= a)  // when the limit of one cycle is reached
		begin
			hsync_count <= 0; // reset the count value so that it can start from 0 for the next cycle
			vsync_count <= vsync_count + 1; // now start counting in y axis i.e for the vertical sync signal.
		end
	if (vsync_count >= o) // this is alphabet o and not zero ||  when the limit of one cycle is reached
		begin
		vsync_count <= 0; // reset the count value so that it can start from 0 for the next cycle
		end
	//============== At the begining of the cycle =================== END =========
	
	//============== turn on the synchronization signals ==================== Start =========
	if ((vsync_count >= p) && (vsync_count < o))
			begin
			vsync <= 1;
			end
	else
			begin
			vsync <= 0;
			end
	if ((hsync_count >= b) && (hsync_count < a))
			begin
			hsync <= 1;
			end
	else
			begin
			hsync <= 0;
			end
	//============== turn on the synchronization signals ==================== End =========
	
	//============== handle c,d,e ==================== Start =========
if ((hsync_count >= b+c) && (hsync_count < a-e)) // inside 640x480
	begin
		if ((hsync_count > b+c+7)&&(hsync_count <b+c+16)&&(vsync_count > p+q+3)&&(vsync_count < p+q+12)) // inside 8x8 square
			begin
				if (font_bit)
					begin
						red <= 255;green <= 0;blue <= 0; // for data bit = 1
					end
				else
					begin
						red <= 255;green <= 255;blue <= 255; // for data bit = 0
					end
			end
		else
			begin
				red <= 255;green <= 255;blue <= 255; // outside 8x8 but inside 640x480
			end
	end
else // outside 640x480
	begin
		red <= 0;green <= 0;blue <= 0;
	end
//============== handle c,d,e ==================== end =========
end //=======When the clock ticks=====end========
endmodule
