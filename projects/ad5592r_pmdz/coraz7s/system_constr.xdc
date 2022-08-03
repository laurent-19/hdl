##PMOD header JA
set_property -dict {PACKAGE_PIN Y17  IOSTANDARD LVCMOS33} [get_ports { spi_cs } ] 
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports { spi_mosi }  ]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports { spi_miso }  ] 
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports { spi_sclk } ]
    
##PMOD header JB
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports { m2k_cs } ]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports { m2k_mosi } ]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports { m2k_miso } ]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports { m2k_sclk } ]
