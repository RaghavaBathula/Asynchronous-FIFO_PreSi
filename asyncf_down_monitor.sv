`ifndef ASYNCF_DOWN_MONITOR__SV
`define ASYNCF_DOWN_MONITOR__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_down_monitor extends uvm_monitor;

   //Factory Registration
   `uvm_component_utils(asyncf_down_monitor)

   //Creating virtual interface handle for read interface
   virtual down_if down_if;

   //TLM Analysis port helps in broadcasting objects to different components
   uvm_analysis_port #(asyncf_transaction)  ap;
   
   
   //Constructor
   function new(string name = "asyncf_down_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction


   //build_phase definition
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
	  //Getting configuration object from configuration database to get access to virtual interface 
      if(!uvm_config_db#(virtual down_if)::get(this, "", "down_if", down_if))
         `uvm_fatal("asyncf_down_mornitor", "virtual interface must be set for down_if!!!")
		 
	  //Analysis port created
      ap = new("ap", this);
   endfunction


   //run() phases
   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(asyncf_transaction tr);
endclass


//main_phase task definition
task asyncf_down_monitor::main_phase(uvm_phase phase);

   //Local transaction packet
   asyncf_transaction tr;
   while(1) begin
      tr = new("tr");
	  
	  //Collect the read driver driven data via read interface and store it in "tr"
      collect_one_pkt(tr);
	  
	  //Put the transaction "tr" in the analysis port of read monitor "ap" using write method 
	  //to broadcast it to other components
      ap.write(tr);
   end
endtask


//collect_one_pkt task definition
task asyncf_down_monitor::collect_one_pkt(asyncf_transaction tr);
   
   //Wait till the rinc becomes "1" in the interface (wait till the read driver drives the data)
   while(1) begin
      @(posedge down_if.rclk);
      if(down_if.rinc)
		break;
   end
   
   `uvm_info("asyncf_down_monitor", "begin to collect one pkt", UVM_DEBUG);
   
   //When read driver drives the data, collect the DUT's output via iterface (rdata) into the transaction "tr"
 
   tr.data = down_if.rdata;
   @(posedge down_if.rclk);
   `uvm_info("asyncf_down_monitor", "end collect one pkt", UVM_DEBUG);
   `uvm_info("asyncf_down_monitor",$sformatf("rdata signal value in interface=%0d",down_if.rdata),UVM_DEBUG)
   
endtask


`endif
