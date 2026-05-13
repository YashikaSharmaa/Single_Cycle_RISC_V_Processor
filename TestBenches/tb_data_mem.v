`timescale 1ns / 1ps

module data_mem_tb();

    parameter MEM_SIZE = 256;

    // Inputs
    reg clk;
    reg mem_write;
    reg mem_read;
    reg [31:0] addr;
    reg [31:0] write_data;

    // Output
    wire [31:0] read_data;

    // Instantiate the Unit Under Test (UUT)
    data_mem #(.MEM_SIZE(MEM_SIZE)) uut (
        .clk(clk), 
        .mem_write(mem_write), 
        .mem_read(mem_read), 
        .addr(addr), 
        .write_data(write_data), 
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        mem_write = 0;
        mem_read = 0;
        addr = 0;
        write_data = 0;

        $display("Starting Data Memory Test...");
        
        // Wait for global reset
        #10;

        // Test 1: Write to Memory
        // Write 0xDEAEBACE to address 4 (Word index 1)
        @(posedge clk);
        addr = 32'd4; 
        write_data = 32'hDEAEBACE;
        mem_write = 1;
        
        @(posedge clk);
        mem_write = 0; // Turn off write

        // Test 2: Read back from Memory
        #5;
        mem_read = 1;
        #5;
        if (read_data === 32'hDEAEBACE)
            $display("Test 1 Passed: Read 0x%h from address %d", read_data, addr);
        else
            $display("Test 1 Failed: Expected 0xDEAEBACE, got 0x%h", read_data);

        // Test 3: Word Alignment Check
        // Address 8, 9, 10, and 11 should all point to Word index 2
        @(posedge clk);
        addr = 32'd8; 
        write_data = 32'hCABEBABE;
        mem_write = 1;
        
        @(posedge clk);
        mem_write = 0;
        
        addr = 32'd11; 
        #5;
        $display("Alignment Test: Addr 11 reads 0x%h", read_data);

        // Test 4: Disable Read
        mem_read = 0;
        #5;
        if (read_data === 32'd0)
            $display("Test 4 Passed: Output is 0 when mem_read is low");

        #20;
        $display("Data Memory Test Completed.");
        $finish;
    end

    initial begin
        $monitor("Time: %0t | Addr: %d | Write Data: 0x%h | Read Data: 0x%h | mem_write: %b | mem_read: %b", 
                 $time, addr, write_data, read_data, mem_write, mem_read);
        $dumpfile("data_mem_op.vcd");
        $dumpvars(0, data_mem_tb);
    end
      
endmodule

/*
Starting Data Memory Test...
VCD info: dumpfile data_mem_op.vcd opened for output.
Time: 0 | Addr:          0 | Write Data: 0x00000000 | Read Data: 0x00000000 | mem_write: 0 | mem_read: 0
Time: 15000 | Addr:          4 | Write Data: 0xdeaebace | Read Data: 0x00000000 | mem_write: 1 | mem_read: 0
Time: 25000 | Addr:          4 | Write Data: 0xdeaebace | Read Data: 0x00000000 | mem_write: 0 | mem_read: 0
Time: 30000 | Addr:          4 | Write Data: 0xdeaebace | Read Data: 0xdeaebace | mem_write: 0 | mem_read: 1
Test 1 Passed: Read 0xdeaebace from address          4
Time: 45000 | Addr:          8 | Write Data: 0xcabebabe | Read Data: 0x00000000 | mem_write: 1 | mem_read: 1
Time: 55000 | Addr:         11 | Write Data: 0xcabebabe | Read Data: 0x00000000 | mem_write: 0 | mem_read: 1
Alignment Test: Addr 11 reads 0x00000000
Time: 60000 | Addr:         11 | Write Data: 0xcabebabe | Read Data: 0x00000000 | mem_write: 0 | mem_read: 