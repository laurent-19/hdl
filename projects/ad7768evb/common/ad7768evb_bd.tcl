
# ad7768 interface

create_bd_port -dir I clk_in
create_bd_port -dir I ready_in
create_bd_port -dir I -from 7 -to 0 data_in
create_bd_port -dir I up_sshot
create_bd_port -dir I -from 1 -to 0 up_format  
create_bd_port -dir I up_crc_enable
create_bd_port -dir I up_crc_4_or_16_n
create_bd_port -dir I -from 32 -to 0 up_status_clr
create_bd_port -dir O -from 32 -to 0 up_status


create_bd_port -dir I -from 31 -to 0 adc_gpio_0_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_0_t
create_bd_port -dir I -from 31 -to 0 adc_gpio_1_i
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_o
create_bd_port -dir O -from 31 -to 0 adc_gpio_1_t

# instances

ad_ip_instance axi_dmac ad7768_dma
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma CONFIG.DMA_DATA_WIDTH_SRC 32

ad_ip_instance axi_dmac ad7768_dma_2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.CYCLIC 0
ad_ip_parameter ad7768_dma_2 CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter ad7768_dma_2 CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter ad7768_dma_2 CONFIG.DMA_DATA_WIDTH_SRC 256

# ps7-hp1

ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP1 1

# gpio

ad_ip_instance axi_gpio ad7768_gpio
ad_ip_parameter ad7768_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter ad7768_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter ad7768_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter ad7768_gpio CONFIG.C_INTERRUPT_PRESENT 1

# adc-path channel pack

ad_ip_instance util_cpack2 util_ad7768_adc_pack
ad_ip_parameter util_ad7768_adc_pack CONFIG.NUM_OF_CHANNELS 8
ad_ip_parameter util_ad7768_adc_pack CONFIG.SAMPLE_DATA_WIDTH 32

# axi_ad7768

ad_ip_instance axi_ad7768 axi_ad7768_adc

for {set i 0} {$i < 8} {incr i} {
  ad_connect axi_ad7768_adc/adc_enable_$i  util_ad7768_adc_pack/enable_$i
  ad_connect axi_ad7768_adc/adc_data_$i    util_ad7768_adc_pack/fifo_wr_data_$i
}

ad_connect axi_ad7768_adc/s_axi_aclk        sys_ps7/FCLK_CLK0 
ad_connect axi_ad7768_adc/clk_in            clk_in
ad_connect axi_ad7768_adc/ready_in          ready_in
ad_connect axi_ad7768_adc/data_in           data_in
ad_connect axi_ad7768_adc/up_sshot          up_sshot
ad_connect axi_ad7768_adc/up_format         up_format
ad_connect axi_ad7768_adc/up_crc_enable     up_crc_enable
ad_connect axi_ad7768_adc/up_crc_4_or_16_n  up_crc_4_or_16_n
ad_connect axi_ad7768_adc/up_status_clr     up_status_clr
ad_connect axi_ad7768_adc/up_status         up_status
ad_connect axi_ad7768_adc/adc_valid         util_ad7768_adc_pack/fifo_wr_en
ad_connect axi_ad7768_adc/adc_clk           util_ad7768_adc_pack/clk
ad_connect axi_ad7768_adc/adc_reset         util_ad7768_adc_pack/reset
# connections  

ad_connect  ad7768_dma/m_dest_axi_aresetn         sys_cpu_resetn                        
ad_connect  ad7768_dma/fifo_wr_clk                axi_ad7768_adc/adc_clk                
ad_connect  ad7768_dma/fifo_wr_en                 axi_ad7768_adc/adc_valid              
ad_connect  ad7768_dma/fifo_wr_din                axi_ad7768_adc/adc_data               
ad_connect  ad7768_dma_2/m_dest_axi_aresetn       sys_cpu_resetn                        
ad_connect  ad7768_dma_2/fifo_wr_clk              axi_ad7768_adc/adc_clk                
ad_connect  ad7768_dma_2/fifo_wr                  util_ad7768_adc_pack/packed_fifo_wr   
ad_connect  axi_ad7768_adc/adc_dovf               util_ad7768_adc_pack/fifo_wr_overflow 

ad_connect  adc_gpio_0_i ad7768_gpio/gpio_io_i
ad_connect  adc_gpio_0_o ad7768_gpio/gpio_io_o
ad_connect  adc_gpio_0_t ad7768_gpio/gpio_io_t
ad_connect  adc_gpio_1_i ad7768_gpio/gpio2_io_i
ad_connect  adc_gpio_1_o ad7768_gpio/gpio2_io_o
ad_connect  adc_gpio_1_t ad7768_gpio/gpio2_io_t

# interrupts

ad_cpu_interrupt ps-13 mb-13  ad7768_dma/irq
ad_cpu_interrupt ps-12 mb-12  ad7768_gpio/ip2intc_irpt
ad_cpu_interrupt ps-10 mb-10  ad7768_dma_2/irq

# cpu / memory interconnects

ad_cpu_interconnect 0x7C400000 ad7768_dma
ad_cpu_interconnect 0x7C420000 ad7768_gpio
ad_cpu_interconnect 0x7C480000 ad7768_dma_2
ad_cpu_interconnect 0x43c00000 axi_ad7768_adc

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma/m_dest_axi
ad_mem_hp1_interconnect sys_cpu_clk ad7768_dma_2/m_dest_axi

