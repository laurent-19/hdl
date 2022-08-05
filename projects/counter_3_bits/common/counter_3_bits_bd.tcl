# counter interface 

create_bd_port -dir I -type clk clk
create_bd_port -dir I -type rst reset
create_bd_port -dir O -from 2 -to 0 -type data counter_leds

# axi_counter

ad_ip_instance axi_counter axi_counter
ad_connect clk axi_counter/clk
ad_connect reset axi_counter/rst
ad_connect counter_leds axi_counter/leds
ad_connect sys_ps7/FCLK_CLK0 axi_counter/s_axi_aclk
ad_connect sys_cpu_resetn axi_counter/s_axi_aresetn

