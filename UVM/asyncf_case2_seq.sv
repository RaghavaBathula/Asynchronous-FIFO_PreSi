`ifndef ASYNCF_CASE0_SEQ__SV
`define ASYNCF_CASE0_SEQ__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_case2_sequence extends uvm_sequence;
    
   //Factory Registration
   `uvm_object_utils(asyncf_case2_sequence)
	
   //
   `uvm_declare_p_sequencer(asyncf_virtual_sequencer)
    
   //Constructor method definition	
   function  new(string name= "asyncf_case2_sequence");
      super.new(name);
   endfunction 
   
   //Phases
   extern virtual task body();
   extern virtual task pre_body();
   extern virtual task post_body();

endclass


//body task definition
task asyncf_case2_sequence::body();
   asyncf_up_seq up_seq;
   asyncf_down_seq down_seq;
   
    /////////////////////// For checking Parallel Read and write //////////////////////
	fork 
		begin
				repeat (3) begin
					 `uvm_do_on(up_seq,p_sequencer.m_up_seqr)
					 `uvm_info("asyncf_case0", "Finished sending  transactions", UVM_MEDIUM)
				
				  end
		
		end
		
		begin 
				repeat (3) begin
				      `uvm_do_on(down_seq,p_sequencer.m_down_seqr)
					 `uvm_info("asyncf_case0", "Finished Receiving   transactions", UVM_MEDIUM)
			
				end
				#40; //for the last comparision
		end
	join 
	
	
	
endtask


//pre_body task definition
task asyncf_case2_sequence::pre_body();
    if(starting_phase != null) begin 
		//for objects "starting_phase" is used to raise or drop objections
        starting_phase.raise_objection(this);
    end
endtask


//post_body task definition
task asyncf_case2_sequence::post_body();
    `uvm_info("asyncf_case0", "Entering post_body", UVM_MEDIUM)
    if(starting_phase != null) begin 
        `uvm_info("asyncf_case0", "starting_phase is null", UVM_MEDIUM)
        starting_phase.drop_objection(this);
    end
endtask

`endif