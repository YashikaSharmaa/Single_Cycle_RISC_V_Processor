`timescale 1ns / 1ps

module control_unit_tb();

    // Inputs
    reg [6:0] opcode;

    // Outputs
    wire reg_write;
    wire alu_src;
    wire mem_write;
    wire mem_read;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire jalr;
    wire [1:0] alu_op;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .opcode(opcode), 
        .reg_write(reg_write), 
        .alu_src(alu_src), 
        .mem_write(mem_write), 
        .mem_read(mem_read), 
        .mem_to_reg(mem_to_reg), 
        .branch(branch), 
        .jump(jump), 
        .jalr(jalr), 
        .alu_op(alu_op)
    );

    initial begin
        $display("Starting Control Unit Test...");
        $display("Opcode  | RW | AS | MW | MR | M2R| BR | JP | JR | ALUOp");

        // R-type
        opcode = 7'b0110011; #10;
        check_signals("R-type");

        // I-arithmetic
        opcode = 7'b0010011; #10;
        check_signals("I-type");

        // Load 
        opcode = 7'b0000011; #10;
        check_signals("Load  ");

        // Store 
        opcode = 7'b0100011; #10;
        check_signals("Store ");

        // Branch 
        opcode = 7'b1100011; #10;
        check_signals("Branch");

        // LUI 
        opcode = 7'b0110111; #10;
        check_signals("LUI   ");

        // JAL 
        opcode = 7'b1101111; #10;
        check_signals("JAL   ");

        // JALR 
        opcode = 7'b1100111; #10;
        check_signals("JALR  ");

        $display("");
        $display("Control Unit Test Completed.");
        $finish;
    end

    // Task to print signals in a clean format
    task check_signals(input [47:0] label);
        begin
            $display("%b | %b  | %b  | %b  | %b  | %b  | %b  | %b  | %b  | %b   <- %s", 
                     opcode, reg_write, alu_src, mem_write, mem_read, 
                     mem_to_reg, branch, jump, jalr, alu_op, label);
        end
    endtask

    initial begin
        $dumpfile("control_unit_op.vcd");
        $dumpvars(0, control_unit_tb);
    end
      
endmodule

/* 
VCD OUTPUT:
Starting Control Unit Test...
Opcode  | RW | AS | MW | MR | M2R| BR | JP | JR | ALUOp
VCD info: dumpfile control_unit_op.vcd opened for output.
0110011 | 1  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 10   <- R-type
0010011 | 1  | 1  | 0  | 0  | 0  | 0  | 0  | 0  | 10   <- I-type
0000011 | 1  | 1  | 0  | 1  | 1  | 0  | 0  | 0  | 00   <- Load  
0100011 | 0  | 1  | 1  | 0  | 0  | 0  | 0  | 0  | 00   <- Store 
1100011 | 0  | 0  | 0  | 0  | 0  | 1  | 0  | 0  | 01   <- Branch
0110111 | 1  | 1  | 0  | 0  | 0  | 0  | 0  | 0  | 11   <- LUI   
1101111 | 1  | 0  | 0  | 0  | 0  | 0  | 1  | 0  | 00   <- JAL   
1100111 | 1  | 1  | 0  | 0  | 0  | 0  | 0  | 1  | 00   <- JALR 
*/