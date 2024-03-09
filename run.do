
vlib work
vdel -all

vlib work

vlog -coveropt 3 +cover +acc fifo1.sv fifomem.sv rptr_empty.sv wptr_full.sv sync_r2w.sv sync_w2r.sv pkg.sv asyncf_if.sv asyncf_transaction.sv asyncf_down_transaction.sv asyncf_up_sequencer.sv asyncf_down_sequencer.sv asyncf_up_seq.sv asyncf_down_seq.sv asyncf_virtual_sequencer.sv asyncf_driver.sv asyncf_down_driver.sv asyncf_up_monitor.sv asyncf_down_monitor.sv asyncf_up_agent.sv asyncf_down_agent.sv asyncf_model.sv coverage.sv asyncf_scoreboard.sv asyncf_env.sv base_test.sv asyncf_case0_seq.sv asyncf_case0.sv asyncf_case1_seq.sv asyncf_case1.sv top_tb.sv
vsim -coverage -vopt work.top_tb -c -do "coverage save -onexit -directive -codeAll ASync_FIFO_cov;run -all;break"

coverage report -detail
vcover report -html ASync_FIFO_cov

