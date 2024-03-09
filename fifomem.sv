/*
6.2 fifomem.sv - FIFO memory buffer
The FIFO memory buffer is typically an instantiated ASIC or FPGA dual-port, synchronous memory device. The
memory buffer could also be synthesized to ASIC or FPGA registers using the RTL code in this module.
About an instantiated vendor RAM versus a Verilog-declared RAM, the Synopsys DesignWare team did internal
analysis and found that for sizes up to 256 bits, there is no lost area or performance using the Verilog-declared
RAM compared to an instantiated vendor RAM[4].
If a vendor RAM is instantiated, it is highly recommended that the instantiation be done using named port
connections.
*/

module fifomem #(parameter DATASIZE = 8, // Memory data word width
 parameter ADDRSIZE = 9) // Number of mem address bits
 (output [DATASIZE-1:0] rdata, //Data_out
 input [DATASIZE-1:0] wdata,	//Data_in
 input [ADDRSIZE-1:0] waddr, raddr,
 input wclken, wfull, wclk);
 
 `ifdef VENDORRAM
 // instantiation of a vendor's dual-port RAM
 vendor_ram mem (.dout(rdata), .din(wdata),
 .waddr(waddr), .raddr(raddr),
 .wclken(wclken),
 .wclken_n(wfull), .clk(wclk));
 `else
 // RTL Verilog memory model
 localparam DEPTH = 1<<ADDRSIZE;    //2^^9?
 reg [DATASIZE-1:0] mem [0:DEPTH-1];
 assign rdata = mem[raddr];            //Shouldn't we check the empty codn here?
 always @(posedge wclk)
 if (wclken && !wfull) mem[waddr] <= wdata;   //why wclken?
 `endif
 
endmodule