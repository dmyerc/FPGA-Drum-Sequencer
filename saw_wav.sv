module saw_wav (CLOCK_50, reset, out);
	output logic [23:0] out;
	input logic CLOCK_50, reset;
	
	integer counter;
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			counter <= 0;
			out <= 24'b000000000000000000000000;
		end
		else begin
		counter++;
			if (counter == 5000) begin
				counter <= 0;
				out <= 24'b000000000000000000000000;
			end
			else
				out <= out + 70;
		end
	end
endmodule

module saw_wav_testbench();
	logic CLOCK_50, reset;
	logic [23:0] out;
	
	saw_wav dut (.CLOCK_50, .reset, .out);

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
		reset <= 0; repeat(10000) @(posedge CLOCK_50);
		
		$stop; // End the simulation.
	end
endmodule
