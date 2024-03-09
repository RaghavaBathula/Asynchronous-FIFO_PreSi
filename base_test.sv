`ifndef BASE_TEST__SV
`define BASE_TEST__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test extends uvm_test;

	//Factory Registration
	`uvm_component_utils(base_test)

	//creating handle for its sub-component i.e, environment
    asyncf_env	 env;	

	
   
	   //constructor
	   function new(string name = "base_test", uvm_component parent = null);
		  super.new(name,parent);
	   endfunction
	   
	   extern virtual function void build_phase(uvm_phase phase);
	   extern virtual function void report_phase(uvm_phase phase);
   
endclass


function void base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   //creating env object
   env  =  asyncf_env::type_id::create("env", this);
   
endfunction

function void base_test::report_phase(uvm_phase phase);
   uvm_report_server server;
   int err_num;
   super.report_phase(phase);

   server = get_report_server();
   err_num = server.get_severity_count(UVM_ERROR);

   if (err_num != 0) begin
		`uvm_info("base_test", "TEST CASE FAILED", UVM_LOW);
      
   end
   else begin
		`uvm_info("base_test", "TEST CASE PASSED ", UVM_LOW);
     
   end
endfunction

`endif
