`timescale 1ns / 1ps

module branch_control_tb();

    // Inputs
    reg branch;
    reg zero;
    reg [31:0] alu_result;
    reg [2:0] funct3;

    // Output
    wire pc_branch;

    // Instantiate UUT
    branch_control uut (
        .branch(branch),
        .zero(zero),
        .alu_result(alu_result),
        .funct3(funct3),
        .pc_branch(pc_branch)
    );

    initial begin
        // Initialize
        branch = 0; zero = 0; alu_result = 0; funct3 = 0;

        $display("Starting Branch Control Test...");
        $monitor("Time=%0t | BranchEn=%b | F3=%b | Zero=%b | ALU_LSB=%b | TAKEN=%b", 
                 $time, branch, funct3, zero, alu_result[0], pc_branch);

        #10;

        // Case 1: Branch signal is LOW 
        // Even if zero is 1, pc_branch should stay 0.
        branch = 0; funct3 = 3'b000; zero = 1; 
        #10;

        // Case 2: BEQ (funct3 = 000) 
        branch = 1; zero = 1; #10; // Should take branch
        zero = 0; #10;             // Should NOT take branch

        // Case 3: BNE (funct3 = 001) 
        funct3 = 3'b001; zero = 0; #10; // Should take branch
        zero = 1; #10;                  // Should NOT take branch

        // Case 4: BLT (funct3 = 100) 
        // Relies on ALU result[0] being 1 (True)
        funct3 = 3'b100; alu_result = 32'd1; #10; // Should take branch
        alu_result = 32'd0; #10;                  // Should NOT take branch

        // Case 5: BGE (funct3 = 101) 
        // Relies on ALU result[0] being 0 (meaning A is NOT less than B)
        funct3 = 3'b101; alu_result = 32'd0; #10; // Should take branch
        alu_result = 32'd1; #10;                  // Should NOT take branch

        // Case 6: BLTU (funct3 = 110) 
        funct3 = 3'b110; alu_result = 32'd1; #10; // Should take branch
        
        // Case 7: BGEU (funct3 = 111) 
        funct3 = 3'b111; alu_result = 32'd0; #10; // Should take branch

        $display("Branch Control Test Completed.");
        $finish;
    end

    initial begin
        $dumpfile("branch_control_op.vcd");
        $dumpvars(0, branch_control_tb);
    end

endmodule

/* 
Time=0 | BranchEn=0 | F3=000 | Zero=0 | ALU_LSB=0 | TAKEN=0
Time=10000 | BranchEn=0 | F3=000 | Zero=1 | ALU_LSB=0 | TAKEN=0
Time=20000 | BranchEn=1 | F3=000 | Zero=1 | ALU_LSB=0 | TAKEN=1
Time=30000 | BranchEn=1 | F3=000 | Zero=0 | ALU_LSB=0 | TAKEN=0
Time=40000 | BranchEn=1 | F3=001 | Zero=0 | ALU_LSB=0 | TAKEN=1
Time=50000 | BranchEn=1 | F3=001 | Zero=1 | ALU_LSB=0 | TAKEN=0
Time=60000 | BranchEn=1 | F3=100 | Zero=1 | ALU_LSB=1 | TAKEN=1
Time=70000 | BranchEn=1 | F3=100 | Zero=1 | ALU_LSB=0 | TAKEN=0
Time=80000 | BranchEn=1 | F3=101 | Zero=1 | ALU_LSB=0 | TAKEN=1
Time=90000 | BranchEn=1 | F3=101 | Zero=1 | ALU_LSB=1 | TAKEN=0
Time=100000 | BranchEn=1 | F3=110 | Zero=1 | ALU_LSB=1 | TAKEN=1
Time=110000 | BranchEn=1 | F3=111 | Zero=1 | ALU_LSB=0 | TAKEN=1
Branch Control Test Completed.
*/