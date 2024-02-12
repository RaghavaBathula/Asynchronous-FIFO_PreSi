//`include "transaction.sv"
import pkg::*;
//Driver.sv

class driver;

	int tx_count1 = 0;
	int tx_count2 = 0;
	
	
			
	virtual intf.drv_mp intf_vi;						//Virtual Interface Handle to be dynamic
	mailbox #(transaction) gen2driv;           //mailbox instance
	
	//Connection Assignment
	function new(virtual intf.drv_mp intf_vi, mailbox #(transaction) mbx);
		this.intf_vi = intf_vi;
		this.gen2driv = mbx;
	endfunction
	
	//Perform Reset and send it to DUT inputs via Virtual Interface
	virtual task reset();
		
		//wait(!intf_vi.wrst_n);
		$display("Driver Reset Started");
		intf_vi.drv_cb.wdata <= 0;
		intf_vi.drv_cb.winc <= 0;
		//intf_vi.rinc <= 0;
		//wait(intf_vi.wrst_n);
		$display("Driver Reset ended");
		
	endtask: reset
	

	//Get TX data from mailbox & at every clk edge drive the i/p data to DUT
	virtual task main();
	fork
		$display("Driver Started");
		for(int i=0; i<tx_count;i++)
		begin
			transaction Data2DUT;
			gen2driv.get(Data2DUT);
			$display("'%0d'th Driver received data = %0d", i,Data2DUT.wdata);
			/* @(intf_vi.drv_cb);
			//tx_count1++;
			intf_vi.drv_cb.wdata <= Data2DUT.wdata;
			intf_vi.drv_cb.winc <= Data2DUT.winc;
			@(intf_vi.drv_cb);
			intf_vi.drv_cb.winc <= '0;
			//intf_vi.rinc <= tx.rinc;
			/*if(tx.winc == 1'b1)
				tx_count2++;*/ 
			
		end
		$display("Driver Ended");
	join
	endtask: main

endclass: driver 

