source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 dac_0_spi
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 dac_1_spi

# ltc2387

create_bd_port -dir O clk_gate
create_bd_port -dir O sampling_clk

create_bd_port -dir I rx_0_dco_p
create_bd_port -dir I rx_0_dco_n
create_bd_port -dir O rx_0_cnv
create_bd_port -dir I rx_0_da_p
create_bd_port -dir I rx_0_da_n
create_bd_port -dir I rx_0_db_p
create_bd_port -dir I rx_0_db_n

create_bd_port -dir I rx_1_dco_p
create_bd_port -dir I rx_1_dco_n
create_bd_port -dir O rx_1_cnv
create_bd_port -dir I rx_1_da_p
create_bd_port -dir I rx_1_da_n
create_bd_port -dir I rx_1_db_p
create_bd_port -dir I rx_1_db_n

create_bd_port -dir I rx_2_dco_p
create_bd_port -dir I rx_2_dco_n
create_bd_port -dir O rx_2_cnv
create_bd_port -dir I rx_2_da_p
create_bd_port -dir I rx_2_da_n
create_bd_port -dir I rx_2_db_p
create_bd_port -dir I rx_2_db_n

create_bd_port -dir I rx_3_dco_p
create_bd_port -dir I rx_3_dco_n
create_bd_port -dir O rx_3_cnv
create_bd_port -dir I rx_3_da_p
create_bd_port -dir I rx_3_da_n
create_bd_port -dir I rx_3_db_p
create_bd_port -dir I rx_3_db_n

# max7301

create_bd_port -dir I max_spi_csn_i
create_bd_port -dir O max_spi_csn_o
create_bd_port -dir I max_spi_clk_i
create_bd_port -dir O max_spi_clk_o
create_bd_port -dir I max_spi_sdo_i
create_bd_port -dir O max_spi_sdo_o
create_bd_port -dir I max_spi_sdi_i

create_bd_port -dir I dac1_spi_csn_i
create_bd_port -dir O dac1_spi_csn_o
create_bd_port -dir I dac1_spi_clk_i
create_bd_port -dir O dac1_spi_clk_o
create_bd_port -dir I dac1_spi_sdo_i
create_bd_port -dir O dac1_spi_sdo_o
create_bd_port -dir I dac1_spi_sdi_i

create_bd_port -dir I dac2_spi_csn_i
create_bd_port -dir O dac2_spi_csn_o
create_bd_port -dir I dac2_spi_clk_i
create_bd_port -dir O dac2_spi_clk_o
create_bd_port -dir I dac2_spi_sdo_i
create_bd_port -dir O dac2_spi_sdo_o
create_bd_port -dir I dac2_spi_sdi_i


ad_ip_instance axi_ltc2387 axi_ltc2387_0
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_0 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_0 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_INIT_DELAY 27
#
ad_ip_instance axi_ltc2387 axi_ltc2387_1
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_1 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_1 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_1 CONFIG.IODELAY_CTRL 0
#
ad_ip_instance axi_ltc2387 axi_ltc2387_2
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_2 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_2 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_2 CONFIG.IO_DELAY_GROUP adc_if_delay_group2
#
ad_ip_instance axi_ltc2387 axi_ltc2387_3
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_3 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_3 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_INIT_DELAY 28
ad_ip_parameter axi_ltc2387_3 CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ltc2387_3 CONFIG.IODELAY_CTRL 0

# axi_pwm_gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 4
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

# constant 1

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_vcc_1

# sys_rstgen

ad_ip_instance proc_sys_reset pack_sys_rstgen
ad_ip_parameter pack_sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# util_cpack2

ad_ip_instance util_cpack2 util_ltc2387_adc_pack
ad_ip_parameter util_ltc2387_adc_pack CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter util_ltc2387_adc_pack CONFIG.SAMPLE_DATA_WIDTH 16

# dma

ad_ip_instance axi_dmac axi_ltc2387_dma
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance axi_clkgen axi_clkgen
ad_ip_parameter axi_clkgen CONFIG.ID 1
ad_ip_parameter axi_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 6
ad_ip_parameter axi_clkgen CONFIG.CLK0_DIV 5

ad_connect sys_ps7/FCLK_CLK0  axi_clkgen/clk
ad_connect axi_clkgen/clk_0   sampling_clk

ad_connect sys_ps7/FCLK_RESET0_N  pack_sys_rstgen/ext_reset_in
ad_connect axi_clkgen/clk_0       pack_sys_rstgen/slowest_sync_clk
ad_connect spi_resetn pack_sys_rstgen/peripheral_aresetn

# ltc adc connections
ad_connect sys_200m_clk axi_ltc2387_0/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_0/ref_clk
ad_connect clk_gate          axi_ltc2387_0/clk_gate
ad_connect rx_0_dco_p        axi_ltc2387_0/dco_p
ad_connect rx_0_dco_n        axi_ltc2387_0/dco_n
ad_connect rx_0_da_n         axi_ltc2387_0/da_n
ad_connect rx_0_da_p         axi_ltc2387_0/da_p
ad_connect rx_0_db_n         axi_ltc2387_0/db_n
ad_connect rx_0_db_p         axi_ltc2387_0/db_p

ad_connect sys_200m_clk axi_ltc2387_1/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_1/ref_clk
ad_connect clk_gate          axi_ltc2387_1/clk_gate
ad_connect rx_1_dco_p        axi_ltc2387_1/dco_p
ad_connect rx_1_dco_n        axi_ltc2387_1/dco_n
ad_connect rx_1_da_n         axi_ltc2387_1/da_n
ad_connect rx_1_da_p         axi_ltc2387_1/da_p
ad_connect rx_1_db_n         axi_ltc2387_1/db_n
ad_connect rx_1_db_p         axi_ltc2387_1/db_p

ad_connect sys_200m_clk axi_ltc2387_2/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_2/ref_clk
ad_connect clk_gate          axi_ltc2387_2/clk_gate
ad_connect rx_2_dco_p        axi_ltc2387_2/dco_p
ad_connect rx_2_dco_n        axi_ltc2387_2/dco_n
ad_connect rx_2_da_n         axi_ltc2387_2/da_n
ad_connect rx_2_da_p         axi_ltc2387_2/da_p
ad_connect rx_2_db_n         axi_ltc2387_2/db_n
ad_connect rx_2_db_p         axi_ltc2387_2/db_p

ad_connect sys_200m_clk axi_ltc2387_3/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_3/ref_clk
ad_connect clk_gate          axi_ltc2387_3/clk_gate
ad_connect rx_3_dco_p        axi_ltc2387_3/dco_p
ad_connect rx_3_dco_n        axi_ltc2387_3/dco_n
ad_connect rx_3_da_n         axi_ltc2387_3/da_n
ad_connect rx_3_da_p         axi_ltc2387_3/da_p
ad_connect rx_3_db_n         axi_ltc2387_3/db_n
ad_connect rx_3_db_p         axi_ltc2387_3/db_p

ad_connect rx_0_cnv   axi_pwm_gen/pwm_0
ad_connect rx_1_cnv   axi_pwm_gen/pwm_0
ad_connect rx_2_cnv   axi_pwm_gen/pwm_0
ad_connect rx_3_cnv   axi_pwm_gen/pwm_0
ad_connect clk_gate   axi_pwm_gen/pwm_1

ad_connect axi_clkgen/clk_0       axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn         axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk            axi_pwm_gen/s_axi_aclk
ad_connect axi_clkgen/clk_0                  util_ltc2387_adc_pack/clk
ad_connect pack_sys_rstgen/peripheral_reset  util_ltc2387_adc_pack/reset

#debug
ad_ip_instance axi_adc_decimate axi_adc_decimate_0
ad_ip_parameter axi_adc_decimate_0 CONFIG.CORRECTION_DISABLE {0}
ad_connect sampling_clk axi_adc_decimate_0/adc_clk
ad_connect pack_sys_rstgen/peripheral_reset axi_adc_decimate_0/adc_rst
ad_connect axi_adc_decimate_0/adc_data_a axi_ltc2387_0/adc_data
ad_connect axi_adc_decimate_0/adc_data_b axi_ltc2387_1/adc_data
ad_connect axi_adc_decimate_0/adc_valid_a axi_ltc2387_0/adc_valid
ad_connect axi_adc_decimate_0/adc_valid_b axi_ltc2387_1/adc_valid
ad_connect axi_adc_decimate_0/adc_dec_data_a util_ltc2387_adc_pack/fifo_wr_data_0
ad_connect axi_adc_decimate_0/adc_dec_data_b util_ltc2387_adc_pack/fifo_wr_data_1

ad_ip_instance axi_adc_decimate axi_adc_decimate_1
ad_ip_parameter axi_adc_decimate_1 CONFIG.CORRECTION_DISABLE {0}
ad_connect sampling_clk axi_adc_decimate_1/adc_clk
ad_connect pack_sys_rstgen/peripheral_reset axi_adc_decimate_1/adc_rst
ad_connect axi_adc_decimate_1/adc_data_a axi_ltc2387_2/adc_data
ad_connect axi_adc_decimate_1/adc_data_b axi_ltc2387_3/adc_data
ad_connect axi_adc_decimate_1/adc_valid_a axi_ltc2387_2/adc_valid
ad_connect axi_adc_decimate_1/adc_valid_b axi_ltc2387_3/adc_valid
ad_connect axi_adc_decimate_1/adc_dec_data_a util_ltc2387_adc_pack/fifo_wr_data_2
ad_connect axi_adc_decimate_1/adc_dec_data_b util_ltc2387_adc_pack/fifo_wr_data_3

ad_connect axi_adc_decimate_0/adc_dec_valid_a util_ltc2387_adc_pack/fifo_wr_en

for {set i 0} {$i < 4} {incr i} {
  ad_connect const_vcc_1/dout  util_ltc2387_adc_pack/enable_$i
}

ad_connect axi_clkgen/clk_0         axi_ltc2387_dma/fifo_wr_clk

ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_0/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_1/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_2/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_3/adc_dovf
ad_connect util_ltc2387_adc_pack/packed_fifo_wr    axi_ltc2387_dma/fifo_wr

# quad SPI

ad_ip_instance axi_quad_spi max_spi
ad_ip_parameter max_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter max_spi CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter max_spi CONFIG.C_SPI_MODE 0
ad_ip_parameter max_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter max_spi CONFIG.C_NUM_TRANSFER_BITS 16
#
## connections
#
ad_connect sys_ps7/FCLK_CLK0  max_spi/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  max_spi/s_axi_aclk

ad_connect  max_spi_csn_i max_spi/ss_i
ad_connect  max_spi_csn_o max_spi/ss_o
ad_connect  max_spi_clk_i max_spi/sck_i
ad_connect  max_spi_clk_o max_spi/sck_o
ad_connect  max_spi_sdo_i max_spi/io0_i
ad_connect  max_spi_sdo_o max_spi/io0_o
ad_connect  max_spi_sdi_i max_spi/io1_i

#spi engine stuff

set data_width    32
set async_spi_clk 1
set num_cs        1
set num_sdi       4
set num_sdo       4
set sdi_delay     1

set hier_spi_engine_0 spi_ad3552r_0
set hier_spi_engine_1 spi_ad3552r_1

spi_engine_create $hier_spi_engine_0 $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay
spi_engine_create $hier_spi_engine_1 $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay

ad_ip_parameter $hier_spi_engine_0/${hier_spi_engine_0}_offload CONFIG.SDO_MEM_OS 1
ad_ip_parameter $hier_spi_engine_1/${hier_spi_engine_1}_offload CONFIG.SDO_MEM_OS 1

ad_ip_instance axi_pwm_gen pulsar_adc_trigger_gen
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_PERIOD 120
ad_ip_parameter pulsar_adc_trigger_gen CONFIG.PULSE_0_WIDTH 1

#ad_ip_instance axi_dds spi_dds_0
#ad_connect sampling_clk spi_dds_0/spi_clk

#dac0

ad_ip_instance axi_dmac axi_dac_0_dma
ad_ip_parameter axi_dac_0_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_dac_0_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_dac_0_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_dac_0_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_dac_0_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dac_0_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dac_0_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dac_0_dma CONFIG.DMA_DATA_WIDTH_SRC 32 ;#$data_width
ad_ip_parameter axi_dac_0_dma CONFIG.DMA_DATA_WIDTH_DEST 32


#ad_connect $sys_cpu_clk spi_clkgen/clk
#ad_connect spi_clk spi_clkgen/clk_0

ad_connect sampling_clk pulsar_adc_trigger_gen/ext_clk
ad_connect $sys_cpu_clk pulsar_adc_trigger_gen/s_axi_aclk
ad_connect sys_cpu_resetn pulsar_adc_trigger_gen/s_axi_aresetn
ad_connect pulsar_adc_trigger_gen/pwm_0  $hier_spi_engine_0/trigger

ad_connect $hier_spi_engine_0/m_spi dac_0_spi

ad_connect $sys_cpu_clk $hier_spi_engine_0/clk
ad_connect sampling_clk $hier_spi_engine_0/spi_clk
ad_connect sys_cpu_resetn $hier_spi_engine_0/resetn
ad_connect sys_cpu_resetn axi_dac_0_dma/m_src_axi_aresetn
ad_connect sampling_clk axi_dac_0_dma/m_axis_aclk

#ad_ip_instance axis_interconnect axis_interconnect_0
#ad_ip_parameter axis_interconnect_0 CONFIG.NUM_SI 2
#ad_ip_parameter axis_interconnect_0 CONFIG.NUM_MI 1
#ad_ip_parameter axis_interconnect_0 CONFIG.ROUTING_MODE 1

#ad_connect axis_interconnect_0/S00_AXIS axi_dac_0_dma/m_axis
#ad_connect axis_interconnect_0/S01_AXIS spi_dds_0/m_axis_dds
#ad_connect axis_interconnect_0/M00_AXIS $hier_spi_engine_0/s_axis_sample

#ad_connect axis_interconnect_0/ACLK $sys_cpu_clk
#ad_connect axis_interconnect_0/M00_AXIS_ACLK spi_clk
#ad_connect axis_interconnect_0/S01_AXIS_ACLK spi_clk
#ad_connect axis_interconnect_0/S00_AXIS_ACLK $sys_cpu_clk

#ad_connect axis_interconnect_0/S00_ARB_REQ_SUPPRESS GND
#ad_connect axis_interconnect_0/S01_ARB_REQ_SUPPRESS GND

#ad_connect axis_interconnect_0/ARESETN sys_cpu_resetn
#ad_connect axis_interconnect_0/S00_AXIS_ARESETN sys_cpu_resetn
#ad_connect axis_interconnect_0/S_AXI_CTRL_ARESETN sys_cpu_resetn

#ad_connect axis_interconnect_0/M00_AXIS_ARESETN spi_resetn
#ad_connect axis_interconnect_0/S01_AXIS_ARESETN spi_resetn

ad_connect $hier_spi_engine_0/s_axis_sample_0 axi_dac_0_dma/m_axis

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC PROPAGATED] [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins xlconcat_0/In0] [get_bd_pins axi_adc_decimate_0/adc_dec_data_a]
connect_bd_net [get_bd_pins xlconcat_0/In1] [get_bd_pins axi_adc_decimate_0/adc_dec_data_b]
connect_bd_net [get_bd_pins spi_ad3552r_0/s_axis_sample_1_tdata] [get_bd_pins xlconcat_0/dout]
connect_bd_net [get_bd_pins spi_ad3552r_0/s_axis_sample_1_tvalid] [get_bd_pins axi_adc_decimate_0/adc_dec_valid_a]

#ad_connect $hier_spi_engine_0/s_axis_sample_1 spi_dds_0/m_axis_dds
#dac1

#ad_ip_instance axi_dds spi_dds_1
#ad_connect sampling_clk spi_dds_1/spi_clk

ad_ip_instance axi_dmac axi_dac_1_dma
ad_ip_parameter axi_dac_1_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_dac_1_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_dac_1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_dac_1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_dac_1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_dac_1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_dac_1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_dac_1_dma CONFIG.DMA_DATA_WIDTH_SRC 32
ad_ip_parameter axi_dac_1_dma CONFIG.DMA_DATA_WIDTH_DEST 32

ad_connect $hier_spi_engine_1/m_spi dac_1_spi

ad_connect $sys_cpu_clk $hier_spi_engine_1/clk
ad_connect sampling_clk $hier_spi_engine_1/spi_clk
ad_connect sys_cpu_resetn $hier_spi_engine_1/resetn
ad_connect sys_cpu_resetn axi_dac_1_dma/m_src_axi_aresetn
ad_connect sampling_clk axi_dac_1_dma/m_axis_aclk
ad_connect pulsar_adc_trigger_gen/pwm_0  $hier_spi_engine_1/trigger

#ad_ip_instance axis_interconnect axis_interconnect_1
#ad_ip_parameter axis_interconnect_1 CONFIG.NUM_SI 2
#ad_ip_parameter axis_interconnect_1 CONFIG.NUM_MI 1
#ad_ip_parameter axis_interconnect_1 CONFIG.ROUTING_MODE 1

#ad_connect axis_interconnect_1/S00_AXIS axi_dac_1_dma/m_axis
#ad_connect axis_interconnect_1/S01_AXIS spi_dds_1/m_axis_dds
#ad_connect axis_interconnect_1/M00_AXIS $hier_spi_engine_1/s_axis_sample

#ad_connect axis_interconnect_1/ACLK $sys_cpu_clk
#ad_connect axis_interconnect_1/M00_AXIS_ACLK spi_clk
#ad_connect axis_interconnect_1/S01_AXIS_ACLK spi_clk
#ad_connect axis_interconnect_1/S00_AXIS_ACLK $sys_cpu_clk

#ad_connect axis_interconnect_1/S00_ARB_REQ_SUPPRESS GND
#ad_connect axis_interconnect_1/S01_ARB_REQ_SUPPRESS GND

#ad_connect axis_interconnect_1/ARESETN sys_cpu_resetn
#ad_connect axis_interconnect_1/S00_AXIS_ARESETN sys_cpu_resetn
#ad_connect axis_interconnect_1/S_AXI_CTRL_ARESETN sys_cpu_res
#ad_connect axis_interconnect_1/M00_AXIS_ARESETN spi_resetn
#ad_connect axis_interconnect_1/S01_AXIS_ARESETN spi_resetn

ad_connect $hier_spi_engine_1/s_axis_sample_0 axi_dac_1_dma/m_axis

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC PROPAGATED] [get_bd_cells xlconcat_1]
connect_bd_net [get_bd_pins xlconcat_1/In0] [get_bd_pins axi_adc_decimate_1/adc_dec_data_a]
connect_bd_net [get_bd_pins xlconcat_1/In1] [get_bd_pins axi_adc_decimate_1/adc_dec_data_b]
connect_bd_net [get_bd_pins spi_ad3552r_1/s_axis_sample_1_tdata] [get_bd_pins xlconcat_1/dout]
connect_bd_net [get_bd_pins spi_ad3552r_1/s_axis_sample_1_tvalid] [get_bd_pins axi_adc_decimate_1/adc_dec_valid_a]
#ad_connect $hier_spi_engine_1/s_axis_sample_1 spi_dds_1/m_axis_dds
# adc peripheral

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ltc2387_0
ad_cpu_interconnect 0x44A10000 axi_ltc2387_1
ad_cpu_interconnect 0x44A20000 axi_ltc2387_2
ad_cpu_interconnect 0x44A30000 axi_ltc2387_3
ad_cpu_interconnect 0x44A40000 axi_ltc2387_dma
ad_cpu_interconnect 0x44A50000 axi_adc_decimate_0
ad_cpu_interconnect 0x44A60000 axi_adc_decimate_1
ad_cpu_interconnect 0x44B00000 axi_clkgen
ad_cpu_interconnect 0x44B10000 axi_pwm_gen
ad_cpu_interconnect 0x44B20000 max_spi
ad_cpu_interconnect 0x44d00000 $hier_spi_engine_0/${hier_spi_engine_0}_axi_regmap
ad_cpu_interconnect 0x44d30000 axi_dac_0_dma
ad_cpu_interconnect 0x44d50000 pulsar_adc_trigger_gen
#ad_cpu_interconnect 0x44d60000 spi_dds_0
#ad_cpu_interconnect 0x44d70000 axis_interconnect_0

ad_cpu_interconnect 0x44e00000 $hier_spi_engine_1/${hier_spi_engine_1}_axi_regmap
ad_cpu_interconnect 0x44e30000 axi_dac_1_dma
#ad_cpu_interconnect 0x44ef0000 spi_dds_1
#ad_cpu_interconnect 0x44f00000 axis_interconnect_1

# interconnect (adc)

ad_mem_hp0_interconnect sys_cpu_clk axi_dac_0_dma/m_src_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_dac_1_dma/m_src_axi

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ltc2387_dma/m_dest_axi

ad_connect $sys_cpu_resetn axi_ltc2387_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ltc2387_dma/irq
ad_cpu_interrupt ps-8 mb-8 max_spi/ip2intc_irpt
ad_cpu_interrupt ps-7 mb-7 /$hier_spi_engine_0/irq
ad_cpu_interrupt ps-6 mb-6 /$hier_spi_engine_1/irq
ad_cpu_interrupt ps-5 mb-5 axi_dac_0_dma/irq
ad_cpu_interrupt ps-4 mb-4 axi_dac_1_dma/irq
