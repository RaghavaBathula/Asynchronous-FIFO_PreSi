/*6.5 rptr_empty.sv - Read pointer & empty generation logic
This module encloses all of the FIFO logic that is generated within the read clock domain (except synchronizers).
The read pointer is a dual n-bit Gray code counter. The n-bit pointer ( rptr ) is passed to the write clock domain
through the sync_r2w module. The (n-1)-bit pointer ( raddr ) is used to address the FIFO buffer.
The FIFO empty output is registered and is asserted on the next rising rclk edge when the next rptr value equals
the synchronized wptr value. All module outputs are registered for simplified synthesis using time budgeting. This
module is entirely synchronous to the rclk for simplified static timing analysis.
*/
module rptr_empty #(parameter ADDRSIZE = 9)
 (output reg rempty,
 output [ADDRSIZE-1:0] raddr,
 output reg [ADDRSIZE :0] rptr,
 input [ADDRSIZE :0] rq2_wptr,
 input rinc, rclk, rrst_n);
 reg [ADDRSIZE:0] rbin;
 wire [ADDRSIZE:0] rgraynext, rbinnext;
 //-------------------
 // GRAYSTYLE2 pointer
 //-------------------
 always @(posedge rclk or negedge rrst_n)
 if (!rrst_n) {rbin, rptr} <= 0;
 else {rbin, rptr} <= {rbinnext, rgraynext};
 // Memory read-address pointer (okay to use binary to address memory)
 assign raddr = rbin[ADDRSIZE-1:0];
 assign rbinnext = rbin + (rinc & ~rempty);
 assign rgraynext = (rbinnext>>1) ^ rbinnext;
 //---------------------------------------------------------------
 // FIFO empty when the next rptr == synchronized wptr or on reset
 //---------------------------------------------------------------
 assign rempty_val = (rgraynext == rq2_wptr);
 always @(posedge rclk or negedge rrst_n)
 if (!rrst_n) rempty <= 1'b1;
 else rempty <= rempty_val;
endmodule