`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:38 10/19/2015 
// Design Name: 
// Module Name:    mylab4 
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
module mylab4(
//-------------keyboard-----------------
input wire kb_clock, // This is the clock signal from Keyboard
input wire data, //This is the clock signal from Keyboard
//-------------VGA-----------------
input clk,
output wire vs,hs,pclk,
output wire cs,blnk, 
output wire [7:0] rd,gr,bl
);

wire [3:0] char;

keyb KeyboardInterface_unit
(.kb_clock(kb_clock), .data(data), .char(char)
);


vga vga_unit
(. char_addr(char),. clock(clk), . hsync (hs) , . vsync (vs),
.comp_sync(cs), .blank(blnk),
 .pixel_clock(pclk), .red(rd), .green(gr),.blue(bl));

endmodule