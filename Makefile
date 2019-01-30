# Top level makefile for a simplified Rocketchip build flow
# Boris V.Kuznetsov
# Neurodyne Systems
include Makefrag

show:
	@echo "**** Rocketchip build flow ****"
	@echo "make fir - compile Chisel sources and generate FIRRTL output"
	@echo "make vlog - compile FIRRTL and generate Verilog"
	@echo "make vsim - run Verilog simulation with Verilator"
	@echo "make vdbg - run Verilog debug simulation with Verilator"

# Compile firrtl
fir:
	@echo "Compiling Chisel sources..."
	@sbt 'runMain $(PREFIX).Generator $(OUTDIR) $(PREFIX) $(TESTNAME) $(PREFIX) $(CONFIG)'

# Generate verilog here
vlog: $(verilog)

SIMOUT = $(SIMDIR)/$(TESTNAME)
DBGOUT = $(SIMOUT)_dbg

vsim: $(verilog) $(cppfiles) $(headers)
	mkdir -p $(SIMOUT)
	$(VERI) $(VERI_FLAGS) -Mdir $(SIMOUT) \
	-o $(abspath $(SIMDIR))/$@ $(verilog) $(cppfiles) -LDFLAGS "$(LDFLAGS)" \
	-CFLAGS "-I$(SIMDIR) -include V$(TESTNAME).h"
	$(MAKE) VM_PARALLEL_BUILDS=1 -C $(SIMOUT) -f V$(TESTNAME).mk

vdbg: $(verilog) $(cppfiles) $(headers)
	mkdir -p $(DBGOUT)
	$(VERI) $(VERI_FLAGS) -Mdir $(DBGOUT) --trace  \
	-o $(abspath $(SIMDIR))/$@ $(verilog) $(cppfiles) -LDFLAGS "$(LDFLAGS)" \
	-CFLAGS "-I$(SIMDIR) -include V$(TESTNAME).h"
	$(MAKE) VM_PARALLEL_BUILDS=1 -C $(DBGOUT) -f V$(TESTNAME).mk

# Ram generator
$(OUTDIR)/$(FULL_NAME).behav_srams.v : $(OUTDIR)/$(FULL_NAME).conf $(VLSI_MEM_GEN)
	cd $(OUTDIR) && \
	$(VLSI_MEM_GEN) $(OUTDIR)/$(FULL_NAME).conf > $@.tmp && \
	mv -f $@.tmp $@


# Clean options
cleansim:
	@rm -rf $(SIMDIR)/*

clean: cleansim
	@rm -rf $(OUTDIR)/* 

allclean:
	@make clean 
	@rm -rf target/ macros/target project/target project/project/target 
	@rm -rf chisel3/ hardfloat/
