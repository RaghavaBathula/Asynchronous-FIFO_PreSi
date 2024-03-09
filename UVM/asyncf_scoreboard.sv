`ifndef ASYNCF_SCOREBOARD__SV
`define ASYNCF_SCOREBOARD__SV
`include "uvm_macros.svh"
import my_pkg::*;
import uvm_pkg::*;


class asyncf_scoreboard extends uvm_scoreboard;


   //write transaction type queue
   asyncf_transaction  expect_queue[$];
   
   coverage cov;
   
   //port handles
   uvm_blocking_get_port #(asyncf_transaction)  exp_port;
   uvm_blocking_get_port #(asyncf_transaction)  act_port;
   
   //Constructor Declaration
   extern function new(string name, uvm_component parent = null);
   
   //run() phases
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
   
    //Factory Registration
   `uvm_component_utils(asyncf_scoreboard)

   
endclass 


//Constructor method definition
function asyncf_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 


//build_phase method definition
function void asyncf_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   //Ports creation
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 


//main_phase task definition
task asyncf_scoreboard::main_phase(uvm_phase phase);
   

   //3 local write transaction handles
   asyncf_transaction  get_expect,  get_actual, tmp_tran;
   bit result;
   int passcount,failcount;
 
   super.main_phase(phase);
   
   fork 
      while (1) begin
	  
	     //Since this exp_port is connected with reference model via TLM analysis FIFO 
		 //By Calling get method, scoreboard gets the transaction object from reference model
		 //store this object Received in get_expect
         exp_port.get(get_expect);
		 
		 //Push back this object into the expect_queue
         expect_queue.push_back(get_expect);
		 
      end
	  
	  
      while (1) 
	  begin
	  
	     //Since this act_port is connected with read agent via TLM analysis FIFO 
		 //By Calling get method, scoreboard gets the transaction object from read agent
		 //store this object Received in get_actual
         act_port.get(get_actual);
		 
         if(expect_queue.size() > 0)
		 //if there is a valid write object	
		 begin
		 
		        //store the popped data from expect_queue(containing expect pkt's) into a local transaction 
				tmp_tran = expect_queue.pop_front();
				
				//since get_actual is of type uvm_sequence item , it has in-built compare method
				//store the return value of compare method
				result = get_actual.compare(tmp_tran);
				
				cov = new();
				cov.sample(get_actual);
				
				if(result) 
				begin 
					passcount++;
				   `uvm_info("asyncf_scoreboard", $sformatf("Comparision SUCCESSFUL for data:%0h",tmp_tran.data), UVM_LOW);
				end
				else 
				begin
					failcount++;
				   `uvm_error("asyncf_scoreboard", "Comparision FAILED");
				   $display("the expect pkt is");
				   tmp_tran.print();
				   $display("the actual pkt is");
				   get_actual.print();
				end
        end
		 
         else 
		 begin
            `uvm_error("asyncf_scoreboard", "Received from DUT, while Expect Queue is empty");
            $display("the unexpected pkt is");
            get_actual.print();
         end 
		 
      end
	  
   join
   
endtask
`endif
