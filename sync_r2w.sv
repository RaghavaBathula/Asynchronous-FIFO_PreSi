/*
6.3 sync_r2w.sv - Read-domain to write-domain synchronizer
This is a simple synchronizer module, used to pass an n-bit pointer from the read clock domain to the write clock
domain, through a pair of registers that are clocked by the FIFO write clock. Notice the simplicity of the always
block that concatenates the two registers together for reset and shifting. The synchronizer always block is only three
lines of code.
All module outputs are registered for simplified synthesis using time budgeting. All outputs of this module are
entirely synchronous to the wclk and all asynchronous inputs to this module are from the rclk domain with all
signals named using an “r” prefix, making it easy to set a false path on all “r*” signals for simplified static timing
analysis.
*/

module sync_r2w #(parameter ADDRSIZE = 9)
 (output reg [ADDRSIZE:0] wq2_rptr,
 input [ADDRSIZE:0] rptr,
 input wclk, wrst_n);
 reg [ADDRSIZE:0] wq1_rptr;
 always @(posedge wclk or negedge wrst_n)
 if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
 else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule