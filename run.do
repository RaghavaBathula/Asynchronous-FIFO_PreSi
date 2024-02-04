vlib work
vdel -all

vlib work
vlog sync_w2r.sv
vlog sync_r2w.sv
vlog wptr_full.sv
vlog fifomem.sv
vlog rptr_empty.sv 
vlog fifo1.sv +acc
vlog top.sv +acc

vsim work.async_fifo1_tb

add wave -r *

run -all