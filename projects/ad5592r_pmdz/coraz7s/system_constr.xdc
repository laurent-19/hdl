

set_property -dict {PACKAGE_PIN Y17  IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk ] 
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports  adc_spi_sdi  ]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports  adc_spi_sdo  ] 
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports  adc_spi_cs   ]    

set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk_scopy]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports adc_spi_sdi_scopy ]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports adc_spi_sdo_scopy ]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports adc_spi_cs_scopy  ]


## Pmod Header JA
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_L17P_T2_34 Sch=ja_p[1]
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L17N_T2_34 Sch=ja_n[1]
#set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L7P_T1_34 Sch=ja_p[2]
#set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L7N_T1_34 Sch=ja_n[2]



## Pmod Header JB
#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L8P_T1_34 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L8N_T1_34 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L1P_T0_34 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L1N_T0_34 Sch=jb_n[2]

