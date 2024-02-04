//TestBench
module async_fifo1_tb;

  parameter DSIZE = 8;
  parameter ASIZE = 9;

  wire [DSIZE-1:0] rdata;
  wire wfull;
  wire rempty;
  reg [DSIZE-1:0] wdata;
  reg winc, wclk, wrst_n;
  reg rinc, rclk, rrst_n;
  
  //pass-fail counter
  int passcount, failcount;

  // Queue for checking data
  reg [DSIZE-1:0] producer_q[$];
  reg [DSIZE-1:0] consumer_data;


  // Instantiate the FIFO
  async_fifo1 #(DSIZE, ASIZE) inst (.*);

  initial 
  begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #3ns wclk = ~wclk; 	// generated a producer clk which has a freq of 500Mhz (2 ns) & 2 idle cycles
									// which makes the time period of clk 6 ns
      forever #4.44ns rclk = ~rclk; // generated a consumer clk which has a freq of 225Mhz (4.44 ns) & 1 idle cycles
									// which makes the time period of clk 8.88 ns
    join
  end

  initial 
  begin
		winc = 1'b0;
		wdata = '0;
		wrst_n = 1'b0;
		repeat(1) @(posedge wclk);
		wrst_n = 1'b1;               		//reset disabled

		for (int iter=0; iter<64; iter++) 	//1024 items
		begin 
		  for (int i=0; i<32; i++) 
		  begin
				@(posedge wclk iff !wfull);
				winc = (i%2 == 0)? 1'b1 : 1'b0; 
				//winc = '1;
				if (winc) 
				begin
				  wdata = $urandom;
				  producer_q.push_front(wdata);
				end
		  end
		  #1us;
		end
  end

  initial 
  begin
		rinc = 1'b0;
		rrst_n = 1'b0;
		
		repeat(1) @(posedge rclk);
		rrst_n = 1'b1;

		for (int iter=0; iter<64; iter++) 
		begin
		  for (int i=0; i<32; i++) 
		  begin
			@(posedge rclk iff !rempty)
			rinc = (i%2 == 0)? 1'b1 : 1'b0;
			//rinc = '1;
			if (rinc) 
			begin
			  consumer_data = producer_q.pop_back();
			  // Check the rdata against modeled wdata
			  $display("Checking rdata: expected wdata = %h, rdata = %h", consumer_data, rdata);
			 
			  /* assert(rdata === consumer_data) 
			  else $error("Checking failed: expected wdata = %h, rdata = %h", consumer_data, rdata); */
			  if(rdata === consumer_data)
					passcount++;
			  else
			  begin
					failcount++;
					$display("Checking failed: expected wdata = %h, rdata = %h", consumer_data, rdata);
			  end
			end
		  end
		  #1us;
		end
		
		if(failcount == 0)
				$display("\n All passed, Consumer received all the 1024 data items sent by Producer\n");
		$stop;
  end

endmodule