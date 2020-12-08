onerror {quit -f}
vlib work
vlog -work work moore_state_machine.vo
vlog -work work moore_state_machine.vt
vsim -novopt -c -t 1ps -L max7000s_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.moore_state_machine_vlg_vec_tst
vcd file -direction moore_state_machine.msim.vcd
vcd add -internal moore_state_machine_vlg_vec_tst/*
vcd add -internal moore_state_machine_vlg_vec_tst/i1/*
add wave /*
run -all
