// RISC: Reduced Instruction Set Computer
// RV32I: RISC-V 32-bit Integer instructions
// Single-Cycle: Each instruction completes in one clock cycle

module riscv_top (
    input clk,
    input rst,
    output [6:0] seg,
    output [3:0] an
);

    // Program Counter 
    // On every clock cycle, decides if to jump/branch or go to next instruction
    reg  [31:0] pc;
    wire [31:0] pc_plus4 = pc + 4; // input to PC for normal sequential execution
    wire [31:0] pc_next; // Next instruction address

    always @(posedge clk or posedge rst)
        pc <= rst ? 0 : pc_next;

    // Instruction fetch
    // Act as the ROM (Read Only Memory) for instructions
    // take a 32-bit address (pc) and output the 32-bit instruction at that address
    wire [31:0] instr;
    instr_mem imem (.addr(pc), .instr(instr));

    // Decode fields
    wire [6:0] opcode = instr[6:0]; // Opcode determines the instruction type and operation
    wire [4:0] rd = instr[11:7]; // Destination register address (for R-type and I-type)
    wire [2:0] funct3 = instr[14:12]; // Function code for ALU operations and branch types
    wire [4:0] rs1 = instr[19:15]; // Source register 1 address
    wire [4:0] rs2 = instr[24:20]; // Source register 2 address (for R-type)
    wire [6:0] funct7 = instr[31:25]; // Additional function code for R-type instructions (distinguishes ADD vs SUB)

    // Control signals
    // The control unit takes the opcode and generates signals that control the data path:
    // reg_write: whether to write back to the register file
    // alu_src: whether the second ALU operand is from the register file or immediate
    // mem_write: whether to write to data memory
    // mem_read: whether to read from data memory
    // mem_to_reg: whether to write back ALU result or memory data to register file
    // branch: whether the instruction is a branch (BEQ, BNE, BLT, BGE)
    // jump: whether the instruction is a jump (JAL)
    // jalr: whether the instruction is JALR (jump and link register)
    wire reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, jalr;
    
    // alu_op: specifies the ALU operation type
    wire [1:0] alu_op; 

    control_unit ctrl (
        .opcode(opcode),.reg_write(reg_write), .alu_src(alu_src),
        .mem_write(mem_write), .mem_read(mem_read), .mem_to_reg(mem_to_reg),
        .branch(branch), .jump(jump), .jalr(jalr), .alu_op(alu_op)
    );

    // Register file
    // handles the storage and retrieval of register values
    // rs1, rs2 for reading; rd for writing
    wire [31:0] read_data1, read_data2, write_data;
    register_file regfile (
        .clk(clk), .reg_write(reg_write),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1), .read_data2(read_data2)
    );

    // Immediate generator
    // takes the instruction and extracts the immediate value 
    // based on the instruction type (I-type, S-type, B-type, U-type, J-type)
    wire [31:0] imm_ext;
    imm_gen igen (.instr(instr), .imm_ext(imm_ext));

    // ALU (Arithmetic Logic Unit)
    // Performs arithmetic and logical operations based on the control signals
    // alu_control unit decodes the ALU operation from alu_op, funct3, and funct7
    // alu takes two operands (from register file or immediate) and produces a result and zero flag
    wire [3:0] alu_ctrl;
    alu_control alu_ctrl_unit (.alu_op(alu_op), .funct3(funct3), .funct7(funct7), .alu_ctrl(alu_ctrl));

    // AUIPC (Add Upper Immediate to PC)
    // auipc is used to convert a 12 bit immediate into a 32-bit address by adding it to the current PC
    // for operand A, use PC for AUIPC, otherwise use read_data1 from register file
    // for operand B, use either the immediate (for I-type) or the second register value (for R-type)
    wire [31:0] alu_a = (opcode == 7'b0010111) ? pc : read_data1; 
    wire [31:0] alu_b = alu_src ? imm_ext : read_data2;
    wire [31:0] alu_result;
    wire zero; // Zero flag for branch decisions
    alu main_alu (.a(alu_a), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(zero));

    // Branch decision
    // take the branch control signals and ALU results to determine if a branch should be taken
    // if branch is taken, pc_next will be the branch target
    // otherwise, it will be pc_plus4
    wire pc_branch;
    branch_control bctrl (
        .branch(branch), .zero(zero),
        .alu_result(alu_result), .funct3(funct3), .pc_branch(pc_branch)
    );

    // PC next
    // For jumps and branches, calculate the target address
    // otherwise, go to the next sequential instruction (pc + 4)
    wire [31:0] branch_target = pc + imm_ext;
    wire [31:0] jalr_target   = (read_data1 + imm_ext) & ~32'h1;

    // jalr: target address is computed by adding the immediate to the value in rs1, and then clearing the least significant bit 
    // jump (JAL): target address is computed by adding the immediate to the current PC
    // branch: target address is computed by adding the immediate to the current PC, but only taken if the branch condition is met 
    assign pc_next = jalr ? jalr_target :
                     jump ? branch_target :
                     pc_branch ? branch_target : pc_plus4;

    // Data memory
    // Acts as the RAM for load/store instructions
    // Takes an address and either reads data from that address or writes data to that address based on the control signals
    wire [31:0] mem_read_data;
    data_mem dmem (
        .clk(clk), .mem_write(mem_write), .mem_read(mem_read),
        .addr(alu_result), .write_data(read_data2), .read_data(mem_read_data)
    );

    // Write-back
    // Determines what data to write back to the register file based on the instruction type
    assign write_data = (jump || jalr) ? pc_plus4     : // For JAL and JALR, write the return address (PC + 4) to rd
                        mem_to_reg ? mem_read_data : alu_result; // For load instructions, write memory data; otherwise, write ALU result

    // Display x10 (a0) lower 16 bits on 7-segment
    seg7_display disp (
        .clk(clk), .rst(rst),
        .data(regfile.registers[10][15:0]), 
        .seg(seg), .an(an)
    );

endmodule
