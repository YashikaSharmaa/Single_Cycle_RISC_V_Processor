// Simple data memory module 

module data_mem #(parameter MEM_SIZE = 256) (
    input clk,
    input mem_write, mem_read,
    input [31:0] addr, write_data,
    output [31:0] read_data
);

    reg [31:0] mem [0:MEM_SIZE-1]; // 32-bit wide memory with MEM_SIZE entries
    integer i;
    // Initialize memory to zero
    initial for (i = 0; i < MEM_SIZE; i = i+1) mem[i] = 0; 

    // Write to memory on the rising edge of the clock if mem_write is asserted
    always @(posedge clk)
        if (mem_write) mem[addr[31:2]] <= write_data;

    // Read from memory combinationally if mem_read is asserted
    assign read_data = mem_read ? mem[addr[31:2]] : 0;

endmodule
