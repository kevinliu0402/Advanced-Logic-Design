module reg_file #(
    parameter DEPTH = 64,
    parameter WIDTH = 16
)(
    input  wire                   clk,
    input  wire                   we,        // write enable
    input  wire [$clog2(DEPTH)-1:0] waddr,    // write address
    input  wire [WIDTH-1:0]       wdata,    // data to write
    input  wire [$clog2(DEPTH)-1:0] raddr,    // read address
    output reg  [WIDTH-1:0]       rdata     // data read out
);
    // Register array for intermediate values
    reg [WIDTH-1:0] regs [0:DEPTH-1];

    // On each clock, perform write and read
    always @(posedge clk) begin
        if (we) begin
            regs[waddr] <= wdata;
        end
        rdata <= regs[raddr];
    end
endmodule
