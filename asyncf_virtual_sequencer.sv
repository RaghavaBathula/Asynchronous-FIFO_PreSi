`ifndef ASYNCF_VIRTUAL_SEQUENCER__SV
`define ASYNCF_VIRTUAL_SEQUENCER__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_virtual_sequencer extends uvm_sequencer;
   
   //Factory Registration
   `uvm_component_utils(asyncf_virtual_sequencer)
   
   //handles of write sequencer and read sequencer
   asyncf_up_sequencer m_up_seqr;
   asyncf_down_sequencer m_down_seqr;
   
   //Constructor
   function new(string name = "asyncf_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   
endclass

`endif
