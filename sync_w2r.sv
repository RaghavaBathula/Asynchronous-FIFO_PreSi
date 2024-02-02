/*
6.4 sync_w2r.v - Write-domain to read-domain synchronizer
This is a simple synchronizer module, used to pass an n-bit pointer from the write clock domain to the read clock
domain, through a pair of registers that are clocked by the FIFO read clock. Notice the simplicity of the always
block that concatenates the two registers together for reset and shifting. The synchronizer always block is only three
lines of code.
All module outputs are registered for simplified synthesis using time budgeting. All outputs of this module are
entirely synchronous to the rclk and all asynchronous inputs to this module are from the wclk domain with all
signals named using an “w” prefix, making it easy to set a false path on all “w*” signals for simplified static timing
analysis.
*/

module sync_w2r #(parameter ADDRSIZE = 9)
 (output reg [ADDRSIZE:0] rq2_wptr,
 input [ADDRSIZE:0] wptr,
 input rclk, rrst_n);
 reg [ADDRSIZE:0] rq1_wptr;
 always @(posedge rclk or negedge rrst_n)
 if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
 else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule