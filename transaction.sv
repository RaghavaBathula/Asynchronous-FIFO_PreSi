//Transaction.sv

class transaction;

	rand logic [7:0] wdata;
	 rand logic winc;
	//rand logic rinc;
	
	logic [7:0] rdata;
	logic wfull;
	logic rempty;
	
	constraint c1 {winc dist {1 := 5, 0 := 5};}		//constraint for winc to be 1 - 5times, 0 - 5 times only 
	//constraint c2 (rinc dist {0 := 5, 1 := 2};)		//constraint for rinc to be 1 - 5times, 0 - 5 times only
	
	//Print the randomized inputs generated in the transaction
	virtual function void print(int n);
		//$display("\n Inputs wdata = %d | winc = %d | rinc = %d & Outputs rdata = %d | wfull = %d | rempty = %d \n", wdata, winc, rinc, rdata, wfull, rempty);
		$display("randomized input data '%0d' generated=%0d",n,wdata);
	endfunction: print
	
endclass: transaction 