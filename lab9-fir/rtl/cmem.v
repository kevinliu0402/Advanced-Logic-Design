module cmem #(
    parameter MEM_SIZE = 64,
    parameter DATA_WIDTH = 16
)(
    input  wire                   clk,
    // Port A (read port)
    input  wire [$clog2(MEM_SIZE)-1:0] addr_a,
    output reg  [DATA_WIDTH-1:0]      data_out_a,
    // Port B (write port)
    input  wire [$clog2(MEM_SIZE)-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0]      data_in_b,
    input  wire                       we_b
);
    // Memory array for coefficients
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    // Synchronous read (Port A)
    always @(posedge clk) begin
        data_out_a <= mem[addr_a];
    end

    // Synchronous write (Port B)
    always @(posedge clk) begin
        if (we_b) begin
            mem[addr_b] <= data_in_b;
        end
    end
endmodule
