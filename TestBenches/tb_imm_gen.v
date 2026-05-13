`timescale 1ns / 1ps

module imm_gen_tb();

    // Inputs
    reg [31:0] instr;

    // Outputs
    wire [31:0] imm_ext;

    // Instantiate UUT
    imm_gen uut (
        .instr(instr), 
        .imm_ext(imm_ext)
    );

    wire [6:0]  opcode_monitor = instr[6:0];
    wire signed [31:0] signed_imm = imm_ext;

    initial begin
        $display("Starting Immediate Generator Test...");
        $monitor("Time=%0t | Opcode=%b | Instr=%h | ImmOut=%h (%d)", 
                $time, opcode_monitor, instr, imm_ext, signed_imm);

        // Test 1: I-type (ADDI x1, x2, -5)
        // imm[11:0] = 12'hFFB (-5), rs1=2, f3=0, rd=1, op=0010011
        instr = 32'hFFB10093; #10;

        // Test 2: S-type (SW x5, 4(x6))
        // imm[11:5]=0, rs2=5, rs1=6, f3=2, imm[4:0]=4, op=0100011
        instr = 32'h00532223; #10;

        // Test 3: B-type (BEQ x1, x2, -4)
        // imm[12]=1, imm[11]=1, imm[10:5]=3F, imm[4:1]=1E, op=1100011
        // Instruction for branch -4 bytes (offset)
        instr = 32'hFE208EE3; #10;

        // Test 4: U-type (LUI x1, 0x12345)
        // imm[31:12]=0x12345, rd=1, op=0110111
        instr = 32'h123450B7; #10;

        // Test 5: J-type (e.g., JAL x1, +2048)
        // Opcode 1101111
        instr = 32'h000000EF; 
        instr[31:12] = 20'h00800; // Custom offset for J-type test
        #10;

        $display("Immediate Generator Test Completed.");
        $finish;
    end
      
    initial begin
        $dumpfile("imm_gen_op.vcd");
        $dumpvars(0, imm_gen_tb);
    end
endmodule

/*
Starting Immediate Generator Test...
VCD info: dumpfile imm_gen_op.vcd opened for output.
Time=0 | Opcode=0010011 | Instr=ffb10093 | ImmOut=fffffffb (         -5)
Time=10000 | Opcode=0100011 | Instr=00532223 | ImmOut=00000004 (          4)
Time=20000 | Opcode=1100011 | Instr=fe208ee3 | ImmOut=fffffffc (         -4)
Time=30000 | Opcode=0110111 | Instr=123450b7 | ImmOut=12345000 (  305418240)
Time=40000 | Opcode=1101111 | Instr=008000ef | ImmOut=00000008 (          8)
Immediate Generator Test Completed.
*/