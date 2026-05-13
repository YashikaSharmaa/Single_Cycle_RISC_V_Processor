`timescale 1ns / 1ps

module alu_tb();

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_ctrl;

    // Outputs
    wire [31:0] result;
    wire zero;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a), 
        .b(b), 
        .alu_ctrl(alu_ctrl), 
        .result(result), 
        .zero(zero)
    );

    initial begin
        // Initialize Inputs
        a = 0; b = 0; alu_ctrl = 0;

        // Wait 10 ns
        #10;
        
        $display("Starting ALU Test...");
        $monitor("Time=%0t | Ctrl=%b | A=%h | B=%h | Res=%h | Zero=%b", $time, alu_ctrl, a, b, result, zero);

        // Test Case 1: ADD
        // Expected Result: 30, Zero = 0
        a = 32'd10; b = 32'd20; alu_ctrl = 4'b0010; 
        #10;
        
        // Test Case 2: SUB (Result Zero)
        // Expected Result: 0, Zero = 1
        a = 32'd50; b = 32'd50; alu_ctrl = 4'b0110; 
        #10;

        // Test Case 3: AND
        // Expected Result: 0x5555_0000, Zero = 0
        a = 32'hAAAA_AAAA; b = 32'h5555_FFFF; alu_ctrl = 4'b0000; 
        #10;

        // Test Case 4: OR
        // Expected Result: 0xF0F0_F0F0, Zero = 0
        a = 32'hF0F0_F0F0; b = 32'h0F0F_0F0F; alu_ctrl = 4'b0001; 
        #10;

        // Test Case 5: SLT (Signed Less Than) - Negative check 
        // Expected Result: 1, Zero = 0
        a = 32'hFFFF_FFFF; // -1 in two's complement
        b = 32'h0000_0001; // +1
        alu_ctrl = 4'b0111; 
        #10;

        // Test Case 6: SLL (Shift Left Logical)
        // Expected Result: 0x0000_0010, Zero = 0
        a = 32'h0000_0001; b = 32'd4; alu_ctrl = 4'b1011; 
        #10;

        // Test Case 7: SRA (Shift Right Arithmetic) - Sign extension
        // Expected Result: 0xFFFF_FFFF, Zero = 0
        a = 32'h8000_0000; b = 32'd2; alu_ctrl = 4'b1010; 
        #10;

        // Test Case 8: XOR
        // Expected Result: 0xFFFF_FFFF, Zero = 0
        a = 32'h1234_5678; b = 32'h1234_5678; alu_ctrl = 4'b1000; 
        #10;

        $display("ALU Test Completed.");
        $finish;
    end

    initial begin
        $dumpfile("alu_op.vcd");
        $dumpvars(0, alu_tb);
    end
      
endmodule

/* 
VCD OUTPUT: 
Starting ALU Test...
Time=10000 | Ctrl=0010 | A=0000000a | B=00000014 | Res=0000001e | Zero=0
Time=20000 | Ctrl=0110 | A=00000032 | B=00000032 | Res=00000000 | Zero=1
Time=30000 | Ctrl=0000 | A=aaaaaaaa | B=5555ffff | Res=0000aaaa | Zero=0
Time=40000 | Ctrl=0001 | A=f0f0f0f0 | B=0f0f0f0f | Res=ffffffff | Zero=0
Time=50000 | Ctrl=0111 | A=ffffffff | B=00000001 | Res=00000001 | Zero=0
Time=60000 | Ctrl=1011 | A=00000001 | B=00000004 | Res=00000010 | Zero=0
Time=70000 | Ctrl=1010 | A=80000000 | B=00000002 | Res=e0000000 | Zero=0
Time=80000 | Ctrl=1000 | A=12345678 | B=12345678 | Res=00000000 | Zero=1
ALU Test Completed.
*/