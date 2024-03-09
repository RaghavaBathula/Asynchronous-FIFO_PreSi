`ifndef ASYNCF_UP_MONITOR__SV
`define ASYNCF_UP_MONITOR__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_up_monitor extends uvm_monitor;

   //Factory Registration
   `uvm_component_utils(asyncf_up_monitor)

   //Creating virtual interface handle for write interface
   virtual up_if up_if;

   //TLM Analysis port helps in broadcasting objects to different components
   uvm_analysis_port #(asyncf_transaction)  ap;
   
   //Constructor
   function new(string name = "asyncf_up_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   //Build Phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
	  //Getting configuration object from configuration database to get access to virtual interface 
      if(!uvm_config_db#(virtual up_if)::get(this, "", "up_if", up_if))
         `uvm_fatal("asyncf_up_mornitor", "virtual interface must be set for up_if!!!")
	  
	  //Analysis port created
      ap = new("ap", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(asyncf_transaction tr);
endclass


//main_phase task definition
task asyncf_up_monitor::main_phase(uvm_phase phase);
  
  //Local transaction packet 
  asyncf_transaction tr;
  
   while(1) begin
      tr = new("tr");
	  
	  //Collect the write driver driven data via write interface and store it in "tr"
      collect_one_pkt(tr);
	  
	  //Put the transaction "tr" in the analysis port of write monitor "ap" using write method 
	  //to broadcast it to other components
      ap.write(tr);
   end
endtask


//collect_one_pkt task definition
task asyncf_up_monitor::collect_one_pkt(asyncf_transaction tr);
   
   //Wait till the winc becomes "1" in the interface (wait till the driver drives the data)
   while(1) begin
      @(posedge up_if.wclk);
      if(up_if.winc && !up_if.wfull) break;
   end
   
   //When driver drives the data, collect the driven data into the transaction "tr"
   `uvm_info("asyncf_up_monitor", "begin to collect one pkt", UVM_DEBUG);
   tr.data = up_if.wdata;
   @(posedge up_if.wclk);
   `uvm_info("asyncf_up_monitor", "end collect one pkt", UVM_DEBUG);
endtask


`endif
