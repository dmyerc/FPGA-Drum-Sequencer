module notePlayer(CLOCK_50, reset, SW, wav, out);
	output logic [23:0] out;
	input logic CLOCK_50, reset, SW;
	input logic [23:0] wav;
	
	integer counter;
	// State variables
	enum { off, on } ps, ns;
	
	// Next State logic
	always_comb begin
	case (ps)
		off: if (counter == 12500000 & SW) begin
				ns = on;
				counter = 0;
			end
			else ns = off;
		on: if (counter == 12500000) begin
				counter = 0;
				if (~SW)
					ns = off;
			end
			else ns = off;
	endcase
	end
	
		
	always_comb begin
	case (ps)
		off: assign out = 24'b0;
		on: assign out = wav;
	endcase
	end
	
	// DFFs
	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			ps <= off;
			counter <= 0;
		end
		else begin
			ps <= ns;
			counter++;
		end
	end
endmodule