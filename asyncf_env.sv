`ifndef ASYNCF_ENV__SV
`define ASYNCF_ENV__SV

import my_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class asyncf_env extends uvm_env;

    //Factory Registration
   `uvm_component_utils(asyncf_env)
   
   int f1; //file descriptor

   //All sub component handles
   asyncf_up_agent              i_agt;
   asyncf_down_agent            o_agt;
   asyncf_model                 mdl;
   asyncf_scoreboard            scb;
   asyncf_virtual_sequencer     m_virtual_asyncf_seqr;

   //Analysis FIFOs for synchronization
   uvm_tlm_analysis_fifo #(asyncf_transaction) agt_scb_fifo;
   uvm_tlm_analysis_fifo #(asyncf_transaction) agt_mdl_fifo;
   uvm_tlm_analysis_fifo #(asyncf_transaction) mdl_scb_fifo;
   
   //constructor
   function new(string name = "asyncf_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   //build_phase method definition
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
	  //creating objects of all the sub components and analysis fifo
      i_agt = asyncf_up_agent::type_id::create("i_agt", this);
      o_agt = asyncf_down_agent::type_id::create("o_agt", this);
      mdl = asyncf_model::type_id::create("mdl", this);
      scb = asyncf_scoreboard::type_id::create("scb", this);
      m_virtual_asyncf_seqr= asyncf_virtual_sequencer::type_id::create("m_virtual_asyncf_seqr", this);
      
	  agt_scb_fifo = new("agt_scb_fifo", this);
      agt_mdl_fifo = new("agt_mdl_fifo", this);
      mdl_scb_fifo = new("mdl_scb_fifo", this);

   endfunction
	
   extern virtual function void connect_phase(uvm_phase phase);
   
   
endclass


//connect_phase method definition
function void asyncf_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   //                               _____
   //write agent(analysis port) ◊--[_____]-->⬭ connected with Reference model using TLM Analysis fifo
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);
   mdl.port.connect(agt_mdl_fifo.blocking_get_export);
	//									_____
   //Reference model(analysis port) ◊--[_____]-->⬭ connected with scoreboard using TLM Analysis fifo
   mdl.ap.connect(mdl_scb_fifo.analysis_export);
   scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
   //                              _____
   //read agent(analysis port) ◊--[_____]-->⬭ connected with scoreboard using TLM Analysis fifo
   o_agt.ap.connect(agt_scb_fifo.analysis_export);
   scb.act_port.connect(agt_scb_fifo.blocking_get_export);
   
   //Connect the seqr.
   m_virtual_asyncf_seqr.m_up_seqr = i_agt.sqr;
   m_virtual_asyncf_seqr.m_down_seqr = o_agt.sqr;
endfunction

`endif
