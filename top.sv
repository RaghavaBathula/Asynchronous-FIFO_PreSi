`include "interface.sv"
`include "test.sv"

module testbench_top;

logic wclk='0, wrst_n;
logic rclk, rrst_n;

always #3ns wclk = ~wclk;

initial 
begin
	  wrst_n = 0;			//rst applied
	  #5 wrst_n = 1;
 end


intf intf1(wclk, wrst_n, rclk, rrst_n);

//test test1(intf1);
test test1;

async_fifo1 DUT
(intf1.rdata,
 intf1.wfull,
 intf1.rempty,
 intf1.wdata,
 intf1.winc, intf1.wclk, intf1.wrst_n,
 intf1.rinc, intf1.rclk, intf1.rrst_n);
 
initial
begin
	test1 = new(intf1);
	test1.build_and_run();
end
 
endmodule