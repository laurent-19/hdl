## This file is a general .xdc for the Cora Z7-07S Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## PL System Clock
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];#set

#Author: Sopterean Calin-Vasile

## Pmod Header JA (SPI)
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { SPI_CS }]; #IO_L17P_T2_34 Sch=ja_p[1]
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { SPI_MOSI }]; #IO_L17N_T2_34 Sch=ja_n[1]
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { SPI_MISO }]; #IO_L7P_T1_34 Sch=ja_p[2]
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { SPI_SCK }]; #IO_L7N_T1_34 Sch=ja_n[2]

## Pmod Header JB (M2K)
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { M2K_SPI_CS }]; #IO_L8P_T1_34 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { M2K_SPI_MOSI }]; #IO_L8N_T1_34 Sch=jb_n[1]
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { M2K_SPI_MISO }]; #IO_L1P_T0_34 Sch=jb_p[2]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { M2K_SPI_SCK }]; #IO_L1N_T0_34 Sch=jb_n[2]
