`timescale 1ns/1ps
module fifo #(parameter DSIZE = 8, parameter ASIZE = 4) (
    input                  clk1,   
    input                  wrst_n, 
    input                  clk2,   
    input                  rrst_n, 
    input                  winc,   // Write enable
    input                  rinc,   // Read enable 
    input  [DSIZE-1:0]     wdata,  
    output [DSIZE-1:0]     rdata,  
    output                 wfull,  // FIFO full flag
    output                 rempty  // FIFO empty flag
);
    // Internal signals for Gray-coded pointers and synchronized versions
    wire [ASIZE:0] wptr;      // Gray-coded write
    wire [ASIZE:0] rptr;      // Gray-coded read
    wire [ASIZE:0] wrptr2;    // Synchronized Gray-coded read
    wire [ASIZE:0] rwptr2;    // Synchronized Gray-coded write
    wire [ASIZE-1:0] waddr;   
    wire [ASIZE-1:0] raddr;   

    // FIFO memory 
    fifomem #(.DATASIZE(DSIZE), .ADDRSIZE(ASIZE)) mem_inst (
        .rdata   (rdata),
        .wdata   (wdata),
        .waddr   (waddr),
        .raddr   (raddr),
        .wclken  (winc & ~wfull), // enable write only when FIFO not full
        .wclk    (clk1)
    );

    // Write-side pointer and FULL flag
    wptr_full #(.ADDRSIZE(ASIZE)) wptr_full_inst (
        .wfull   (wfull),
        .waddr   (waddr),
        .wptr    (wptr),
        .wrptr2  (wrptr2),
        .winc    (winc),
        .wclk    (clk1),
        .wrst_n  (wrst_n)
    );

    // Read-side pointer and EMPTY flag
    rptr_empty #(.ADDRSIZE(ASIZE)) rptr_empty_inst (
        .rempty  (rempty),
        .raddr   (raddr),
        .rptr    (rptr),
        .rwptr2  (rwptr2),
        .rinc    (rinc),
        .rclk    (clk2),
        .rrst_n  (rrst_n)
    );

    // Synchronizer for read into write
    sync_r2w #(.ADDRSIZE(ASIZE)) sync_r2w_inst (
        .wptr_sync (wrptr2), // synchronized read-pointer (Gray) in write domain
        .rptr      (rptr),
        .wclk      (clk1),
        .wrst_n    (wrst_n)
    );

    // Synchronizer for write into read
    sync_w2r #(.ADDRSIZE(ASIZE)) sync_w2r_inst (
        .rptr_sync (rwptr2), // synchronized write-pointer (Gray) in read domain
        .wptr      (wptr),
        .rclk      (clk2),
        .rrst_n    (rrst_n)
    );
endmodule