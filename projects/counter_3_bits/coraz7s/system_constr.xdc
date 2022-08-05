
set_property -dict {PACKAGE_PIN Y18  IOSTANDARD LVCMOS33} [get_ports led0  ] 
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33}  [get_ports led1  ]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33}  [get_ports led2  ] 
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33}  [get_ports reset_btn  ] 
 

## Pmod Header JA
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_L17P_T2_34 Sch=ja_p[1]
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L17N_T2_34 Sch=ja_n[1]
#set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L7P_T1_34 Sch=ja_p[2]
#set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L7N_T1_34 Sch=ja_n[2]

