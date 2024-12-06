################################################################################
## Create the Vitis HLS project using the following command:
## $ vitis_hls -f create_project.tcl
################################################################################

open_project Project
set_top cnn
add_files cnn.cpp
add_files conv.cpp
add_files dense.cpp
add_files flat.cpp
add_files pool.cpp
add_files utils.cpp
add_files -tb cnn_tb.cpp
add_files -tb ../02-Data
open_solution "solution1" -flow_target vivado
set_part {xc7a200tfbg484-1}
create_clock -period 10 -name default
source "directives.tcl"
