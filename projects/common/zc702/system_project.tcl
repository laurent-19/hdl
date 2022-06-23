
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project zc702
adi_project_files zc702 [list \
  "system_top.v" \
  "system_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc702/zc702_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" ]

adi_project_run zc702
