module note_register (CLOCK_50, reset, load, SW, notes);
	output logic [7:0] notes;
	input logic CLOCK_50, reset, load;
	input logic [7:0] SW;
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset)
			notes <= 8'b00000000;
		else if (load)
			notes <= SW;
	end
endmodule

module note_register_testbench();
	logic CLOCK_50, reset, load;
	logic [7:0] SW, notes;
	
	note_register dut (.CLOCK_50, .reset, .load, .SW, .notes);

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
		load <= 0;
		SW <= 8'b00000000;
		reset <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
		reset <= 0; repeat(2) @(posedge CLOCK_50);
		
		SW <= 8'b10010110;	repeat(3) @(posedge CLOCK_50);
		load <= 1;				repeat(1) @(posedge CLOCK_50);
		load <= 0;				repeat(2) @(posedge CLOCK_50);
		
		reset <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
		reset <= 0; repeat(2) @(posedge CLOCK_50);
		$stop; // End the simulation.
	end
endmodule