# Copyright PoliTO contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0


# Makefile to generates keccak-x-heep files and build the design with fusesoc

MAKE                       = make

# Get the absolute path
mkfile_path := $(shell dirname "$(realpath $(firstword $(MAKEFILE_LIST)))")


# Linker options are 'on_chip' (default),'flash_load','flash_exec','freertos'
LINKER   ?= on_chip
# Target options are 'sim' (default) and 'pynq-z2'
TARGET   ?= sim
# Compiler options are 'gcc' (default) and 'clang'
COMPILER ?= gcc
# Compiler prefix options are 'riscv32-unknown-' (default)
COMPILER_PREFIX ?= riscv32-unknown-
# Arch options are any RISC-V ISA string supported by the CPU. Default 'rv32imc'
ARCH     ?= rv32imc
# Path relative from the location of sw/Makefile from which to fetch source files. The directory of that file is the default value.
SOURCE 	 ?= "."
# 1 external domain for the KECCAK
EXTERNAL_DOMAINS = 1
# Keccak application flags
USE_DMA   ?= 1

ifndef CONDA_DEFAULT_ENV
$(info USING VENV)
FUSESOC = $(PWD)/$(VENV)/fusesoc
PYTHON  = $(PWD)/$(VENV)/python
else
$(info USING MINICONDA $(CONDA_DEFAULT_ENV))
FUSESOC := $(shell which fusesoc)
PYTHON  := $(shell which python)
endif

.PHONY: vendor-update-heep
vendor-update-heep: clean-lock
	@echo "### Updating vendored IPs..."
	find hw/vendor -maxdepth 1 -type f -name "esl_*.vendor.hjson" -exec python3 util/vendor.py -vU '{}' \;



mcu-gen:
	$(MAKE) -f $(XHEEP_MAKE) $(MAKECMDGOALS) CPU=cv32e40px BUS=NtoM MEMORY_BANKS=12 EXTERNAL_DOMAINS=$(EXTERNAL_DOMAINS)

# Applications

app-helloworld:
	$(MAKE) -C sw x_heep_applications/hello_world/hello_world.hex  TARGET=$(TARGET)

app-keccak:
	$(MAKE) -C sw applications/keccak_test/main.hex  TARGET=$(TARGET) USE_DMA=$(USE_DMA)

########################## KYBER-512 ##########################
app-kyber512-keygen: 
	$(MAKE) -C sw applications/kyber512/keygen/keygen.hex TARGET=$(TARGET) SEC_LEVEL=512

app-kyber512-enc: 
	$(MAKE) -C sw applications/kyber512/enc/enc.hex TARGET=$(TARGET)  SEC_LEVEL=512

app-kyber512-dec: 
	$(MAKE) -C sw applications/kyber512/dec/dec.hex TARGET=$(TARGET)  SEC_LEVEL=512

########################## KYBER-768 ##########################
app-kyber768-keygen: 
	$(MAKE) -C sw applications/kyber768/keygen/keygen.hex TARGET=$(TARGET)  SEC_LEVEL=768

app-kyber768-enc: 
	$(MAKE) -C sw applications/kyber768/enc/enc.hex TARGET=$(TARGET)  SEC_LEVEL=768

app-kyber768-dec: 
	$(MAKE) -C sw applications/kyber768/dec/dec.hex TARGET=$(TARGET)  SEC_LEVEL=768


########################## KYBER-1024 ##########################
app-kyber1024-keygen: 
	$(MAKE) -C sw applications/kyber1024/keygen/keygen.hex TARGET=$(TARGET) SEC_LEVEL=1024

app-kyber1024-enc: 
	$(MAKE) -C sw applications/kyber1024/enc/enc.hex TARGET=$(TARGET)  SEC_LEVEL=1024

app-kyber1024-dec: 
	$(MAKE) -C sw applications/kyber1024/dec/dec.hex TARGET=$(TARGET)  SEC_LEVEL=1024

# Simulation

questasim-sim:
	$(FUSESOC) --cores-root . run --no-export --target=sim --tool=modelsim $(FUSESOC_FLAGS) --setup --build vlsi:polito:mcu_keccak 2>&1 | tee buildsim.log

verilator-sim: 
	fusesoc --cores-root . run --no-export --target=sim --tool=verilator $(FUSESOC_FLAGS) --setup --build vlsi:polito:mcu_keccak 2>&1 | tee buildsim.log

run-helloworld-questasim: questasim-sim app-helloworld
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/x_heep_applications/hello_world/hello_world.hex"; \
	cat uart0.log; \
	cd ../../..;

run-helloworld-verilator: verilator-sim app-helloworld
	cd ./build/vlsi_polito_mcu_keccak_0/sim-verilator; \
	./Vtestharness +firmware=../../../sw/x_heep_applications/hello_world/hello_world.hex; \
	cat uart0.log; \
	cd ../../..;

run-keccak-questasim: questasim-sim app-keccak 
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/keccak_test/main.hex"; \
	cat uart0.log; \
	cd ../../..;

run-keccak-questasim-gui: questasim-sim app-keccak
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run-gui PLUSARGS="c firmware=../../../sw/applications/keccak_test/main.hex"; \
	cat uart0.log; \
	cd ../../..;


## @section Vivado

## Builds (synthesis and implementation) the bitstream for the FPGA version using Vivado
## @param FPGA_BOARD=nexys-a7-100t,pynq-z2
## @param FUSESOC_FLAGS=--flag=<flagname>
vivado-keccak-fpga:
	$(FUSESOC) --cores-root . run --no-export --target=$(FPGA_BOARD) $(FUSESOC_FLAGS) --setup --build vlsi:polito:mcu_keccak 2>&1 | tee buildvivado.log

vivado-keccak-fpga-nobuild:
	$(FUSESOC) --cores-root . run --no-export --target=$(FPGA_BOARD) $(FUSESOC_FLAGS) --setup vlsi:polito:mcu_keccak 2>&1 | tee buildvivado.log



# Clean rules
.PHONY: clean clean-build clean-app clean-lock
clean: clean-app clean-sim

clean-sim:
	@rm -rf build
clean-app:
	$(MAKE) -C sw clean
clean-build:
	$(RM) -rf $(BUILD_DIR)
clean-lock:
	$(RM) $(BUILD_DIR)/.*.lock


export HEEP_DIR = hw/vendor/esl_epfl_x_heep/
XHEEP_MAKE = $(HEEP_DIR)external.mk
#include $(XHEEP_MAKE)
