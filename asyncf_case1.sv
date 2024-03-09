`ifndef ASYNCF_CASE1__SV
`define ASYNCF_CASE1__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "base_test.sv"

class asyncf_case1 extends base_test;
   
   //Factory registration
   `uvm_component_utils(asyncf_case1)
   
   uvm_table_printer m_printer;
   
   int logfile,logfile2;
   
   //Constructor
   function new(string name = "asyncf_case1", uvm_component parent = null);
      super.new(name,parent);
	  
   endfunction 
   
   //build_phase declaration
   extern virtual function void build_phase(uvm_phase phase); 
   
   extern virtual function void end_of_elaboration_phase (uvm_phase phase);
		   
		
   
   
endclass


//build_phase method definition
function void asyncf_case1::build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_printer=new();

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.m_virtual_asyncf_seqr.main_phase", 
                                           "default_sequence", 
                                           asyncf_case1_sequence::type_id::get());
endfunction


//end_of_elaboration_phase method definition

function void asyncf_case1::end_of_elaboration_phase (uvm_phase phase);
		
				`uvm_info(get_full_name(), "Printing test topology", UVM_NONE)
				uvm_top.print_topology(m_printer);
				
				logfile= $fopen("logfile_case1.txt","w");
				
				set_report_default_file_hier(logfile);
				set_report_severity_action_hier (UVM_INFO, UVM_DISPLAY | UVM_LOG);
				
				
				
endfunction


`endif
