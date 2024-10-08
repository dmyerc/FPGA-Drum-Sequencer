module light_controller (beat, LEDR);
	output logic [9:0] LEDR;
	input integer beat;
	
	integer counter;
	// State variables
	enum { low, high } ps, ns;
	
	// Next State logic
	always_comb begin
	case (beat)
		0: LEDR = 10'b0000000001;
		1: LEDR = 10'b0000000010;
		2: LEDR = 10'b0000000100;
		3: LEDR = 10'b0000001000;
		4: LEDR = 10'b0000010000;
		5: LEDR = 10'b0000100000;
		6: LEDR = 10'b0001000000;
		7: LEDR = 10'b0010000000;
		default: LEDR = 10'b0000000000; // or some other default value
	endcase
	end
endmodule
	

module light_controller_testbench();
	logic [9:0] LEDR;
	integer beat;
	
	light_controller dut (.beat, .LEDR);
	
	// Test the design.
	integer i;
	initial begin
		#10;
		for (i=0;i<8;i++) begin
			beat <= i; #10;
		end
		
		beat<= 0; #30;
		
		$stop; // End the simulation.
	end
endmodule
