`ifndef ASYNCF_UP_SEQUENCER__SV
`define ASYNCF_UP_SEQUENCER__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_up_sequencer extends uvm_sequencer #(asyncf_transaction);

   //Factory Registration
   `uvm_component_utils(asyncf_up_sequencer)
   
   //constructor
   function new(string name = "asyncf_up_sequencer", uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   
endclass

`endif
