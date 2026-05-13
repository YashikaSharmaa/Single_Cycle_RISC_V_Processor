// Register file with 32 registers, each 32 bits wide.
module register_file (
    input clk,
    input reg_write, // control signal that enables writing to the register file
    input [4:0] rs1, rs2, rd, // rs1 and rs2 are source register indices, rd is the destination register index
    input [31:0] write_data,
    output [31:0] read_data1, read_data2
);

    reg [31:0] registers [0:31]; 
    integer i;
    // Initialize all registers to 0 at the start of the simulation.
    initial for (i = 0; i < 32; i = i+1) registers[i] = 0; 

    // Write to the register file on the rising edge of the clock if reg_write is given
    always @(posedge clk)
        if (reg_write && rd != 0) registers[rd] <= write_data;

    // Read data from the register file. If rs1 or rs2 is 0, return 0 
    assign read_data1 = (rs1 == 0) ? 0 : registers[rs1];
    assign read_data2 = (rs2 == 0) ? 0 : registers[rs2];

endmodule
