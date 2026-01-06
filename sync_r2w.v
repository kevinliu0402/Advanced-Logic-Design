module sync_r2w #(parameter ADDRSIZE = 4) (
    output reg [ADDRSIZE:0] wptr_sync, // Gray-coded read pointer synced to write
    input      [ADDRSIZE:0] rptr,      // Gray-coded read pointer from read
    input                  wclk,
    input                  wrst_n
);
    reg [ADDRSIZE:0] sync1;  // synchronizer register

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            sync1     <= 0;
            wptr_sync <= 0;
        end else begin
            sync1     <= rptr;
            wptr_sync <= sync1;
        end
    end
endmodule