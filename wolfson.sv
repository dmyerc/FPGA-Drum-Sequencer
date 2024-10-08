/*
This module is intended to model a subset of the Wolfson WM8731 audio CODEC chip's
functionality. It does not model the behavior of the serial communication of commands
to the CODEC and so makes some assumptions about its operating state.

The following conditions must be ensured by the user for this module to act as an
accurate simulated model of the CODEC:
The CODEC is in slave mode.
The FPGA generates the master clock for the CODEC (MCLK/XTI/XCK).
The CODEC supplies the bit clock (BCLK) and it is at 1/4 the frequency of MCLK.
The CODEC uses MCLK to generate its own L/R clocks (ADCLRC/DACLRC) which the FPGA uses.
The sampling rates for the DAC and ADC must be equal.
None of the clock signals are inverted.
*/

`timescale 1 ns / 1 ps

module wolfson (AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	input AUD_XCK;
	output AUD_DACLRCK;
	output AUD_ADCLRCK;
	output AUD_BCLK;
	output AUD_ADCDAT;
	input AUD_DACDAT;
	
	reg [8:0] counter;
	
	initial counter = 0;
	
	assign AUD_DACLRCK = counter[8];
	assign AUD_ADCLRCK = AUD_DACLRCK;
	assign AUD_BCLK = counter[2];
	// Feed DAC data to ADC. This may be problematic for some designs which employ
	// feedback themselves so feel free to modify this line.
	assign AUD_ADCDAT = AUD_DACDAT; 
	
	always @(posedge AUD_XCK) begin
		counter <= counter + 1;
	end
endmodule

module wolfson_testbench ();
	reg clock;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	// I2C Audio/Video config interface
	wire FPGA_I2C_SCLK;
	wire FPGA_I2C_SDAT;
	
	// Audio data
	logic [23:0] dac_left, dac_right, sqr;
	logic [23:0] adc_left, adc_right;
	logic advance;
	logic [3:0] KEY;
	logic [9:0] SW;
	wire AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT;
	// Set up the clock. 
	parameter CLOCK_PERIOD=20; 
	initial clock<=1;
	always begin 
		#(CLOCK_PERIOD/2); 
		clock <= ~clock; 
	end

	wolfson chip (.AUD_XCK, .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT);
	// leave I2C disconnected
	DE1_SoC top (.CLOCK_50(clock), .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	initial begin
		// user test bench routine here
						repeat(1) @(posedge clock);
		KEY <= 4'b0000; 
		SW[8:0] <= 9'b000000000;
		SW[9] <= 1; repeat(1) @(posedge clock); // Always reset FSMs at start
		SW[9] <= 0; repeat(1) @(posedge clock);
		
		KEY[0] <= 0;repeat(1) @(posedge clock); // Test case 1: Key 0 pressed
		KEY[0] <= 1;repeat(1) @(posedge clock);
		
		SW[1] <= 1; repeat(25000000) @(posedge clock); // Test case 2: SW 1 flipped
		
		KEY[0] <= 0;repeat(1) @(posedge clock); // Test case 3: Key 0 pressed
		KEY[0] <= 1;repeat(25000000) @(posedge clock);
		
		KEY[1] <= 0;repeat(1) @(posedge clock); // Test case 4: Key 0 pressed
		KEY[1] <= 1;repeat(25000000) @(posedge clock);
		
		SW[2] <= 1; repeat(10) @(posedge clock); // Test case 2: SW 2 flipped
		SW[4] <= 1; repeat(10) @(posedge clock); // Test case 2: SW 4 flipped
		SW[6] <= 1; repeat(20) @(posedge clock); // Test case 2: SW 6 flipped
		SW[8] <= 1; repeat(25000000) @(posedge clock); // Test case 2: SW 8 flipped
		
		$stop; // End the simulation.
	end
endmodule
