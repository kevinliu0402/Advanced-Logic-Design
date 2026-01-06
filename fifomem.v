module fifomem #(parameter DATASIZE = 8, parameter ADDRSIZE = 4) (
    output [DATASIZE-1:0] rdata,   // data output for read
    input  [DATASIZE-1:0] wdata,   // data input from write
    input  [ADDRSIZE-1:0] waddr,   
    input  [ADDRSIZE-1:0] raddr,   
    input                 wclken,  
    input                 wclk    
);
    // Memory
    reg [DATASIZE-1:0] mem [0:(1<<ADDRSIZE)-1];

    // Write
    always @(posedge wclk) begin
        if (wclken) 
            mem[waddr] <= wdata;
    end

    // Read
    assign rdata = mem[raddr];
endmodule