// Immediate Generator
module imm_gen (
    input [31:0] instr,
    output reg [31:0] imm_ext
);
    // Generate the immediate value based on the instruction type
    // TYPES:
    // I-type: arithmetic, load, jalr
    // S-type: store
    // B-type: branch
    // U-type: lui, auipc
    // J-type: jal
    always @(*) begin
        case (instr[6:0])
            7'b0010011, // I-type and jalr 
            7'b0000011, // I-type load
            7'b1100111: imm_ext = {{20{instr[31]}}, instr[31:20]}; // I-type
            7'b0100011: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
            7'b1100011: imm_ext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            7'b0110111, // U-type and lui
            7'b0010111: imm_ext = {instr[31:12], 12'b0}; // U-type
            7'b1101111: imm_ext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type
            default:    imm_ext = 0;
        endcase
    end

endmodule
