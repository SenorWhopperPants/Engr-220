onerror {quit -f}
vlib work
vlog -work work question57.vo
vlog -work work question57.vt
vsim -novopt -c -t 1ps -L max7000s_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.question57_vlg_vec_tst
vcd file -direction question57.msim.vcd
vcd add -internal question57_vlg_vec_tst/*
vcd add -internal question57_vlg_vec_tst/i1/*
add wave /*
run -all
