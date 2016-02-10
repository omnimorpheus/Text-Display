`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:39:54 10/26/2015 
// Design Name: 
// Module Name:    font 
// Project Name: 
// Target Devices: 
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
module font
(
input wire clk,
input wire video_on,
input wire [9:0] pixel_x , pixel_y ,
output reg [7:0] red,blue,green
);
// s i g n a l d e c l a r a t i o n
wire [9:0] rom_addr;
wire [7:0] char_addr ;
wire [2:0] row_addr;
wire [2:0] bit_addr;
wire [7:0] font_word;
wire font_bit , text_bit_on;
// body
// i n s t a n t i a t e f o n t ROM
first rom_unit
(.clka(clk), .addra(rom_addr), .douta(font_word));
// font ROM i n t e r f a c e
assign char_addr = {pixel_y [6:4] , pixel_x [7:3]};
assign row_addr = pixel_y [2:0] ;
assign rom_addr = {char_addr,row_addr};
assign bit_addr = pixel_x [2:0] ;
assign font_bit = font_word [~bit_addr] ;
// " o n " r e g i o n l i m i t e d t o t o p _ l e f t c o r n e r
assign text_bit_on = (pixel_x [9:8]==0 && pixel_y [9: 6] ==0) ?
font_bit : 1'b0;
// rgb m u l t i p l e x i n g c i r c u i t
always @*
if (~video_on)
		begin
		red <=0;green <= 0;blue <= 255;
		end
else
if (text_bit_on)
		begin
		red <= 0;green <= 255;blue <= 0;
		end
endmodule