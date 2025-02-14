SRC=src/top.sv src/cpu.sv src/ram.sv

export BASE=4bit
PROJ=$(BASE).gprj
DEVICE=GW2AR-18C
FS=$(PWD)/impl/pnr/$(BASE).fs

GWSH=/Applications/GowinEDA.app/Contents/Resources/Gowin_EDA/IDE/bin/gw_sh
PRG=/Applications/GowinEDA.app/Contents/Resources/Gowin_EDA/Programmer/bin/programmer_cli

.PHONY: clean synthesize download


synthesize: $(SRC)
	$(GWSH) proj.tcl

download: $(FS)
	# SRAM
	$(PRG) --device $(DEVICE) --fsFile $(FS) --operation_index 2

clean:
	rm -rf obj_dir waveform.vcd waveform.view

