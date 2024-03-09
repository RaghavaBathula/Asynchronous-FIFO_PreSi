`ifndef ASYNCF_CASE1_SEQ__SV
`define ASYNCF_CASE1_SEQ__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_case1_sequence extends uvm_sequence;
    
	//Factory Registration
    `uvm_object_utils(asyncf_case1_sequence)
	
    `uvm_declare_p_sequencer(asyncf_virtual_sequencer)
    
   function  new(string name= "asyncf_case1_sequence");
      super.new(name);
   endfunction 
   
   extern virtual task body();
   extern virtual task pre_body();
   extern virtual task post_body();

endclass

task asyncf_case1_sequence::body();
   asyncf_up_seq up_seq;
   asyncf_down_seq down_seq;
   
   
   
    /////////////////////// For checking Parallel Read and write //////////////////////
	fork 
		begin
				repeat (1024) begin
					 `uvm_do_on(up_seq,p_sequencer.m_up_seqr)
					 `uvm_info("asyncf_case0", "Finished sending  transactions", UVM_HIGH)
				
				  end
		
		end
		
		begin 
				repeat (1024) begin
				      `uvm_do_on(down_seq,p_sequencer.m_down_seqr)
					 `uvm_info("asyncf_case0", "Finished Receiving   transactions", UVM_HIGH)
			
				end
				#400; //for the last comparision
		end
	join 
	
	
endtask

 
task asyncf_case1_sequence::pre_body();
    if(starting_phase != null) begin 
        starting_phase.raise_objection(this);
    end
endtask

task asyncf_case1_sequence::post_body();
    `uvm_info("asyncf_case1", "Entering post_body", UVM_MEDIUM)
    if(starting_phase != null) begin 
        `uvm_info("asyncf_case1", "starting_pase is null", UVM_MEDIUM)
        starting_phase.drop_objection(this);
    end
endtask

`endif
