`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Melgar
// 
// Create Date: 08/17/2026 11:24:13 PM
// Design Name: 
// Module Name: demo_stall_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              "Demo" mode on the Basys3 for the RISCV Processor
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
Generates a periodic single-cycle "advance" pulse (everything else is a
stall) out of a free-running counter, so a CPU gated by it only actually
executes one real cycle roughly every ~1.49Hz to ~2.4Hz depending on the 
clock of the CPU -- but slows the CPU enough for a human
to watch each instruction land on the display, instead of the normal
60-70MHz operational speed.
*/
module demo_stall_gen(
    input  logic clk,
    input  logic enable,      // demo mode selected; when low, never stalls
    output logic ext_stall
);
 
logic [24:0] demo_counter;
 
always_ff @(posedge clk) begin
    demo_counter <= demo_counter + 1'b1;  // free-running, wraps naturally
end
 
// Stall on every cycle except the single cycle per wrap where the counter
// reaches all-ones.
assign ext_stall = enable && (demo_counter != {25{1'b1}});
 
endmodule
 