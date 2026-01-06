module rptr_empty #(parameter ADDRSIZE = 4) (
    output reg                rempty,   
    output     [ADDRSIZE-1:0] raddr,    
    output reg [ADDRSIZE:0]   rptr,     
    input      [ADDRSIZE:0]   rwptr2,   
    input                     rinc,     
    input                     rclk,
    input                     rrst_n
);
    reg [ADDRSIZE:0] rbin;    // binary value of read pointer
    reg [ADDRSIZE:0] rbnext;  // next binary pointer
    reg [ADDRSIZE:0] rgnext;  // next Gray-coded pointer
    reg             raddrmsb; // extra bit

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr     <= 0;
            raddrmsb <= 0;
        end else begin
            rptr     <= rgnext;
            raddrmsb <= rgnext[ADDRSIZE] ^ rgnext[ADDRSIZE-1];
        end
    end

    integer j;
    always @(*) begin
        // Convert Gray-coded current pointer to binary
        for (j = 0; j <= ADDRSIZE; j = j + 1) begin
            rbin[j] = ^(rptr >> j);
        end
        // Determine next binary pointer
        if (!rempty)
            rbnext = rbin + (rinc ? 1 : 0);
        else
            rbnext = rbin;
        // Convert next binary pointer to Gray
        rgnext = (rbnext >> 1) ^ rbnext;
    end

    // Derive binary read address
    assign raddr = {raddrmsb, rptr[ADDRSIZE-2:0]};

    // EMPTY flag generation (registered)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rgnext == rwptr2);
        end
    end
endmodule