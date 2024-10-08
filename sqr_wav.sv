module sqr_wav (CLOCK_50, reset, out);
	output logic [23:0] out;
	input logic CLOCK_50, reset;
	
	integer counter;
	// State variables
	enum { low, high } ps, ns;
	
	// Next State logic
	always_comb begin
	case (ps)
		low: if (counter == 50000)
				ns = high;
			else ns = low;
		high: if (counter == 50000)
				ns = low;
			else ns = high;
	endcase
	end
	
	always_comb begin
	case (ps)
		low:  out = 24'b000000000000000000000000;
		high: out = 24'b000000011100000000000000;
	endcase
	end
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			ps <= low;
			counter <= 0;
		end
		else begin
			if (ns != ps) begin
				counter <= 0;
				ps <= ns;
			end
			else
				counter++;
		end
	end
endmodule

module sqr_wav_testbench();
	logic CLOCK_50, reset;
	logic [23:0] out;
	
	sqr_wav dut (.CLOCK_50, .reset, .out);

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
		reset <= 0; repeat(100000) @(posedge CLOCK_50);
		
		
		$stop; // End the simulation.
	end
endmodule
