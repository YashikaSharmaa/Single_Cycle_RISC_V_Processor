// Instruction memory 
// decodes the instruction address and outputs the instruction at that address from a hex file
// hex file format: each line contains a 32-bit instruction in hexadecimal, without the "0x" prefix
module instr_mem #(parameter MEM_SIZE = 256) (
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] mem [0:MEM_SIZE-1];
    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i+1)
            mem[i] = 32'h00000013; // NOP
        $readmemh("program.hex", mem);
    end
    // The instruction address is word-aligned, so we use bits [31:2] to index the memory
    // word-aligned means that the address is a multiple of 4, so the last two bits are always 0 and can be ignored
    assign instr = mem[addr[31:2]];

endmodule
