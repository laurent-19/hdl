# counter interface 
create_bd_port -dir I reset_in
create_bd_port -dir I counter_clk
create_bd_port -dir O led0
create_bd_port -dir O led1
create_bd_port -dir O led2

ad_ip_instance axi_counter counter3bits

ad_connect  counter_clk        counter3bits/counter_clk
ad_connect  reset_in           counter3bits/counter_reset
ad_connect  led0               counter3bits/led0
ad_connect  led1               counter3bits/led1
ad_connect  led2               counter3bits/led2     
ad_connect  sys_ps7/FCLK_CLK0  counter3bits/s_axi_aclk          
ad_connect  sys_cpu_resetn     counter3bits/s_axi_aresetn    