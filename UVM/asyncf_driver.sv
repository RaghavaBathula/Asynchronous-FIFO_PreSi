`ifndef ASYNCF_DRIVER__SV
`define ASYNCF_DRIVER__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_driver extends uvm_driver#(asyncf_transaction);

   //Factory Registration
   `uvm_component_utils(asyncf_driver)

   //Creating virtual interface handle for write interface
   virtual up_if up_if;
   logic no_tr = 1'b0;

   //Constructor
   function new(string name = "asyncf_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   //Build Phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
	  //Getting configuration object from configuration database to get access to virtual interface 
      if(!uvm_config_db#(virtual up_if)::get(this, "", "up_if", up_if))
         `uvm_fatal("asyncf_driver", "virtual interface must be set for up_if!!!")
   endfunction
   
   //Sub phases of run()
   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(asyncf_transaction tr);
  
endclass

//Main Phase
task asyncf_driver::main_phase(uvm_phase phase);
   up_if.wdata <= 8'b0;
   up_if.winc  <= 1'b0;
   
   //When write reset Enabled, Stay in this loop
   while(!up_if.wrst_n)		
      @(posedge up_if.wclk);
   
   fork
		while(1) 
		begin
		
		  //Send a request to get sequence item to write sequencer
		  seq_item_port.get_next_item(req);
		  
		  //Drive the received sequence item to DUT
		  drive_one_pkt(req);
		 
		  //Send the ACK to the write sequencer
		  seq_item_port.item_done();
		end
		
   join
endtask

//drive_one_pkt task
task asyncf_driver::drive_one_pkt(asyncf_transaction tr);
   byte unsigned     data_q[]; 
   int  data_size;
   
   data_size = tr.pack_bytes(data_q) / 8; 
   
   for ( int i = 0; i < data_size; i++ ) begin
	   
      @(posedge up_if.wclk);
      while(1) begin
        if (up_if.wfull) begin
		 
            //If FIFO is full, dont drive the data
            up_if.winc <= 1'b0;
			
            @(posedge up_if.wclk);
			`uvm_info("asyncf_driver","FIFO is FULL !!",UVM_MEDIUM)
			`uvm_info("asyncf_driver",$sformatf("wfull signal value in interface=%0d",up_if.wfull),UVM_DEBUG)
			break;
        end
		
        else begin
		  //If not full, drive the data to the write interface
		  
          up_if.winc<= 1'b1;
          up_if.wdata <= data_q[i];

			@(posedge up_if.wclk);
			up_if.winc <= 1'b0;
          break;
        end
		
      end
	 
   end

endtask

/*
task asyncf_driver::drive_nothing();
   @(posedge up_if.wclk);
   
   //After driving the data, disable the write enable signal (winc)
   if (no_tr) 
		up_if.winc<= 1'b0;

endtask
*/
`endif
