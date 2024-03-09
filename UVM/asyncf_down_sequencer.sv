`ifndef ASYNCF_DOWN_SEQUENCER__SV
`define ASYNCF_DOWN_SEQUENCER__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_down_sequencer extends uvm_sequencer #(asyncf_down_transaction);
   
   //Factory Registration
   `uvm_component_utils(asyncf_down_sequencer)
   
   //Constructor
   function new(string name = "asyncf_down_sequencer", uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   
endclass

`endif
