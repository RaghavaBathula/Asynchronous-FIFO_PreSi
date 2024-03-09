
import my_pkg::*;

class coverage;
	asyncf_transaction up_trans;
	
		covergroup Async_fifo_coverage;
			wdata:   coverpoint up_trans.data{
						bins b1={0};
						bins b2={[1:9]};
						bins b3 ={[300:$]};
						bins b4 ={[44:55000]};
						//bins reserve =default;
						}
			
			
	    endgroup
	  
	    function new();
			
			Async_fifo_coverage=new();
		endfunction
		
		task sample(asyncf_transaction up_trans);
			this.up_trans=up_trans;
			
			Async_fifo_coverage.sample();
		endtask

endclass

