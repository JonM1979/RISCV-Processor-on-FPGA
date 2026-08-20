`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Melgar
// 
// Create Date: 08/16/2026 10:52:27 PM
// Design Name: 
// Module Name: seven_seg_driver
// Project Name: RISCV Processor
// Target Devices: 
// Tool Versions: 
// Description:
//              Disply driver for the 7-segment display on the Basys3    
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Drives the Basys 3's 4-digit multiplexed 7-segment display.
//
// The display is common-anode: AN[n] is active-LOW to select digit n, and
// each segment in SEG[6:0] is active-LOW to light it. Only one digit is
// ever actually driven at a time -- cycling through all four fast enough
// (here, ~95Hz for the full 4-digit cycle) relies on persistence of vision
// to make all four appear lit simultaneously.
//
// Deliberately clocked independently of whatever clock drives the value
// being displayed (see basys3_top.sv) -- the multiplexing refresh rate has
// to stay fast regardless of how fast or slow the CPU itself is running.
module seven_seg_driver(
    input  logic        clk,
    input  logic [15:0] value,
 
    output logic [3:0]  an,
    output logic [6:0]  seg
);
 
logic [17:0] refresh_counter;
always_ff @(posedge clk) begin
    refresh_counter <= refresh_counter + 1'b1;
end
 
logic [1:0] digit_sel;
assign digit_sel = refresh_counter[17:16];
 
logic [3:0] digit_value;
always_comb begin
    case (digit_sel)
        2'd0:    digit_value = value[3:0];
        2'd1:    digit_value = value[7:4];
        2'd2:    digit_value = value[11:8];
        default: digit_value = value[15:12];
    endcase
end
 
always_comb begin
    an = 4'b1111;
    an[digit_sel] = 1'b0;
end
 
// Hex-to-seven-segment decoder, active-low, segments ordered {g,f,e,d,c,b,a}
always_comb begin
    case (digit_value)
        4'h0:    seg = 7'b1000000;
        4'h1:    seg = 7'b1111001;
        4'h2:    seg = 7'b0100100;
        4'h3:    seg = 7'b0110000;
        4'h4:    seg = 7'b0011001;
        4'h5:    seg = 7'b0010010;
        4'h6:    seg = 7'b0000010;
        4'h7:    seg = 7'b1111000;
        4'h8:    seg = 7'b0000000;
        4'h9:    seg = 7'b0010000;
        4'ha:    seg = 7'b0001000;
        4'hb:    seg = 7'b0000011;
        4'hc:    seg = 7'b1000110;
        4'hd:    seg = 7'b0100001;
        4'he:    seg = 7'b0000110;
        default: seg = 7'b0001110; // 4'hf
    endcase
end
 
endmodule