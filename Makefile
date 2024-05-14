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

## Kyber sec level
SEC_LEVEL ?= 512

ifndef CONDA_DEFAULT_ENV
$(info USING VENV)
FUSESOC = $(PWD)/$(VENV)/fusesoc
PYTHON  = $(PWD)/$(VENV)/python
else
$(info USING MINICONDA $(CONDA_DEFAULT_ENV))
FUSESOC := $(shell which fusesoc)
PYTHON  := $(shell which python)
endif

mcu-gen:
	$(MAKE) -f $(XHEEP_MAKE) $(MAKECMDGOALS) CPU=cv32e40p BUS=NtoM MEMORY_BANKS=12 EXTERNAL_DOMAINS=$(EXTERNAL_DOMAINS)

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

########################## KYBER-512 ##########################

run-kyber512-keygen-questasim: questasim-sim app-kyber512-keygen
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber512/keygen/keygen.hex"; \
	cat uart0.log; \
	mv uart0.log keygen512.log; \
	mv keygen512.log ../../../results; \
	cd ../../..;

run-kyber512-enc-questasim: questasim-sim app-kyber512-enc
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber512/enc/enc.hex"; \
	cat uart0.log; \
	mv uart0.log enc512.log; \
	mv enc512.log ../../../results; \
	cd ../../..;

run-kyber512-dec-questasim: questasim-sim app-kyber512-dec
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber512/dec/dec.hex"; \
	cat uart0.log; \
	mv uart0.log dec512.log; \
	mv dec512.log ../../../results; \
	cd ../../..;

########################## KYBER-768 ##########################

run-kyber768-keygen-questasim: questasim-sim app-kyber768-keygen
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber768/keygen/keygen.hex"; \
	cat uart0.log; \
	mv uart0.log keygen768.log; \
	mv keygen768.log ../../../results; \
	cd ../../..;

run-kyber768-enc-questasim: questasim-sim app-kyber768-enc
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber768/enc/enc.hex"; \
	cat uart0.log; \
	mv uart0.log enc768.log; \
	mv enc768.log ../../../results; \
	cd ../../..;

run-kyber768-dec-questasim: questasim-sim app-kyber768-dec
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber768/dec/dec.hex"; \
	cat uart0.log; \
	mv uart0.log dec768.log; \
	mv dec768.log ../../../results; \
	cd ../../..;


########################## KYBER-1024 ##########################

run-kyber1024-keygen-questasim: questasim-sim app-kyber1024-keygen
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber1024/keygen/keygen.hex"; \
	cat uart0.log; \
	mv uart0.log keygen1024.log; \
	mv keygen1024.log ../../../results; \
	cd ../../..;

run-kyber1024-enc-questasim: questasim-sim app-kyber1024-enc
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber1024/enc/enc.hex"; \
	cat uart0.log; \
	mv uart0.log enc1024.log; \
	mv enc1024.log ../../../results; \
	cd ../../..;

run-kyber1024-dec-questasim: questasim-sim app-kyber1024-dec
	cd ./build/vlsi_polito_mcu_keccak_0/sim-modelsim; \
	make run PLUSARGS="c firmware=../../../sw/applications/kyber1024/dec/dec.hex"; \
	cat uart0.log; \
	mv uart0.log dec1024.log; \
	mv dec1024.log ../../../results; \
	cd ../../..;

## @section Vivado

## Builds (synthesis and implementation) the bitstream for the FPGA version using Vivado
## @param FPGA_BOARD=nexys-a7-100t,pynq-z2
## @param FUSESOC_FLAGS=--flag=<flagname>
vivado-keccak-fpga:
	$(FUSESOC) --cores-root . run --no-export --target=$(FPGA_BOARD) $(FUSESOC_FLAGS) --setup --build vlsi:polito:mcu_keccak 2>&1 | tee buildvivado.log

vivado-keccak-fpga-nobuild:
	$(FUSESOC) --cores-root . run --no-export --target=$(FPGA_BOARD) $(FUSESOC_FLAGS) --setup vlsi:polito:mcu_keccak 2>&1 | tee buildvivado.log

clean: clean-app clean-sim

clean-sim:
	@rm -rf build

clean-app:
	$(MAKE) -C sw clean

export HEEP_DIR = hw/vendor/esl_epfl_x_heep/
XHEEP_MAKE = $(HEEP_DIR)external.mk
#include $(XHEEP_MAKE)

