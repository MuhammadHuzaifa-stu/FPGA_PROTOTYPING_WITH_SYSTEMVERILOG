# CUR_DIR := $(shell realpath .)

# Top level and simulation parameters
TOP       ?= barrel_shifter
TESTBENCH ?= tb_barrel_shifter

FSDB   ?= 1
VCD	   ?= 1

TEST_ARGS += +FSDB=$(FSDB)
TEST_ARGS += +VCD=$(VCD)
TEST_ARGS += -cm line+cond+fsm+tgl+branch

LOGFILE = vcs_compile.log
# VCS defines
VCS_DEFINES += +define+VCS
VCS_DEFINES += -cm line+cond+fsm+tgl+branch
ifeq ($(FSDB), 1)
	VCS_DEFINES += +define+FSDB
endif
ifeq ($(VCD), 1)
	VCS_DEFINES += +define+VCD
endif

CLEAN_TARGETS += *.log *.txt simv* csrc* *.fsdb *.vcd logs verdiLog novas.rc opengui verdi_config_file

.PHONY: all compile simulate gui_install clean

all: compile simulate gui_install

compile:
	@echo "Compiling & Elaborating with VCS..."
	@vcs -full64 -nc -sverilog -assert svaext -f ./flist.rtl -top $(TESTBENCH) $(VCS_DEFINES) -debug_access+all -kdb -o simv | tee -a $(LOGFILE)

simulate: simv
	@echo "Running simulation..."
	@./simv +vcs+lic+wait $(TEST_ARGS)

simv:
	@echo "Checking for compiled simulation executable..."
	@if [ ! -f simv ]; then \
		echo "Error: Simulation executable 'simv' not found. Please run 'make compile' first."; \
		exit 1; \
	fi

gui_install: simv
	@bash -c "install -m 775 <(echo '') opengui"
	@echo 'verdi -ssf debug.fsdb -licqueue' >> opengui

clean:
	@echo "Cleaning up generated files..."
	@rm -rf $(CLEAN_TARGETS)

view_cov:
	urg -dir simv.vdb
	# this opens the browser (Linux)
	firefox urgReport/dashboard.html &