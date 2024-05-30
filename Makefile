# Copyright PoliTO contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0


# Makefile to generates keccak-x-heep files and build the design with fusesoc

MAKE                       = make
ROOT_DIR			:= $(realpath .)
BUILD_DIR			:= $(ROOT_DIR)/build
LOG_DIR				:= $(BUILD_DIR)/logs

# Get the absolute path
mkfile_path := $(shell dirname "$(realpath $(firstword $(MAKEFILE_LIST)))")


# Target options are 'sim' (default) and 'pynq-z2'
TARGET   			?= sim

# Linker options are 'on_chip' (default),'flash_load','flash_exec','freertos'
LINKER   			?= on_chip

# X-HEEP configuration
XHEEP_DIR			:= $(ROOT_DIR)/hw/vendor/polito_vlsi_lab_athos_heep/hw/vendor/esl_epfl_x_heep
ATHOS_DIR			:= $(ROOT_DIR)/hw/vendor/polito_vlsi_lab_athos_heep/hw/vendor/polito_vlsi_lab_athos
MCU_CFG				?= $(ROOT_DIR)/config/mcu-gen.hjson
PAD_CFG				?= $(ROOT_DIR)/config/heep-pads.hjson
APP_DIR				:= $(ROOT_DIR)/sw/applications
EXTERNAL_DOMAINS 	:= 1 # athos accelerator
MCU_GEN_OPTS		:= \
	MCU_CFG=$(MCU_CFG) \
	PAD_CFG=$(PAD_CFG) \
	EXTERNAL_DOMAINS=$(EXTERNAL_DOMAINS)
MCU_GEN_LOCK		:= $(BUILD_DIR)/.mcu-gen.lock

# RTL simulation configuration
FIRMWARE 			?= $(ROOT_DIR)/sw/build/main.hex
BYPASS_FLL			?= 1 # 0: use FLL, 1: bypass FLL
FUSESOC_FLAGS		?=
FUSESOC_ARGS		?=

# Application-specific makefile
APP_MAKE  			:= $(wildcard sw/applications/$(PROJECT)/*akefile)
APP_MAKE_PARAMS		?=

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
esl_epfl_x_heep-sync:
	@echo "### Modifiying esl_epfl_x_heep repository..."
	rsync -a config/rv_plic.c hw/vendor/esl_epfl_x_heep/sw/device/lib/drivers/rv_plic/rv_plic.c
	rsync -a config/rv_plic.h hw/vendor/esl_epfl_x_heep/sw/device/lib/drivers/rv_plic/rv_plic.h
	rsync -a config/dma.c hw/vendor/esl_epfl_x_heep/sw/device/lib/drivers/dma/dma.c
	rsync -a config/dma.h hw/vendor/esl_epfl_x_heep/sw/device/lib/drivers/dma/dma.h
	rsync -a config/core_v_mini_mcu.sv hw/vendor/esl_epfl_x_heep/hw/system/x_heep_system.sv
	rsync -a config/x_heep_system.sv hw/vendor/esl_epfl_x_heep/hw/core-v-mini-mcu/core_v_mini_mcu.sv
	rsync -a config/cv32e40px_x_disp.sv hw/vendor/esl_epfl_x_heep/hw/vendor/esl_epfl_cv32e40px/rtl/cv32e40px_x_disp.sv

mcu-gen:
	$(MAKE) -f $(XHEEP_MAKE) $(MAKECMDGOALS) CPU=cv32e40px BUS=NtoM MEMORY_BANKS=12 EXTERNAL_DOMAINS=$(EXTERNAL_DOMAINS)

# Applications

app-helloworld:
	$(MAKE) -C sw x_heep_applications/hello_world/hello_world.hex  TARGET=$(TARGET)

app-keccak-xif:
	$(MAKE) -C sw applications/keccak_test_xif/keccak_xif.hex  TARGET=$(TARGET) USE_DMA=$(USE_DMA)


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

run-keccak-xif-questasim: questasim-sim app-keccak-xif
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/keccak_test_xif/keccak_xif.hex"; \
	cat uart0.log; \
	cd ../../..;

run-keccak-xif-questasim-gui: questasim-sim app-keccak-xif
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run-gui PLUSARGS="c firmware=../../../sw/applications/keccak_test_xif/keccak_xif.hex"; \
	cat uart0.log; \
	cd ../../..;


## @section Vivado

## Builds (synthesis and implementation) the bitstream for the FPGA version using Vivado
## @param FPGA_BOARD=nexys-a7-100t,pynq-z2
## @param FUSESOC_FLAGS=--flag=<flagname>

## @section Design Compiler
asic:
	$(FUSESOC) --cores-root . run --no-export --target=asic_synthesis $(FUSESOC_FLAGS) --setup vlsi:polito:mcu_keccak ${FUSESOC_PARAM} 2>&1 | tee builddesigncompiler.log

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

