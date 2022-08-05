

set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk ] 
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports  adc_spi_sdi  ]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports  adc_spi_sdo  ] 
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports  adc_spi_cs   ]    

set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk_scopy]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports adc_spi_sdi_scopy ]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports adc_spi_sdo_scopy ]
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS33} [get_ports adc_spi_cs_scopy  ]

## JA Pmod - Bank 13
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN Y11  [get_ports {JA1}];  # "JA1"
#set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
#set_property PACKAGE_PIN AA11 [get_ports {JA2}];  # "JA2"
#set_property PACKAGE_PIN Y10  [get_ports {JA3}];  # "JA3"
#set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
#set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"
## ----------------------------------------------------------------------------
## JB Pmod - Bank 13
## ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN W12 [get_ports {JB1}];  # "JB1"
#set_property PACKAGE_PIN V8 [get_ports {JB10}];  # "JB10"
#set_property PACKAGE_PIN W11 [get_ports {JB2}];  # "JB2"
#set_property PACKAGE_PIN V10 [get_ports {JB3}];  # "JB3"
#set_property PACKAGE_PIN W8 [get_ports {JB4}];  # "JB4"
#set_property PACKAGE_PIN V12 [get_ports {JB7}];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports {JB8}];  # "JB8"
#set_property PACKAGE_PIN V9 [get_ports {JB9}];  # "JB9"

