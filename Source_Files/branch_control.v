// decides if a branch should be taken based on the branch type and ALU results
// brach means to jump to a different instruction address if a certain condition is met 
module branch_control (
    input branch,
    input zero,
    input [31:0] alu_result,
    input [2:0] funct3,
    output reg pc_branch
);

    always @(*) begin
        pc_branch = 1'b0;
        if (branch) begin
            case (funct3)
                3'b000: pc_branch = zero; // BEQ (branch if equal)
                3'b001: pc_branch = ~zero; // BNE (branch if not equal)
                3'b100: pc_branch = alu_result[0]; // BLT  (branch if less than, signed)
                3'b101: pc_branch = ~alu_result[0]; // BGE  (branch if greater than or equal, signed)
                3'b110: pc_branch = alu_result[0]; // BLTU (branch if less than, unsigned)
                3'b111: pc_branch = ~alu_result[0]; // BGEU (branch if greater than or equal, unsigned)
                default: pc_branch = 1'b0;
            endcase
        end
    end

endmodule
