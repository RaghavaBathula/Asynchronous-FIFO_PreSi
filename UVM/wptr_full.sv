/*
6.6 wptr_full.sv - Write pointer & full generation logic
This module encloses all of the FIFO logic that is generated within the write clock domain (except synchronizers).
The write pointer is a dual n-bit Gray code counter. The n-bit pointer ( wptr ) is passed to the read clock domain
through the sync_w2r module. The (n-1)-bit pointer ( waddr ) is used to address the FIFO buffer.
The FIFO full output is registered and is asserted on the next rising wclk edge when the next modified wgnext
value equals the synchronized and modified wrptr2 value (except MSBs). All module outputs are registered for
simplified synthesis using time budgeting. This module is entirely synchronous to the wclk for simplified static
timing analysis.
*/

module wptr_full #(parameter ADDRSIZE = 9)
 (output reg wfull,
 output [ADDRSIZE-1:0] waddr,
 output reg [ADDRSIZE :0] wptr,
 input [ADDRSIZE :0] wq2_rptr,
 input winc, wclk, wrst_n);
 reg [ADDRSIZE:0] wbin;
 wire [ADDRSIZE:0] wgraynext, wbinnext;
 // GRAYSTYLE2 pointer
 always @(posedge wclk or negedge wrst_n)
 if (!wrst_n) {wbin, wptr} <= 0;
 else {wbin, wptr} <= {wbinnext, wgraynext};
 // Memory write-address pointer (okay to use binary to address memory)
 assign waddr = wbin[ADDRSIZE-1:0];
 assign wbinnext = wbin + (winc & ~wfull);
 assign wgraynext = (wbinnext>>1) ^ wbinnext;
 //------------------------------------------------------------------
 // Simplified version of the three necessary full-tests:
 // assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
 // (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
 // (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
 //------------------------------------------------------------------
 assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
 wq2_rptr[ADDRSIZE-2:0]});
 always @(posedge wclk or negedge wrst_n)
 if (!wrst_n) wfull <= 1'b0;
 else wfull <= wfull_val;
endmodule