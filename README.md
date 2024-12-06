# WUSTL CSE 565 Final Project

This repository contains the implementation of the final project for the [WUSTL CSE 565M course](https://github.com/cabreraam/WUSTL-CSE565M-Bibliography). The project builds upon work from [Federico Serafini's HLS-CNN repository](https://github.com/FedericoSerafini/HLS-CNN/) and has been adapted for new functionalities.
Author: Renzi Liu, Chenyang Huang, Haoyu Zhang

## Overview

The project is based on **lab_2** and includes both software emulation (`sw_emu`) and hardware build (`hw-build`). It is runnable with the pre-built hardware image located at `hw-built/fir11_xrt`.

### Key Modifications:
1. **Main Code Structure**:  
   The primary codes are located under the `fir11` directory. Notably:
   - `fir11_host.cpp` has been modified to include `cnn.cpp` along with all the necessary CNN layers.

2. **Makefile Updates**:  
   The original Makefile from **lab_2** has been replaced. **Do not use the original lab_2 Makefile** as it is not compatible with this project.

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd WUSTL-CSE565-Final-Project
   ```
3. Download Lab_2 from the course website:
	Replace the src in fir11 with the src in this directory

4. Compile and run using the modified Makefile:
	Copy the Makefile into fir11
	
5. Follow the steps of Lab 2 Manual
	

## Requirements

Ensure the following are installed and configured:
- Xilinx Vitis or Vivado HLS (for hardware builds)
- Compatible FPGA development environment
- GCC or a similar C++ compiler for host code

## References

- [FedericoSerafini/HLS-CNN](https://github.com/FedericoSerafini/HLS-CNN)
- [WUSTL CSE565M Bibliography](https://github.com/cabreraam/WUSTL-CSE565M-Bibliography)

## Contributing

The repository will be closed after the course finishes. If you would like to further implement it, please download and use it directly and with proper reference to WUSTL CSE565M Bibliography

## License

This project adheres to the MIT License. See the `LICENSE` file for details.
