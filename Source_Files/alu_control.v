module alu_control (
    input [1:0] alu_op, // defines the type of instruction 
    input [2:0] funct3, // defines the specific operation for R-type and I-type instructions
    input [6:0] funct7, // differentiates between certain R-type instructions (ADD vs SUB)
    output reg [3:0] alu_ctrl // final control signal for the ALU 
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // Load/Store: ADD
            2'b01: alu_ctrl = 4'b0110; // Branch: SUB (for BEQ/BNE), BLT/BGE handled in branch_control
            2'b11: alu_ctrl = 4'b1101; // LUI: pass B
            2'b10: case (funct3) // R-type / I-type
                3'b000: alu_ctrl = (funct7[5]) ? 4'b0110 : 4'b0010; // SUB/ADD
                3'b001: alu_ctrl = 4'b1011; // SLL
                3'b010: alu_ctrl = 4'b0111; // SLT
                3'b011: alu_ctrl = 4'b1100; // SLTU
                3'b100: alu_ctrl = 4'b1000; // XOR
                3'b101: alu_ctrl = (funct7[5]) ? 4'b1010 : 4'b1001; // SRA/SRL
                3'b110: alu_ctrl = 4'b0001; // OR
                3'b111: alu_ctrl = 4'b0000; // AND
                default: alu_ctrl = 4'b0010; // Default to ADD for unknown funct3
            endcase
            default: alu_ctrl = 4'b0010; // Default to ADD for unknown alu_op
        endcase
    end

endmodule
