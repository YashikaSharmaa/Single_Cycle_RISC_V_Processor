module alu (
    input [31:0] a, b,
    input [3:0] alu_ctrl,
    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a & b; // And
            4'b0001: result = a | b; // OR
            4'b0010: result = a + b; // ADD
            4'b0110: result = a - b; // SUB
            4'b0111: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT (signed comparison)
            4'b1000: result = a ^ b; // XOR
            4'b1001: result = a >> b[4:0]; // SRL (shift right logical)
            4'b1010: result = $signed(a) >>> b[4:0]; // SRA (shift right arithmetic)
            4'b1011: result = a << b[4:0]; // SLL (shift left logical)
            4'b1100: result = (a < b) ? 1 : 0; // SLTU (set less than unsigned)
            4'b1101: result = b; // LUI: pass B (upper immediate)
            default: result = 0; // Default case to handle undefined control signals
        endcase
    end

    assign zero = (result == 0); // Zero flag is set if the result is zero

endmodule
