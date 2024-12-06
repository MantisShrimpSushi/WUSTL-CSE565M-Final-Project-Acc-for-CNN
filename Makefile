# Copyright 2019-2021 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MK_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
COMMON_REPO ?= $(shell bash -c 'export MK_PATH=$(MK_PATH); echo $${MK_PATH%fir11/*}')
PWD = $(shell readlink -f .)
XF_PROJ_ROOT = $(shell readlink -f $(COMMON_REPO))

PLATFORM_BLOCKLIST += nodma 
PLATFORM ?= xilinx_u250_gen3x16_xdma_4_1_202210_1

HOST_ARCH := x86

include makefile_us_alveo.mk

SHELL := /usr/bin/bash

############################ Compiler and Flags ############################
CXX := g++
CXXFLAGS := -Wall -O0 -g -std=c++1y \
            -Iinclude \
            -I/opt/xilinx/xrt/include \
            -I/tools/Xilinx/Vitis_HLS/2023.1/include/ \
            -I/home/haoyuz/Vitis_Accel_Examples/common/includes/cmdparser \
            -I/home/haoyuz/Vitis_Accel_Examples/common/includes/logger
LDFLAGS := -L/opt/xilinx/xrt/lib -lOpenCL -lxrt_coreutil -lrt -pthread -luuid

############################ Sources and Objects ############################
# Add all .cpp files explicitly
SRCS := src/fir11_host.cpp \
        /home/haoyuz/Vitis_Accel_Examples/common/includes/cmdparser/cmdlineparser.cpp \
        /home/haoyuz/Vitis_Accel_Examples/common/includes/logger/logger.cpp \
        src/cnn.cpp \
        src/conv.cpp \
        src/dense.cpp \
        src/flat.cpp \
        src/pool.cpp \
        src/utils.cpp

OBJS := $(SRCS:.cpp=.o)

############################ Build Rules ############################
all: fir11_xrt

fir11_xrt: $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) fir11_xrt

cleanall: clean
	rm -f *.xclbin *.log *.json

############################## Help Section ##############################
help:
	@echo "Makefile Usage:"
	@echo "  make all TARGET=<sw_emu/hw_emu/hw> PLATFORM=<FPGA platform> EDGE_COMMON_SW=<rootfs and kernel image path>"
	@echo "      Command to generate the design for specified Target and Shell."
	@echo ""
	@echo "  make run TARGET=<sw_emu/hw_emu/hw> PLATFORM=<FPGA platform> EMU_PS=<X86/QEMU> EDGE_COMMON_SW=<rootfs and kernel image path>"
	@echo "      Command to run application in emulation. Default sw_emu will run on x86, to launch on qemu specify EMU_PS=QEMU."
	@echo ""
	@echo "  make build TARGET=<sw_emu/hw_emu/hw> PLATFORM=<FPGA platform> EDGE_COMMON_SW=<rootfs and kernel image path>"
	@echo "      Command to build xclbin application."
	@echo ""
	@echo "  make host PLATFORM=<FPGA platform> EDGE_COMMON_SW=<rootfs and kernel image path>"
	@echo "      Command to build host application."
	@echo "      EDGE_COMMON_SW is required for SoC shells. Please download and use the pre-built image from - "
	@echo "      https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html"
	@echo ""
	@echo "  make sd_card TARGET=<sw_emu/hw_emu/hw> PLATFORM=<FPGA platform> EDGE_COMMON_SW=<rootfs and kernel image path>"
	@echo "      Command to prepare sd_card files."
	@echo ""
	@echo "  make clean "
	@echo "      Command to remove the generated non-hardware files."
	@echo ""
	@echo "  make cleanall"
	@echo "      Command to remove all the generated files."
	@echo ""
