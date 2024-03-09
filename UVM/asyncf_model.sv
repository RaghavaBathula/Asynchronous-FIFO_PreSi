`ifndef ASYNCF_MODEL__SV
`define ASYNCF_MODEL__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_model extends uvm_component;

   //Factory Registration
   `uvm_component_utils(asyncf_model)
   
   //Analysis port and get_port handles
   uvm_blocking_get_port #(asyncf_transaction)  port;
   uvm_analysis_port #(asyncf_transaction)  ap;

   //Constructor
   extern function new(string name, uvm_component parent);
   
   //run() phases
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);

   
endclass 


//Constructor method definition
function asyncf_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 


//build_phase method definition
function void asyncf_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   //Analysis_port and blocking_get_port creation
   port = new("port", this);
   ap = new("ap", this);
endfunction


//main_phase task definition
task asyncf_model::main_phase(uvm_phase phase);
   

   //2 local write transaction handles
   asyncf_transaction tr;
   asyncf_transaction new_tr;
   
   super.main_phase(phase);
   
   //while(1) 
   forever
   begin
      //Get the transaction from TLM analysis FIFO(connected to write agent) using get method
      port.get(tr);
	  
	  //Create an object for the new_tr and copy the received transaction "tr" into it.
      new_tr = new("new_tr");
      new_tr.copy(tr);
	  
		// `uvm_info("asyncf_model", "get one transaction, copy and print it:", UVM_LOW)
	  `uvm_info("asyncf_model", $sformatf("Transaction sent with data :%0h",tr.data), UVM_LOW)
      
      new_tr.print();
	  
	  //Put the transaction "new_tr" in the analysis port of reference model "ap" using write method 
	  //to broadcast it to other components (scoreboard via TLM Analysis FIFO) 
      ap.write(new_tr);
	  
	  //This new_tr packet contains the data that the write driver has written to DUT
   end
endtask
`endif
