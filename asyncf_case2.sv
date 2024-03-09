`ifndef  ASYNCF_CASE2__SV
`define  ASYNCF_CASE2__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "base_test.sv"

//This is a test case file

class asyncf_case2 extends base_test;

   //Factory Registration
   `uvm_component_utils(asyncf_case2)

   //Constructor definition
   function new(string name = "asyncf_case2", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   //build_phase declaration
   extern virtual function void build_phase(uvm_phase phase); 
   
endclass


//build_phase method definition
function void asyncf_case2::build_phase(uvm_phase phase);
   super.build_phase(phase);

   //setting this case0 sequence as default sequence using wrapper method
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.m_virtual_asyncf_seqr.main_phase", 
                                           "default_sequence", 
                                            asyncf_case2_sequence::type_id::get());
										   
endfunction


`endif

