//`timescale 1ns/1ps
import my_pkg::*;
`include "uvm_macros.svh"
`include "asyncf_if.sv"
`include "base_test.sv"

`include "asyncf_case0.sv"

`include "asyncf_case1.sv"

import uvm_pkg::*;

module top_tb;

reg wclk;
reg rclk;
reg wrst_n;
reg rrst_n;
reg rinc; //not needed

up_if up_if(wclk, wrst_n);	//write interface
down_if down_if(rclk, rrst_n); //read interface




async_fifo1 async_fifo(
                .rdata(down_if.rdata),
                .wfull(up_if.wfull),
                .rempty(down_if.rempty),
                .wdata(up_if.wdata),
                .winc(up_if.winc), 
                .wclk(wclk), 
                .wrst_n(wrst_n),
                .rinc(down_if.rinc), 
                .rclk(rclk), 
                .rrst_n(rrst_n)
            );

//always @(*) begin
//    if (~down_if.rempty)
//    rinc = 1;
//    else
//    rinc = 0;
//    end


initial begin
   wclk = 0;
   forever begin
      #3 wclk = ~wclk;	//3ns
   end
end

initial begin
   rclk = 0;
   forever begin
      #4.44 rclk = ~rclk;	//4.44ns
   end
end

initial begin
   wrst_n = 1'b0;	//reset enabled
   rrst_n = 1'b0;
   #100;
   wrst_n = 1'b1;	//reset disabled
   rrst_n = 1'b1;
end

initial begin
   run_test("asyncf_case0");		//to run the phases
end

initial begin

   //passing(setting) write interface handle to write driver.
   uvm_config_db#(virtual up_if)::set(null, "uvm_test_top.env.i_agt.drv", "up_if", up_if);
   
   //passing(setting) write interface handle to write monitor.
   uvm_config_db#(virtual up_if)::set(null, "uvm_test_top.env.i_agt.mon", "up_if", up_if);
   
   //passing(setting) read interface handle to read driver.
   uvm_config_db#(virtual down_if)::set(null, "uvm_test_top.env.o_agt.drv", "down_if", down_if);
   
   //passing(setting) read interface handle to read monitor.
   uvm_config_db#(virtual down_if)::set(null, "uvm_test_top.env.o_agt.mon", "down_if", down_if);
end

// fsdb
initial begin
	
	$dumpfile("dump.vcd");
	$dumpvars;
end

endmodule
