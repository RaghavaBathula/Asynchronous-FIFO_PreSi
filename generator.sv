//`include "transaction.sv"
import pkg::*;
class generator;

	transaction tx;		//Transaction handle
	transaction Datatosend;
	mailbox #(transaction) gen2driv;		//Mailbox handle from gen to driv
	//int tx_count;							//To track no. of TXs
	
	//Function with mailbox arguments & assignment
	function new(mailbox #(transaction) gen2driv);
		this.gen2driv = gen2driv;
		this.tx = new;
	endfunction

	//Task of Gen: Randomize contents from transactions & send to mailbox
	virtual task main();
	fork 
	begin
		$display("Generator started");
		for(int i=0; i < tx_count; i++) 
		begin
			//tx = new();
			//for(int i=0;i<32;i++)
			//begin
				assert(tx.randomize());
				Datatosend = new tx;
				gen2driv.put(Datatosend);
				tx.print(i);
				//end
			//end
			/*assert(tx.randomize());			//To verify if tx has been randomized or not.
			tx.print();
			gen2driv.put(tx);*/
		end
		$display("Generator Completed");
		end
	join_none
	endtask: main
	
endclass: generator 