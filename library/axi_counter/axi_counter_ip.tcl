# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_counter

adi_ip_files axi_counter [list \
  "d_flip_flop.v" \
  "debouncer.v"\
  "axi_counter.v" ]

adi_ip_properties axi_counter

adi_init_bd_tcl
adi_ip_bd axi_counter "bd/bd.tcl"

adi_add_auto_fpga_spec_params
ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]
