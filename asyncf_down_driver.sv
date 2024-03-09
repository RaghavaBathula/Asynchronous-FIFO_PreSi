`ifndef ASYNCF_DOWN_DRIVER__SV
`define ASYNCF_DOWN_DRIVER__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_down_driver extends uvm_driver#(asyncf_down_transaction);

   //Factory Registration
   `uvm_component_utils(asyncf_down_driver)

   //Creating virtual interface handle for write interface
   virtual down_if down_if;
   logic no_tr = 1'b0;

   //Constructor
   function new(string name = "asyncf_down_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   //build_phase definition
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
	  //Getting configuration object from configuration database to get access to virtual interface 
      if(!uvm_config_db#(virtual down_if)::get(this, "", "down_if", down_if))
         `uvm_fatal("asyncf_down_driver", "virtual interface must be set for down_if!!!")
   endfunction

   //run() phases
   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(asyncf_down_transaction tr);
  
endclass


//main_phase task definition
task asyncf_down_driver::main_phase(uvm_phase phase);
   down_if.rinc  <= 1'b0;
   
   //While read reset enabled, stay in the loop
   while(!down_if.rrst_n)
      @(posedge down_if.rclk);
   fork

       while(1) begin
	   
          //Send a request to get sequence item to read sequencer
          seq_item_port.get_next_item(req);
		  
		  //Drive the received sequence item to DUT
          drive_one_pkt(req);
		  
		  //Send the ACK to the read sequencer
          seq_item_port.item_done();
       end
      
   join

endtask



//drive_one_pkt task definition
task asyncf_down_driver::drive_one_pkt(asyncf_down_transaction tr);

      @(posedge down_if.rclk);
      while(1) begin
        if (down_if.rempty) begin
            //If FIFO is empty, don't read the data
            down_if.rinc <= 1'b0;
			
			//check for next rclk edge
            @(posedge down_if.rclk);
			
			`uvm_info("asyncf_down_driver", "FIFO is EMPTY !!!", UVM_MEDIUM);
			`uvm_info("asyncf_down_driver",$sformatf("rempty signal value in interface=%0d",down_if.rempty),UVM_DEBUG)
			
			break;
        end
		
		//If FIFO is not empty, read the data from read interface
        else begin
          down_if.rinc <= 1'b1;
					  @(posedge down_if.rclk); 
					  down_if.rinc <= 1'b0;
          break;
        end
      end
	   
endtask

`endif
