module note_player (CLOCK_50, reset, SW, mute, aud_in, aud_out, beat);
	output logic [23:0] aud_out;
	output integer beat;
	input logic [23:0] aud_in;
	input logic [7:0] SW;
	input logic CLOCK_50, reset, mute;
	
	integer counter;
	// State variables
	enum { off, on } ps, ns;
	
	// Next State logic
	always_comb begin
	case (ps)
		off: if (counter < 100 & SW[beat])
				ns = on;
			else ns = off;
		on: if (counter >= 6250000)
				ns = off;
			else ns = on;
	endcase
	end
	
	always_comb begin
	if (mute)
		aud_out = 24'b000000000000000000000000;
	else begin
		case (ps)
			off:  aud_out = 24'b000000000000000000000000;
			on: aud_out = aud_in;
		endcase
	end
	end
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			ps <= off;
			counter <= 0;
			beat <= 0;
		end
		else begin
			if (counter >= 12500000) begin
				counter <= 0;
				if (beat == 7)
					beat <= 0;
				else
					beat++;
			end
			else
				counter++;
			ps <= ns;
		end
	end
endmodule

module note_player_testbench();
	logic [23:0] aud_out;
	logic [23:0] aud_in;
	logic [7:0] SW;
	logic CLOCK_50, reset;
	
	sqr_wav in (.CLOCK_50, .reset, .out(aud_in));
	
	note_player dut (.CLOCK_50, .reset, .SW, .aud_in, .aud_out);

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
		SW <= 8'b00000000;
		SW[0] <= 1;
		reset <= 1; repeat(1) @(posedge CLOCK_50); // Always reset FSMs at start
		reset <= 0; repeat(50000000) @(posedge CLOCK_50);
		
		$stop; // End the simulation.
	end
endmodule
