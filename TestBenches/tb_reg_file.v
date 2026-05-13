`timescale 1ns / 1ps

module register_file_tb();

    // Inputs
    reg clk;
    reg reg_write;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] read_data1, read_data2;

    // Instantiate UUT
    register_file uut (
        .clk(clk), 
        .reg_write(reg_write), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .write_data(write_data), 
        .read_data1(read_data1), 
        .read_data2(read_data2)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0; reg_write = 0; rs1 = 0; rs2 = 0; rd = 0; write_data = 0;

        $display("Starting Register File Test...");
        
        // Wait for reset
        #10;

        // Test 1: Write to Register x1
        @(posedge clk);
        reg_write = 1; rd = 5'd1; write_data = 32'hAAAA_BBBB;
        
        @(posedge clk);
        reg_write = 0; // Stop writing

        // Test 2: Read back from x1 and check x0
        rs1 = 5'd1; // Should be AAAA_BBBB
        rs2 = 5'd0; // Should be 0
        #5;
        $display("Read x1: %h | Read x0: %h", read_data1, read_data2);

        // Test 3: Attempt to write to x0
        // Register x0 must remain 0 in RISC-V
        @(posedge clk);
        reg_write = 1; rd = 5'd0; write_data = 32'hFFFF_FFFF;
        
        @(posedge clk);
        reg_write = 0;
        rs1 = 5'd0;
        #5;
        if (read_data1 == 32'h0)
            $display("Success: x0 is immutable and remains 0.");
        else
            $display("Failure: x0 was overwritten!");

        // Test 4: Simultaneous Read/Write
        // Writing to x2 while reading from x1
        @(posedge clk);
        reg_write = 1; rd = 5'd2; write_data = 32'h1234_5678;
        rs1 = 5'd1;
        
        @(posedge clk);
        reg_write = 0;
        rs2 = 5'd2; // Now check x2
        #5;
        $display("Read x1: %h | Read x2: %h", read_data1, read_data2);

        #20;
        $display("Register File Test Completed.");
        $finish;
    end

    initial begin
        $dumpfile("register_file_op.vcd");
        $dumpvars(0, register_file_tb);
    end
      
endmodule

/*
Starting Register File Test...
VCD info: dumpfile register_file_op.vcd opened for output.
Read x1: aaaabbbb | Read x0: 00000000
Success: x0 is immutable and remains 0.
Read x1: aaaabbbb | Read x2: 12345678
Register File Test Completed.
*/