`timescale 1ns / 1ps

module riscv_top_tb();

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the Top Level RISC-V Processor
    riscv_top uut (
        .clk(clk), 
        .rst(rst), 
        .seg(seg), 
        .an(an)
    );

    // Clock generation (10ns period = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst = 1; // Start in reset

        $display("System Reset Asserted...");
        #20;
        rst = 0; // Release reset
        $display("System Reset Released. Starting Execution...");

        // Monitor PC and core internal signals for debugging
        $display("Time | PC       | Instr    | x10 (a0) Value");

        repeat (10) begin
            @(posedge clk);
            #1; // Small delay to allow signals to settle after clock edge
            $display("%4t | %h | %h | %d", 
                     $time, uut.pc, uut.instr, uut.regfile.registers[10]);
        end

        $display("Simulation timeout reached.");
        $finish;
    end

    initial begin
        $dumpfile("riscv_top_op.vcd");
        $dumpvars(0, riscv_top_tb);
    end
      
endmodule

/*
VCD info: dumpfile riscv_top_op.vcd opened for output.
System Reset Released. Starting Execution...
Time | PC       | Instr    | x10 (a0) Value
26000 | 00000004 | 00a00113 |          0
36000 | 00000008 | 00208533 |          0
46000 | 0000000c | 40208533 |         40
56000 | 00000010 | 0020f533 |         20
66000 | 00000014 | 0020e533 |         10
76000 | 00000018 | 0020c533 |         30
86000 | 0000001c | 0020a533 |         20
96000 | 00000020 | 00a52023 |          0
106000 | 00000024 | 00052503 |          0
116000 | 00000028 | 00a50463 |          0
Simulation timeout reached.
*/