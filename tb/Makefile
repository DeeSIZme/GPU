VSIM_CMD = @vsim
VLOG_CMD = @vlog +acc -nologo

vpath %.sv ../rtl_src .
vpath %.v  ../rtl_src

.PHONY: top work clean


syn_dir := ../nios2/nios_sys/synthesis/submodules/

syn_files_sv := $(shell find $(syn_dir) -name "*.sv")
syn_files_v  += $(shell find $(syn_dir) -name "*.v")
syn_files_done := $(patsubst $(syn_dir)%.v, .%.done,  $(syn_files_v))
syn_files_done += $(patsubst $(syn_dir)%.sv, .%.done, $(syn_files_sv))
syn_files_done += .nios_sys.done
syn_files_done += .DE1_SoC.done

top: .top_tb.done work
	$(VSIM_CMD) top_tb



.top_tb.done: top_tb.sv $(syn_files_done)
	$(VLOG_CMD) $< &&  touch $@

.DE1_SoC.done: ../nios2/DE1_SoC.sv | work
	$(VLOG_CMD) $< &&  touch $@

.nios_sys.done: ../nios2/nios_sys/synthesis/nios_sys.v
	$(VLOG_CMD) $< &&  touch $@

.%.done:$(syn_dir)%.v | work
	$(VLOG_CMD) $< &&  touch $@
.%.done:$(syn_dir)%.sv | work
	$(VLOG_CMD) $< &&  touch $@

.%.done:../rtl_src/%.v | work
	$(VLOG_CMD) $< &&  touch $@
.%.done:../rtl_src/%.sv | work
	$(VLOG_CMD) $< &&  touch $@

clean:
	rm -rf work
	rm -f transcript
	rm -f vsim.wlf
	rm -rf .*.done

work:
	vlib work

# dependencies to pkg
#.DES_DP.done : .DES_pkg.done
