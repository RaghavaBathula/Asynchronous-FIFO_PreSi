`ifndef ASYNCF_CASE0__SV
`define ASYNCF_CASE0__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "base_test.sv"

//This is a test case file

class asyncf_case0 extends base_test;

   //Factory Registration
   `uvm_component_utils(asyncf_case0)
	
	int logfile;
	uvm_table_printer m_printer;
	
   //Constructor definition
   function new(string name = "asyncf_case0", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   //build_phase declaration
   extern virtual function void build_phase(uvm_phase phase); 
   
   //end_of_elaboration_phase
   extern function void end_of_elaboration_phase (uvm_phase phase);
   
endclass


//build_phase method definition
function void asyncf_case0::build_phase(uvm_phase phase);
   super.build_phase(phase);
	 m_printer=new();
	 
   //setting this case0 sequence as default sequence using wrapper method
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.m_virtual_asyncf_seqr.main_phase", 
                                           "default_sequence", 
                                           asyncf_case0_sequence::type_id::get());
endfunction



function void asyncf_case0::end_of_elaboration_phase (uvm_phase phase);
		
				`uvm_info(get_full_name(), "Printing test topology", UVM_NONE)
				uvm_top.print_topology(m_printer);
				
				logfile= $fopen("logfile_case0.txt","w");
				
				set_report_default_file_hier(logfile);
				set_report_severity_action_hier (UVM_INFO, UVM_DISPLAY | UVM_LOG);
			
				
endfunction

`endif
