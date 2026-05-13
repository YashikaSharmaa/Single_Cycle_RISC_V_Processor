// decodes the opcode to generate control signals for the datapath
module control_unit (
    input [6:0] opcode, // bits [6:0] of the instruction
    output reg reg_write, // 1=write to rd, 0=no write
    output reg alu_src, // 0=second operand from rs2, 1=second operand is immediate
    output reg mem_write, // 1=write to memory, 0=no write
    output reg mem_read, // 1=read from memory, 0=no read
    output reg mem_to_reg, // 1=write memory data to rd, 0=write ALU result to rd
    output reg branch, // 1=branch instruction, 0=no branch
    output reg jump, // 1=jump instruction (JAL), 0=no jump
    output reg jalr, // 1=jump instruction (JALR), 0=no jump
    output reg [1:0] alu_op
);

    always @(*) begin
        {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, jalr} = 8'b0;
        alu_op = 2'b00;

        case (opcode)
            7'b0110011: begin reg_write=1; alu_op=2'b10; end  // R-type (arithmetic and logic)
            7'b0010011: begin reg_write=1; alu_src=1; alu_op=2'b10; end // I-arith (immediate arithmetic and logic)
            7'b0000011: begin reg_write=1; alu_src=1; mem_read=1; mem_to_reg=1; end  // Load
            7'b0100011: begin alu_src=1; mem_write=1; end                            // Store
            7'b1100011: begin branch=1; alu_op=2'b01; end                            // Branch
            7'b0110111: begin reg_write=1; alu_src=1; alu_op=2'b11; end              // LUI (Load Upper Immediate)
            7'b0010111: begin reg_write=1; alu_src=1; alu_op=2'b10; end              // AUIPC (Add Upper Immediate to PC)
            7'b1101111: begin reg_write=1; jump=1; end                               // JAL (Jump and Link)
            7'b1100111: begin reg_write=1; alu_src=1; jalr=1; end                    // JALR (Jump and Link Register)
        endcase
    end

endmodule
