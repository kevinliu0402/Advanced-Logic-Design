module sync_w2r #(parameter ADDRSIZE = 4) (
    output reg [ADDRSIZE:0] rptr_sync, // Gray-coded write pointer synced to read
    input      [ADDRSIZE:0] wptr,      // Gray-coded write pointer from write
    input                  rclk,
    input                  rrst_n
);
    reg [ADDRSIZE:0] sync1;  //synchronizer register

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            sync1     <= 0;
            rptr_sync <= 0;
        end else begin
            sync1     <= wptr;
            rptr_sync <= sync1;
        end
    end
endmodule