module wptr_full #(parameter ADDRSIZE = 4) (
    output reg                wfull,    // registered FULL flag
    output     [ADDRSIZE-1:0] waddr,    // binary write address
    output reg [ADDRSIZE:0]   wptr,     // Gray-coded write pointer 
    input      [ADDRSIZE:0]   wrptr2,   // synchronized read pointer
    input                     winc,     // write enable
    input                     wclk,
    input                     wrst_n
);
    reg [ADDRSIZE:0] wbin;    // binary value of write pointer
    reg [ADDRSIZE:0] wbnext;  // next binary pointer
    reg [ADDRSIZE:0] wgnext;  // next Gray-coded pointer
    reg             waddrmsb; // extra bit

    // Update write pointer on write clock
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr     <= 0;
            waddrmsb <= 0;
        end else begin
            wptr     <= wgnext;
            // Compute MSB of binary address for memory
            waddrmsb <= wgnext[ADDRSIZE] ^ wgnext[ADDRSIZE-1];
        end
    end

    integer i;
    
    always @(*) begin
        // Convert Gray-coded current pointer to binary
        for (i = 0; i <= ADDRSIZE; i = i + 1) begin
            wbin[i] = ^(wptr >> i);
        end
        // Determine next binary pointer
        if (!wfull)
            wbnext = wbin + (winc ? 1 : 0);
        else
            wbnext = wbin;
        // Convert next binary pointer to Gray code
        wgnext = (wbnext >> 1) ^ wbnext;
    end

    // Derive binary write address
    assign waddr = {waddrmsb, wptr[ADDRSIZE-2:0]};

    // FULL flag
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 1'b0;
        end else begin
            wfull <= ( (wgnext[ADDRSIZE] != wrptr2[ADDRSIZE]) &&      // MSBs differ
                       ((wgnext[ADDRSIZE] ^ wgnext[ADDRSIZE-1]) ==    // second MSB (binary) same
                        (wrptr2[ADDRSIZE] ^ wrptr2[ADDRSIZE-1])) &&
                       (wgnext[ADDRSIZE-2:0] == wrptr2[ADDRSIZE-2:0]) );
        end
    end
endmodule