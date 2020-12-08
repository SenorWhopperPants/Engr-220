onerror {quit -f}
vlib work
vlog -work work proj01.vo
vlog -work work proj01.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.proj01_vlg_vec_tst
vcd file -direction proj01.msim.vcd
vcd add -internal proj01_vlg_vec_tst/*
vcd add -internal proj01_vlg_vec_tst/i1/*
add wave /*
run -all
