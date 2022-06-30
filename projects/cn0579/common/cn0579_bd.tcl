create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_dac

# ad7768-4 interface

create_bd_port -dir I clk_in
create_bd_port -dir I ready_in
create_bd_port -dir I -from 7 -to 0 data_in
create_bd_port -dir I up_sshot
create_bd_port -dir I -from 1 -to 0 up_format  
create_bd_port -dir I up_crc_enable
create_bd_port -dir I up_crc_4_or_16_n
create_bd_port -dir I -from 32 -to 0 up_status_clr
create_bd_port -dir O -from 32 -to 0 up_status

#dac iic 

ad_ip_instance axi_iic axi_iic_dac
ad_connect iic_dac axi_iic_dac/iic


# adc(cn0579-dma)

ad_ip_instance axi_dmac cn0579_dma
ad_ip_parameter cn0579_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter cn0579_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter cn0579_dma CONFIG.CYCLIC 0
ad_ip_parameter cn0579_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter cn0579_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter cn0579_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter cn0579_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter cn0579_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter cn0579_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# axi_ad77684

ad_ip_instance axi_ad7768 axi_ad77684_adc
ad_ip_parameter axi_ad77684_adc CONFIG.NUM_CHANNELS 4

ad_connect axi_ad77684_adc/s_axi_aclk        sys_ps7/FCLK_CLK0 
ad_connect axi_ad77684_adc/clk_in            clk_in
ad_connect axi_ad77684_adc/ready_in          ready_in
ad_connect axi_ad77684_adc/data_in           data_in
ad_connect axi_ad77684_adc/up_sshot          up_sshot
ad_connect axi_ad77684_adc/up_format         up_format
ad_connect axi_ad77684_adc/up_crc_enable     up_crc_enable
ad_connect axi_ad77684_adc/up_crc_4_or_16_n  up_crc_4_or_16_n
ad_connect axi_ad77684_adc/up_status_clr     up_status_clr
ad_connect axi_ad77684_adc/up_status         up_status


# adc-path channel pack

ad_ip_instance util_cpack2 cn0579_adc_pack
ad_ip_parameter cn0579_adc_pack CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter cn0579_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

ad_connect axi_ad77684_adc/adc_clk         cn0579_adc_pack/clk
ad_connect axi_ad77684_adc/adc_reset       cn0579_adc_pack/reset
ad_connect axi_ad77684_adc/adc_valid       cn0579_adc_pack/fifo_wr_en
ad_connect  axi_ad77684_adc/adc_dovf       cn0579_adc_pack/fifo_wr_overflow 



for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_ad77684_adc/adc_data_$i   cn0579_adc_pack/fifo_wr_data_$i
  ad_connect axi_ad77684_adc/adc_enable_$i cn0579_adc_pack/enable_$i
}

# dma connections
ad_connect  cn0579_dma/m_dest_axi_aresetn       sys_cpu_resetn                   
ad_connect  cn0579_dma/fifo_wr_clk              axi_ad77684_adc/adc_clk                
ad_connect  cn0579_dma/fifo_wr                  cn0579_adc_pack/packed_fifo_wr   


# interrupts

ad_cpu_interrupt "ps-13" "mb-13"  cn0579_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" axi_iic_dac/iic2intc_irpt

# cpu / memory interconnects

ad_cpu_interconnect 0x44a00000 axi_ad77684_adc 
ad_cpu_interconnect 0x44a30000 cn0579_dma
ad_cpu_interconnect 0x44a40000 axi_iic_dac

ad_mem_hp0_interconnect $sys_cpu_clk    cn0579_dma/m_dest_axi
