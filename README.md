# RISCV-Processor-on-FPGA
The synthesis and implementation of the CPU design from my RISCV-Processor simulation.

## Synthesis Schematic
<img width="2029" height="1216" alt="Schematic_Design" src="https://github.com/user-attachments/assets/4b5bbc6e-c716-4d70-b1ce-fb0fcaa82f97" />

## Implementation Design
<img width="2023" height="1212" alt="Implemented_Design" src="https://github.com/user-attachments/assets/c89d7920-5d5f-41b6-9ef3-4c6fb6b60ef0" />

## Timing Results
<img width="916" height="202" alt="Timing_Results" src="https://github.com/user-attachments/assets/356e8551-2cc5-459e-9b27-2d31d679d01f" />

## Utilization and Power Results
<img width="1954" height="325" alt="Utilization_and_Power" src="https://github.com/user-attachments/assets/6f310ecc-4d62-4df2-9c35-a7be90aeff3a" />

## Waveform Generation from a Test Program (simpleprogram.s)
<img width="2028" height="1219" alt="Simulation_Waveform" src="https://github.com/user-attachments/assets/d815b574-d48f-44e4-975e-f75c46c9cf2f" />

## Write Up
Here are the results from the synthesis and implementation of my RISCV CPU in Vivado! I spent most of my time getting the CPU RTL code for the simulation in a good spot so that this step of the project wouldn't take too much time to figure out, but even then, there were issues and problems I had to overcome. This is my first time using Vivado so I also spent a lot of time familiarizing myself with the environment and the features that Vivado offered; thankfully AI helped speed up the process when I got errors that I didn't know!


Along the way I got a real education in the gap between "the simulator says it's correct" and "the real chip agrees" — chasing down clock-buffering rules, memory-initialization quirks, and a subtle mismatch in how different simulators handle uninitialized state. I had to deal with timing errors not allowing my design to close. My initial implementation did not close so I had to look for a way to change the clocking speed at which the CPU ran which led me to the clocking wizard solution that allow me to change what speed I ran the CPU at. Another issue I had to deal with that didn't allow me to run my implementation was that Vivado does not process .hex files, so I had to change the code to instead recognize .mem files which were essentially the same thing just in a different format.


This was a great learning experience in FPGA development workflow as it was really cool to see my simulation design come to life on real silicon! It was really cool to see all the connections that were being made on the hardware that we wouldn't be able to see without zooming in really close on the implemented design! I look forward to adding more components to this project like a multiplier or divider that someone suggested or some other aspect that will further challenge me and help me grow in the FPGA development process!


Like I said, this is my first time using Vivado, so if anyone has any tips, useful tools, if I made a mistake in my implementation of this design, or any other suggestions on how I can make this project better, please let me know. Thank you!
