`timescale 1ns / 1ps

module instr_mem_tb();

    parameter MEM_SIZE = 256;

    // Inputs
    reg [31:0] addr;

    // Output
    wire [31:0] instr;

    // Instantiate UUT
    instr_mem #(.MEM_SIZE(MEM_SIZE)) uut (
        .addr(addr), 
        .instr(instr)
    );

    initial begin
        $display("Starting Instruction Memory Test...");

        // Test 1: Read first instruction
        addr = 32'h0000_0000;
        #10;
        $display("Addr: %h | Instr: %h", addr, instr);

        // Test 2: Read next instruction (Word aligned)
        addr = 32'h0000_0004;
        #10;
        $display("Addr: %h | Instr: %h", addr, instr);

        // Test 3: Check word alignment logic
        // Address 0, 1, 2, and 3 should all return index 0
        addr = 32'h0000_0002; 
        #10;
        $display("Addr: %h | Instr: %h (Should match Addr 0)", addr, instr);

        // Test 4: Jump to a later address
        addr = 32'h0000_001C; // (7th instruction)
        #10;
        $display("Addr: %h | Instr: %h", addr, instr);

        $display("Instruction Memory Test Completed.");
        $finish;
    end
      
    initial begin
        $dumpfile("instr_mem_op.vcd");
        $dumpvars(0, instr_mem_tb);
    end
    
endmodule

/* 
Starting Instruction Memory Test...
VCD info: dumpfile instr_mem_op.vcd opened for output.
Addr: 00000000 | Instr: 01e00093
Addr: 00000004 | Instr: 00a00113
Addr: 00000002 | Instr: 01e00093 (Should match Addr 0)
Addr: 0000001c | Instr: 0020a533
Instruction Memory Test Completed.
*/