//BFM/Interface

interface intf(input logic wclk, wrst_n, rclk, rrst_n);

logic [7:0] rdata;
logic wfull;
logic rempty;
logic [7:0] wdata;
logic winc;
logic rinc;

//Driver CB
clocking drv_cb@(posedge wclk);
	default input #1 output #1;
	output wdata;
	output winc;
endclocking


//Driver modport
modport drv_mp(clocking drv_cb);

endinterface: intf