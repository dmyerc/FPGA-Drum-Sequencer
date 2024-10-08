// Top-level module that defines the I/Os for the DE-1 SoC board

module DE1_SoC (CLOCK_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input CLOCK_50;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	// Audio data
	logic [23:0] dac_left, dac_right, sqr;
	logic [23:0] adc_left, adc_right;
	logic advance;
	logic [7:0] notes1, notes2;
	logic [23:0] wav1, wav2;
	integer beat;
	
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	audio_driver setup(.CLOCK_50, .reset(SW[9]), .dac_left, .dac_right, .adc_left, .adc_right, .advance, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT);
	
	sqr_wav sound1(.CLOCK_50, .reset(SW[9]), .out(wav1));
	saw_wav sound2(.CLOCK_50, .reset(SW[9]), .out(wav2));
	
	note_register render1(.CLOCK_50, .reset(SW[9]), .load(~KEY[0]), .SW(SW[7:0]), .notes(notes1));
	note_register render2(.CLOCK_50, .reset(SW[9]), .load(~KEY[1]), .SW(SW[7:0]), .notes(notes2));
	
	note_player play1(.CLOCK_50, .reset(SW[9]), .SW(notes1), .mute(SW[8]), .aud_in(wav1), .aud_out(dac_left), .beat);
	note_player play2(.CLOCK_50, .reset(SW[9]), .SW(notes2), .mute(SW[8]), .aud_in(wav2), .aud_out(dac_right));
	
	light_controller(.beat, .LEDR);
	
	//notePlayer test(.CLOCK_50, .reset(SW[9]), .SW[7,0], .out(dac_left))
	
	//saw_wav sound2(.CLOCK_50, .reset(SW[9]), .out(dac_left));
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
endmodule
