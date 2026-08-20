`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jonathan Melgar
//
// Create Date: 08/11/2026 09:28:39 PM
// Design Name:
// Module Name: basys3_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//              A small top-level wrapper to control the RISCV processor
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
/*
// Basys 3 top-level wrapper for cpu_top.
//
// This is not part of the CPU itself -- it exists purely to connect cpu_top
// to real board resources: the 100MHz system clock, a switch for reset,
// a switch for demo mode, LEDs to observe the trap interface, and the
// 7-segment display to observe PC.
//
// SW0 held high  = reset asserted
// SW1 held high  = demo mode: execution slowed to ~1.49Hz so the display
//                  is genuinely readable, instead of running at full speed
// LD0            = trap_valid
// LD4:LD1        = trap_cause
// LD15:LD5       = trap_pc[10:0] (low 11 bits, just for visibility)
// 7-segment       = pc_debug[11:0] while running, trap_pc[11:0] once
//                    trapped -- so normal mode and demo mode converge on the
//                    same final displayed value once halted, even though
//                    the live PC settles at a different address in each
//                    mode (an artifact of how far PC advances during the
//                    trap's fixed propagation delay, not a functional bug)
*/
module basys3_top(
    input  logic        CLK100MHZ,
    input  logic         SW0,
    input  logic         SW1,
    output logic [15:0]  LED,
    output logic [3:0]   an,
    output logic [6:0]   seg
);
 
logic        trap_valid;
logic [3:0]  trap_cause;
logic [31:0] trap_pc;
logic [31:0] pc_debug;
logic        demo_stall;

// clk_wiz_0 derives a safer clock instead of driving cpu_top from the
// board's raw oscillator directly.
logic cpu_clk;
logic clk_locked;
 
clk_wiz_0 clk_wiz_inst(
    .clk_in1(CLK100MHZ),
    .reset(1'b0),
    .clk_out1(cpu_clk),
    .locked(clk_locked)
);
 
// Hold cpu_top in reset until the derived clock has actually stabilized --
// clk_out1 isn't valid until clk_locked goes high.
logic cpu_reset;
assign cpu_reset = SW0 || !clk_locked;
 
// Genuinely stays on the same, already timing-closed clock at all
// times -- SW1 doesn't switch clock sources (a real glitch risk on a clock
// net), it gates whether the pipeline is allowed to actually advance each
// cycle instead.
demo_stall_gen demo_stall_inst(
    .clk(cpu_clk),
    .enable(SW1),
    .ext_stall(demo_stall)
);
 
cpu_top #(
    .IMEM_INIT_FILE("program.mem"),
    .DMEM_INIT_FILE("data.mem")
) uut(
    .clk(cpu_clk),
    .reset(cpu_reset),
 
    .trap_valid(trap_valid),
    .trap_cause(trap_cause),
    .trap_pc(trap_pc),
    .pc_debug(pc_debug),
    .ext_stall(demo_stall)
);
 
assign LED[0]     = trap_valid;
assign LED[4:1]   = trap_cause;
assign LED[15:5]  = trap_pc[10:0];
 
/*
While running, show the live PC so the display visibly counts up. Once
trapped, switch to trap_pc -- the address of the specific instruction
that actually faulted, regardless of execution speed. pc_debug
execution speed. pc_debug itself settles at a different address in normal
vs. demo mode (more pipeline stages' worth of PC advancement happen
before the trap's fixed propagation delay finishes in normal mode), so
showing trap_pc once halted is what makes the two modes agree on a
final number.
*/
logic [31:0] display_value;
assign display_value = trap_valid ? trap_pc : pc_debug;
 
// Driven from cpu_clk, not the raw CLK100MHZ pin -- a raw external clock
// pin can't legally feed both a dedicated clock buffer (into clk_wiz_inst
// above) and ordinary logic directly. cpu_clk is always a genuine,
// continuously-toggling 70MHz signal regardless of demo mode -- demo mode
// gates whether the pipeline responds to each edge, it never actually
// slows the clock itself -- so this stays a fast, flicker-free refresh
// rate either way.
seven_seg_driver disp(
    .clk(cpu_clk),
    .value({4'b0, display_value[11:0]}),
    .an(an),
    .seg(seg)
);
 
endmodule
