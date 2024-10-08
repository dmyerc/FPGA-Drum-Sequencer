onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label aud_out /note_player_testbench/aud_out
add wave -noupdate -label aud_in /note_player_testbench/aud_in
add wave -noupdate -label sw /note_player_testbench/SW
add wave -noupdate -label clk /note_player_testbench/CLOCK_50
add wave -noupdate -label reset /note_player_testbench/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10500158 ps}
