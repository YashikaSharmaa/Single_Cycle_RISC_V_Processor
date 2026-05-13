`timescale 1ns / 1ps

module alu_control_tb();

    // Inputs
    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg [6:0] funct7;

    // Output
    wire [3:0] alu_ctrl;

    // Instantiate the Unit Under Test (UUT)
    alu_control uut (
        .alu_op(alu_op), 
        .funct3(funct3), 
        .funct7(funct7), 
        .alu_ctrl(alu_ctrl)
    );

    initial begin
        // Initialize Inputs
        alu_op = 0; funct3 = 0; funct7 = 0;

        $display("Starting ALU Control Test...");
        $monitor("Time=%0t | ALUOp=%b | F3=%b | F7[5]=%b | Result Ctrl=%b", $time, alu_op, funct3, funct7[5], alu_ctrl);

        // Test 1: Load/Store (alu_op = 00)
        // Expected: ADD (0010)
        alu_op = 2'b00; #10;

        // Test 2: Branch (alu_op = 01)
        // Expected: SUB (0110)
        alu_op = 2'b01; #10;

        // Test 3: LUI (alu_op = 11)
        // Expected: Pass B (1101)
        alu_op = 2'b11; #10;

        // Test 4: R-type/I-type (alu_op = 10)
        alu_op = 2'b10;

        // Sub-test: ADD (funct3 = 000, funct7[5] = 0)
        // Expected: ADD (0010)
        funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // Sub-test: SUB (funct3 = 000, funct7[5] = 1)
        // Expected: SUB (0110)
        funct3 = 3'b000; funct7 = 7'b0100000; #10;

        // Sub-test: SLL (funct3 = 001)
        // Expected: SLL (0001)
        funct3 = 3'b001; #10;

        // Sub-test: SLT (funct3 = 010)
        // Expected: SLT (0111)
        funct3 = 3'b010; #10;

        // Sub-test: XOR (funct3 = 100)
        // Expected: XOR (0011)
        funct3 = 3'b100; #10;

        // Sub-test: SRL (funct3 = 101, funct7[5] = 0)
        // Expected: SRL (0101)
        funct3 = 3'b101; funct7 = 7'b0000000; #10;

        // Sub-test: SRA (funct3 = 101, funct7[5] = 1)
        // Expected: SRA (1100)
        funct3 = 3'b101; funct7 = 7'b0100000; #10;

        // Sub-test: OR (funct3 = 110)
        // Expected: OR (0000)
        funct3 = 3'b110; #10;

        // Sub-test: AND (funct3 = 111)
        // Expected: AND (0001)
        funct3 = 3'b111; #10;

        $display("ALU Control Test Completed.");
        $finish;
    end

    initial begin
        $dumpfile("alu_control_op.vcd");
        $dumpvars(0, alu_control_tb);
    end
      
endmodule

/* 
VCD OUTPUT:
Time=0 | ALUOp=00 | F3=000 | F7[5]=0 | Result Ctrl=0010
Time=10000 | ALUOp=01 | F3=000 | F7[5]=0 | Result Ctrl=0110
Time=20000 | ALUOp=11 | F3=000 | F7[5]=0 | Result Ctrl=1101
Time=30000 | ALUOp=10 | F3=000 | F7[5]=0 | Result Ctrl=0010
Time=40000 | ALUOp=10 | F3=000 | F7[5]=1 | Result Ctrl=0110
Time=50000 | ALUOp=10 | F3=001 | F7[5]=1 | Result Ctrl=1011
Time=60000 | ALUOp=10 | F3=010 | F7[5]=1 | Result Ctrl=0111
Time=70000 | ALUOp=10 | F3=100 | F7[5]=1 | Result Ctrl=1000
Time=80000 | ALUOp=10 | F3=101 | F7[5]=0 | Result Ctrl=1001
Time=90000 | ALUOp=10 | F3=101 | F7[5]=1 | Result Ctrl=1010
Time=100000 | ALUOp=10 | F3=110 | F7[5]=1 | Result Ctrl=0001
Time=110000 | ALUOp=10 | F3=111 | F7[5]=1 | Result Ctrl=0000
ALU Control Test Completed.
*/