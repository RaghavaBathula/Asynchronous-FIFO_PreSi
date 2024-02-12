//`include "transaction.sv"
//`include "generator.sv"
//`include "driver.sv"
import pkg::*;
class env;

	virtual intf.drv_mp vif;
	
	mailbox #(transaction) gen2driv;
	
	generator gen;
	driver driv;
	
	/*
	function new(virtual fifo_intf fifo_vif);
		this.fifo_vif = fifo_vif;
		
		/* TODO:Check if necessary to use new() on mailbox
		gen2drv = new();	
		in_mon2sb = new();	

		// instantiate al TB classes

		drv = new(fifo_vif,gen2drv);
		gen = new(gen2drv);
      in_mon = new(fifo_vif,in_mon2sb);
      sb = new(in_mon2sb);

	endfunction

	task pre_test;			// Run the reset task
		drv.reset();
	endtask
	
	task test;
	
	
	*/
	
	
	function new(virtual intf.drv_mp vif);
		this.vif=vif;
		gen2driv = new();
		
		gen = new(gen2driv);
		driv = new(vif, gen2driv);
	endfunction
	
	//build
	virtual task build();
		
	endtask: build
	
	//run
	virtual task run;
	
		//driv.reset();
	fork
		gen.main();
		driv.main();
	join
	
	endtask: run
	
	/*
	task pre_test();
		driv.reset();
	endtask: pre_test
	
	task test();
		fork
			gen.main();
			driv.main();
		join_any
	endtask: test
	
		
	task run;
		pre_test();
		test();
		//do{} while(0);
		$finish;
	endtask: run
	
	/* task post_test();
	
	endtask: post_test */

endclass: env