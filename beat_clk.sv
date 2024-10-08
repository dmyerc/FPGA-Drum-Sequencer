module beat_clk (CLOCK_50, reset, beatNum, beatClk);
	output integer beatNum;
	output logic beatClk;
	input logic CLOCK_50, reset;
	
	integer counter;
	// State variables
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			beatClk <= 1;
			counter <= 0;
			beatNum <= 0;
		end
		else begin
			if (counter == 6250000) begin
				beatClk <= ~beatClk;
				counter++;
			end
			else if (counter >= 12500000) begin
				beatClk <= ~beatClk;
				counter <= 0;
				if (beatNum == 7)
					beatNum <= 0;
				else
					beatNum++;
			end
			else
				counter++;
		end
	end
endmodule

module beat_clk_testbench();
	logic CLOCK_50, reset, beatClk;
	integer beatNum;
	
	beat_clk dut (.CLOCK_50, .reset, .beatNum, .beatClk);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	// Test the design.
	integer i;
	initial begin
		@(posedge CLOCK_50);
		reset <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
		reset <= 0; repeat(25000000) @(posedge CLOCK_50);
		
		
		$stop; // End the simulation.
	end
endmodule
