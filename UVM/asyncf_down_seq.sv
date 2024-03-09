`ifndef ASYNCF_DOWN_SEQ_SV
`define ASYNCF_DOWN_SEQ_SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_down_seq extends uvm_sequence #(asyncf_down_transaction);

   //Factory Registration
   `uvm_object_utils(asyncf_down_seq)
   
   //Constructor
   function  new(string name= "asyncf_down_seq");
      super.new(name);
   endfunction 

   extern virtual task body();
   extern virtual task pre_body();
   extern virtual task post_body();

endclass

task asyncf_down_seq::body();
   //local read transaction handle
   asyncf_down_transaction down_trans; 
   
    //This macro will 
		//1. create object for "up_trans"
		//2. start(), randomize() and finish()
	//But this macro won't call pre_body(), post_body() tasks
    `uvm_do(down_trans)
	
    `uvm_info("asyncf_down_seq", "Get one transaction", UVM_DEBUG)

endtask

task asyncf_down_seq::pre_body();
    if(starting_phase != null) begin 
        starting_phase.raise_objection(this);
    end
endtask

task asyncf_down_seq::post_body();
    if(starting_phase != null) begin 
        starting_phase.drop_objection(this);
    end
endtask
`endif
