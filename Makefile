# Top level makefile for a simplified Rocketchip build flow
# Boris V.Kuznetsov
# Neurodyne Systems


JVM_MEMORY ?= 4G

MYNAME ?= $(shell whoami)

# Take dependencies from a local repo
JARS_HOME ?= /home/$(MYNAME)/.ivy2/local/edu.berkeley.cs
FIRRTL_JAR ?= $(JARS_HOME)/firrtl_2.12/1.2-SNAPSHOT/jars/firrtl_2.12.jar
CHISEL3_JAR ?= $(JARS_HOME)/chisel3_2.12/3.2-SNAPSHOT/jars/chisel3_2.12.jar

# Local definitions
BASE ?= $(shell pwd)
PRJ_JAR ?= $(BASE)/target/scala-2.12/rocketchip_2.12-1.2.jar
OUTDIR ?= $(BASE)/sim/generated-src
LAUNCHER ?= $(BASE)/sbt-launch.jar
TESTNAME ?= TestHarness

FIRRTL ?= java -Xmx$(JVM_MEMORY) -Xss8M -cp $(FIRRTL_JAR):$(CHISEL3_JAR):$(PRJ_JAR) firrtl.Driver

PREFIX ?= freechips.rocketchip.system
CONFIG ?= TinyConfig

FULL_NAME ?= $(PREFIX).$(CONFIG)

VLSI_MEM_GEN ?= $(BASE_dir)/scripts/vlsi_mem_gen

firrtl = $(OUTDIR)/$(FULL_NAME).fir
verilog = \
  $(OUTDIR)/$(FULL_NAME).v \
  $(OUTDIR)/$(FULL_NAME).behav_srams.v \

show:
	@echo "**** Rocketchip build flow ****"
	@echo "make fir - compile Chisel sources and generate FIRRTL output"
	@echo "make vlog - compile FIRRTL and generate Verilog"

# Compile firrtl
fir:
	@echo "Compiling Chisel sources..."
	@sbt 'runMain $(PREFIX).Generator $(OUTDIR) $(PREFIX) $(TESTNAME) $(PREFIX) $(CONFIG)'

# Generate verilog here
vlog: $(verilog)

%.v %.conf: %.fir $(FIRRTL_JAR)
	mkdir -p $(dir $@)
	$(FIRRTL) $(patsubst %,-i %,$(filter %.fir,$^)) -o $*.v -X verilog --infer-rw $(TESTNAME) --repl-seq-mem -c:$(TESTNAME):-o:$*.conf -faf $*.anno.json -td $(OUTDIR)/$(FULL_NAME)/

$(OUTDIR)/$(FULL_NAME).behav_srams.v : $(OUTDIR)/$(FULL_NAME).conf $(VLSI_MEM_GEN)
	cd $(OUTDIR) && \
	$(VLSI_MEM_GEN) $(OUTDIR)/$(FULL_NAME).conf > $@.tmp && \
	mv -f $@.tmp $@

clean:
	@rm -rf $(OUTDIR)/* 

allclean:
	@make clean 
	@rm -rf target/ macros/target project/target project/project/target 
	@rm -rf chisel3/ hardfloat/
