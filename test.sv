//test
//`include "env.sv"

import pkg::*;
/*
program test(intf intf1);
	env env_test;
	
	
	
	initial
	begin
		env_test = new(intf1);
		env_test.gen.tx_count = 32;
		env_test.run();
	end
endprogram: test
*/

class test;

	virtual intf.drv_mp vif;
	
	env env_test;
	
	function new(virtual intf.drv_mp vif);
		this.vif = vif;
		env_test = new(vif);
	endfunction
	
	virtual task build_and_run();
		begin
			env_test.build();
			env_test.run();
			$stop;
		end
	endtask
	
endclass: test