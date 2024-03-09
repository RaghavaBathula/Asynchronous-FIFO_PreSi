`ifndef ASYNCF_DOWN_TRANSACTION__SV
`define ASYNCF_DOWN_TRANSACTION__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_down_transaction extends uvm_sequence_item;

   rand bit rinc;

   //Factory Registration
   `uvm_object_utils_begin(asyncf_down_transaction)
      `uvm_field_int(rinc, UVM_ALL_ON)
   `uvm_object_utils_end

   //Constructor 
   function new(string name = "asyncf_down_transaction");
      super.new();
   endfunction

endclass
`endif
