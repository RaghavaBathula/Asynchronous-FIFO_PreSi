`ifndef ASYNCF_UP_SEQ_SV
`define ASYNCF_UP_SEQ_SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_up_seq extends uvm_sequence #(asyncf_transaction);
   
   //Factory Registration
   `uvm_object_utils(asyncf_up_seq)
   
   //Constructor
   function  new(string name= "asyncf_up_seq");
      super.new(name);
   endfunction 

   extern virtual task body();
   extern virtual task pre_body();
   extern virtual task post_body();

   
endclass


//body() task defination
task asyncf_up_seq::body();
    asyncf_transaction up_trans;

    //This macro will 
		//1. create object for "up_trans"
		//2. start(), randomize() and finish()
	//But this macro won't call pre_body(), post_body() tasks
    `uvm_do(up_trans)
	
    `uvm_info("asyncf_up_seq", "send one transaction", UVM_DEBUG)

endtask


//pre_body() task defination
task asyncf_up_seq::pre_body();
//    if(starting_phase != null) begin 
//        starting_phase.raise_objection(this);
//    end
endtask

//post_body task defination
task asyncf_up_seq::post_body();
//    if(starting_phase != null) begin 
//        starting_phase.drop_objection(this);
//    end
endtask
`endif
