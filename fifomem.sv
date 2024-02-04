//fifomem.sv
module fifomem #(parameter DATASIZE = 32, // Memory data word width
 parameter ADDRSIZE = 9) // Number of mem address bits
 (output [DATASIZE-1:0] rdata, //Data_out
 input [DATASIZE-1:0] wdata,	//Data_in
 input [ADDRSIZE-1:0] waddr, raddr,
 input wclken, wfull, wclk);
 
 
 // RTL Verilog memory model
 localparam DEPTH = 1<<ADDRSIZE;    //2^^9?
 reg [DATASIZE-1:0] mem [0:DEPTH-1];
 assign rdata = mem[raddr];            //Shouldn't we check the empty codn here?
 always @(posedge wclk)
 if (wclken && !wfull) mem[waddr] <= wdata;   //why wclken?

 
endmodule
