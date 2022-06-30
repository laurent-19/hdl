// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad7768_if #(
  parameter NUM_CHANNELS = 8
  ) (

  // device-interface

  input                   clk_in,
  input                   ready_in,
  input       [ 7:0]      data_in,
  input                   sync_miso,
  // data path interface

  output                  adc_clk,
  output                  adc_valid,
  output      [ 31:0]     adc_data,
  output      [ 31:0]     adc_data_0,
  output      [ 31:0]     adc_data_1,
  output      [ 31:0]     adc_data_2,
  output      [ 31:0]     adc_data_3,
  output      [ 31:0]     adc_data_4,
  output      [ 31:0]     adc_data_5,
  output      [ 31:0]     adc_data_6,
  output      [ 31:0]     adc_data_7,

  // control interface

  input                   up_sshot,
  input       [ 1:0]      up_format,
  input                   up_crc_enable,
  input                   up_crc_4_or_16_n,
  input       [ 35:0]     up_status_clr,
  output      [ 35:0]     up_status);

  // internal registers

  reg     [  4:0]   adc_status = 'd0;
  reg     [ 63:0]   adc_crc_8 = 'd0;
  reg     [  7:0]   adc_crc_mismatch_int = 'd0;
  reg               adc_crc_valid = 'd0;
  reg     [  7:0]   adc_crc_data = 'd0;
  reg               adc_crc_mismatch_8 = 'd0;
  reg               adc_valid_int = 'd0;
  reg     [ 31:0]   adc_data_int = 'd0;
  reg     [  2:0]   adc_seq_int = 'd0;
  reg               adc_enable_int = 'd0;
  reg     [  3:0]   adc_crc_scnt_int = 'd0;
  reg     [  3:0]   adc_crc_scnt_8 = 'd0;
  reg               adc_ch_valid = 'd0;
  reg     [255:0]   adc_ch_data = 'd0;
  reg     [  8:0]   adc_cnt_p = 'd0;
  reg               adc_valid_p = 'd0;
  reg     [255:0]   adc_data_p = 'd0;
  reg               adc_ready_d1 = 'd0;
  reg               adc_ready = 'd0;
  reg               adc_ready_d = 'd0;
  reg               adc_sshot_m1 = 'd0;
  reg               adc_sshot = 'd0;
  reg     [  1:0]   adc_format_m1 = 'd0;
  reg     [  1:0]   adc_format = 'h0;
  reg               adc_crc_enable_m1 = 'd0;
  reg               adc_crc_enable = 'd0;
  reg               adc_crc_4_or_16_n_m1 = 'd0;
  reg               adc_crc_4_or_16_n = 'd0;
  reg     [ 35:0]   adc_status_clr_m1 = 'd0;
  reg     [ 35:0]   adc_status_clr = 'd0;
  reg     [ 35:0]   adc_status_clr_d = 'd0;


// new added 

  reg     [ 95:0]   adc_crc_data_0 = 'd0;
  reg     [ 95:0]   adc_crc_data_1 = 'd0;
  reg     [ 95:0]   adc_crc_data_2 = 'd0;
  reg     [ 95:0]   adc_crc_data_3 = 'd0;
  reg     [ 95:0]   adc_crc_data_4 = 'd0;
  reg     [ 95:0]   adc_crc_data_5 = 'd0;
  reg     [ 95:0]   adc_crc_data_6 = 'd0;
  reg     [ 95:0]   adc_crc_data_7 = 'd0;
  reg     [ 95:0]   adc_crc_data_0_s = 'd0;
  reg     [ 95:0]   adc_crc_data_1_s = 'd0;
  reg     [ 95:0]   adc_crc_data_2_s = 'd0;
  reg     [ 95:0]   adc_crc_data_3_s = 'd0;
  reg     [ 95:0]   adc_crc_data_4_s = 'd0;
  reg     [ 95:0]   adc_crc_data_5_s = 'd0;
  reg     [ 95:0]   adc_crc_data_6_s = 'd0;
  reg     [ 95:0]   adc_crc_data_7_s = 'd0;
  reg     [  7:0]   adc_crc_read_data_0 = 'd0;
  reg     [  7:0]   adc_crc_read_data_1 = 'd0;
  reg     [  7:0]   adc_crc_read_data_2 = 'd0;
  reg     [  7:0]   adc_crc_read_data_3 = 'd0;
  reg     [  7:0]   adc_crc_read_data_4 = 'd0;
  reg     [  7:0]   adc_crc_read_data_5 = 'd0;
  reg     [  7:0]   adc_crc_read_data_6 = 'd0;
  reg     [  7:0]   adc_crc_read_data_7 = 'd0;
  reg     [  7:0]   adc_crc_reg_0 = 'd0;
  reg     [  7:0]   adc_crc_reg_1 = 'd0;
  reg     [  7:0]   adc_crc_reg_2 = 'd0;
  reg     [  7:0]   adc_crc_reg_3 = 'd0;
  reg     [  7:0]   adc_crc_reg_4 = 'd0;
  reg     [  7:0]   adc_crc_reg_5 = 'd0;
  reg     [  7:0]   adc_crc_reg_6 = 'd0;
  reg     [  7:0]   adc_crc_reg_7 = 'd0;
  reg     [ 31:0]   adc_data_0_s_d  = 'd0; 
  reg     [ 31:0]   adc_data_1_s_d  = 'd0;
  reg     [ 31:0]   adc_data_2_s_d  = 'd0;
  reg     [ 31:0]   adc_data_3_s_d  = 'd0;
  reg     [ 31:0]   adc_data_4_s_d  = 'd0;
  reg     [ 31:0]   adc_data_5_s_d  = 'd0;
  reg     [ 31:0]   adc_data_6_s_d  = 'd0;
  reg     [ 31:0]   adc_data_7_s_d  = 'd0; 
  reg     [ 31:0]   adc_data_0_s  = 'd0; 
  reg     [ 31:0]   adc_data_1_s  = 'd0;
  reg     [ 31:0]   adc_data_2_s  = 'd0;
  reg     [ 31:0]   adc_data_3_s  = 'd0;
  reg     [ 31:0]   adc_data_4_s  = 'd0;
  reg     [ 31:0]   adc_data_5_s  = 'd0;
  reg     [ 31:0]   adc_data_6_s  = 'd0;
  reg     [ 31:0]   adc_data_7_s  = 'd0; 
  reg     [ 31:0]   adc_ch_data_0 = 'd0;
  reg     [ 31:0]   adc_ch_data_1 = 'd0;
  reg     [ 31:0]   adc_ch_data_2 = 'd0;
  reg     [ 31:0]   adc_ch_data_3 = 'd0;
  reg     [ 31:0]   adc_ch_data_4 = 'd0;
  reg     [ 31:0]   adc_ch_data_5 = 'd0;
  reg     [ 31:0]   adc_ch_data_6 = 'd0;
  reg     [ 31:0]   adc_ch_data_7 = 'd0;
  reg     [255:0]   adc_ch_data_d0 = 'd0;
  reg     [255:0]   adc_ch_data_d1 = 'd0;
  reg     [255:0]   adc_ch_data_d2 = 'd0;
  reg     [255:0]   adc_ch_data_d3 = 'd0;
  reg     [255:0]   adc_ch_data_d4 = 'd0;
  reg     [255:0]   adc_ch_data_d5 = 'd0;
  reg     [255:0]   adc_ch_data_d6 = 'd0;
  reg     [255:0]   adc_ch_data_d7 = 'd0;
  reg     [  7:0]   adc_crc_ch_mismatch_s = 'd0;
  reg               adc_valid_s    = 'b0; 
  reg               adc_valid_s_d   = 'b0;
  reg               adc_crc_valid_p = 'b0;
  reg               adc_crc_valid_p_d = 'b0;
  reg     [  2:0]   adc_seq = 'd0;
  reg               crc_synced = 'd0;
  reg               sync_miso_d ='d0;
  reg               sync_miso_m1 ='d0;
  reg               sync_miso_m2 = 'd0;
  reg               adc_cnt_crc_enable_s_d;
  reg               adc_cnt_crc_enable_s_dd;
  reg               adc_seq_foos = 'd0;

  

  // internal signals
  wire              sync_miso_s;
  wire    [  7:0]   adc_crc_in_s;
  wire    [  7:0]   adc_crc_s;
  wire              adc_cnt_enable_s;
  wire              adc_ready_in_s;
  wire    [ 35:0]   adc_status_clr_s;
  wire    [  7:0]   adc_crc_mismatch_s;
  wire              adc_cnt_crc_enable_s;
  wire    [ 8:0]    adc_cnt_value;
  wire    [ 3:0]    adc_crc_cnt_value;
  wire              adc_crc_mismatch_s_0;
  wire              adc_crc_mismatch_s_1;
  wire              adc_crc_mismatch_s_2;
  wire              adc_crc_mismatch_s_3;
  wire              adc_crc_mismatch_s_4;
  wire              adc_crc_mismatch_s_5;
  wire              adc_crc_mismatch_s_6;
  wire              adc_crc_mismatch_s_7;
  wire    [ 7:0]    adc_crc_in_s_0;
  wire    [ 7:0]    adc_crc_in_s_1;
  wire    [ 7:0]    adc_crc_in_s_2;
  wire    [ 7:0]    adc_crc_in_s_3;
  wire    [ 7:0]    adc_crc_in_s_4;
  wire    [ 7:0]    adc_crc_in_s_5;
  wire    [ 7:0]    adc_crc_in_s_6;
  wire    [ 7:0]    adc_crc_in_s_7;
  wire    [ 7:0]    adc_crc_s_0;
  wire    [ 7:0]    adc_crc_s_1;
  wire    [ 7:0]    adc_crc_s_2;
  wire    [ 7:0]    adc_crc_s_3;
  wire    [ 7:0]    adc_crc_s_4;
  wire    [ 7:0]    adc_crc_s_5;
  wire    [ 7:0]    adc_crc_s_6;
  wire    [ 7:0]    adc_crc_s_7;

  // function (crc)

  function  [ 7:0]  crc8;
    input   [95:0]  din;
    input   [ 7:0]  cin;
    reg     [ 7:0]  cout;
    begin

    cout[0] = cin[0]  ^ cin[2]  ^ cin[4]  ^ cin[5]  ^ cin[6]  ^ din[0]  ^ din[6]  ^ din[7]  ^ din[8]  ^ din[12] ^ din[14] ^ din[16] ^ 
              din[18] ^ din[19] ^ din[21] ^ din[23] ^ din[28] ^ din[30] ^ din[31] ^ din[34] ^ din[35] ^ din[39] ^ din[40] ^ din[43] ^ 
              din[45] ^ din[48] ^ din[49] ^ din[50] ^ din[52] ^ din[53] ^ din[54] ^ din[56] ^ din[60] ^ din[63] ^ din[64] ^ din[66] ^ 
              din[67] ^ din[68] ^ din[69] ^ din[74] ^ din[75] ^ din[77] ^ din[80] ^ din[84] ^ din[85] ^ din[86] ^ din[87] ^ din[88] ^ 
              din[90] ^ din[92] ^ din[93] ^ din[94];
    cout[1] = cin[1]  ^ cin[2]  ^ cin[3]  ^ cin[4]  ^ cin[7]  ^ din[0]  ^ din[1]  ^ din[6]  ^ din[9]  ^ din[12] ^ din[13] ^ din[14] ^
              din[15] ^ din[16] ^ din[17] ^ din[18] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^ din[28] ^ din[29] ^ din[30] ^ 
              din[32] ^ din[34] ^ din[36] ^ din[39] ^ din[41] ^ din[43] ^ din[44] ^ din[45] ^ din[46] ^ din[48] ^ din[51] ^ din[52] ^ 
              din[55] ^ din[56] ^ din[57] ^ din[60] ^ din[61] ^ din[63] ^ din[65] ^ din[66] ^ din[70] ^ din[74] ^ din[76] ^ din[77] ^ 
              din[78] ^ din[80] ^ din[81] ^ din[84] ^ din[89] ^ din[90] ^ din[91] ^ din[92] ^ din[95];
    cout[2] = cin[0]  ^ cin[3]  ^ cin[6]  ^ din[0]  ^ din[1]  ^ din[2]  ^ din[6]  ^ din[8]  ^ din[10] ^ din[12] ^ din[13] ^ din[15] ^
              din[17] ^ din[22] ^ din[24] ^ din[25] ^ din[28] ^ din[29] ^ din[33] ^ din[34] ^ din[37] ^ din[39] ^ din[42] ^ din[43] ^ 
              din[44] ^ din[46] ^ din[47] ^ din[48] ^ din[50] ^ din[54] ^ din[57] ^ din[58] ^ din[60] ^ din[61] ^ din[62] ^ din[63] ^ 
              din[68] ^ din[69] ^ din[71] ^ din[74] ^ din[78] ^ din[79] ^ din[80] ^ din[81] ^ din[82] ^ din[84] ^ din[86] ^ din[87] ^ 
              din[88] ^ din[91] ^ din[94];
    cout[3] = cin[0]  ^ cin[1]  ^ cin[4]  ^ cin[7]  ^ din[1]  ^ din[2]  ^ din[3]  ^ din[7]  ^ din[9]  ^ din[11] ^ din[13] ^ din[14] ^ 
              din[16] ^ din[18] ^ din[23] ^ din[25] ^ din[26] ^ din[29] ^ din[30] ^ din[34] ^ din[35] ^ din[38] ^ din[40] ^ din[43] ^ 
              din[44] ^ din[45] ^ din[47] ^ din[48] ^ din[49] ^ din[51] ^ din[55] ^ din[58] ^ din[59] ^ din[61] ^ din[62] ^ din[63] ^ 
              din[64] ^ din[69] ^ din[70] ^ din[72] ^ din[75] ^ din[79] ^ din[80] ^ din[81] ^ din[82] ^ din[83] ^ din[85] ^ din[87] ^ 
              din[88] ^ din[89] ^ din[92] ^ din[95];
    cout[4] = cin[0]  ^ cin[1]  ^ cin[2]  ^ cin[5]  ^ din[2]  ^ din[3]  ^ din[4]  ^ din[8]  ^ din[10] ^ din[12] ^ din[14] ^ din[15] ^ 
              din[17] ^ din[19] ^ din[24] ^ din[26] ^ din[27] ^ din[30] ^ din[31] ^ din[35] ^ din[36] ^ din[39] ^ din[41] ^ din[44] ^ 
              din[45] ^ din[46] ^ din[48] ^ din[49] ^ din[50] ^ din[52] ^ din[56] ^ din[59] ^ din[60] ^ din[62] ^ din[63] ^ din[64] ^ 
              din[65] ^ din[70] ^ din[71] ^ din[73] ^ din[76] ^ din[80] ^ din[81] ^ din[82] ^ din[83] ^ din[84] ^ din[86] ^ din[88] ^ 
              din[89] ^ din[90] ^ din[93];
    cout[5] = cin[1]  ^ cin[2]  ^ cin[3]  ^ cin[6]  ^ din[3]  ^ din[4]  ^ din[5]  ^ din[9]  ^ din[11] ^ din[13] ^ din[15] ^ din[16] ^ 
              din[18] ^ din[20] ^ din[25] ^ din[27] ^ din[28] ^ din[31] ^ din[32] ^ din[36] ^ din[37] ^ din[40] ^ din[42] ^ din[45] ^ 
              din[46] ^ din[47] ^ din[49] ^ din[50] ^ din[51] ^ din[53] ^ din[57] ^ din[60] ^ din[61] ^ din[63] ^ din[64] ^ din[65] ^ 
              din[66] ^ din[71] ^ din[72] ^ din[74] ^ din[77] ^ din[81] ^ din[82] ^ din[83] ^ din[84] ^ din[85] ^ din[87] ^ din[89] ^ 
              din[90] ^ din[91] ^ din[94];
    cout[6] = cin[0]  ^ cin[2]  ^ cin[3]  ^ cin[4]  ^ cin[7]  ^ din[4]  ^ din[5]  ^ din[6]  ^ din[10] ^ din[12] ^ din[14] ^ din[16] ^ 
              din[17] ^ din[19] ^ din[21] ^ din[26] ^ din[28] ^ din[29] ^ din[32] ^ din[33] ^ din[37] ^ din[38] ^ din[41] ^ din[43] ^
              din[46] ^ din[47] ^ din[48] ^ din[50] ^ din[51] ^ din[52] ^ din[54] ^ din[58] ^ din[61] ^ din[62] ^ din[64] ^ din[65] ^ 
              din[66] ^ din[67] ^ din[72] ^ din[73] ^ din[75] ^ din[78] ^ din[82] ^ din[83] ^ din[84] ^ din[85] ^ din[86] ^ din[88] ^ 
              din[90] ^ din[91] ^ din[92] ^ din[95];
    cout[7] = cin[1]  ^ cin[3]  ^ cin[4]  ^ cin[5]  ^ din[5]  ^ din[6]  ^ din[7]  ^ din[11] ^ din[13] ^ din[15] ^ din[17] ^ din[18] ^ 
              din[20] ^ din[22] ^ din[27] ^ din[29] ^ din[30] ^ din[33] ^ din[34] ^ din[38] ^ din[39] ^ din[42] ^ din[44] ^ din[47] ^ 
              din[48] ^ din[49] ^ din[51] ^ din[52] ^ din[53] ^ din[55] ^ din[59] ^ din[62] ^ din[63] ^ din[65] ^ din[66] ^ din[67] ^ 
              din[68] ^ din[73] ^ din[74] ^ din[76] ^ din[79] ^ din[83] ^ din[84] ^ din[85] ^ din[86] ^ din[87] ^ din[89] ^ din[91] ^ 
              din[92] ^ din[93];
      crc8 = cout;
    end
  endfunction

  // status

  assign up_status[35:32] =  adc_status;
  assign up_status[31:28] =  adc_status;
  assign up_status[27:24] =  adc_status;
  assign up_status[23:20] =  adc_status;
  assign up_status[19:16] =  adc_status;
  assign up_status[15:12] =  adc_status;
  assign up_status[11: 8] =  adc_status;
  assign up_status[ 7: 4] =  adc_status;
  assign up_status[ 3: 0] =  adc_status;
  assign adc_data = adc_data_int;
  assign adc_ready_in_s = ready_in;
  assign adc_clk = clk_in;
  assign adc_valid = adc_valid_s_d;
  assign adc_data_0 = adc_data_0_s_d;
  assign adc_data_1 = adc_data_1_s_d;
  assign adc_data_2 = adc_data_2_s_d;
  assign adc_data_3 = adc_data_3_s_d;
  assign adc_data_4 = adc_data_4_s_d;
  assign adc_data_5 = adc_data_5_s_d;
  assign adc_data_6 = adc_data_6_s_d;
  assign adc_data_7 = adc_data_7_s_d;
  

  always @(posedge adc_clk) begin   
    if ((adc_crc_enable == 1'b1) && (adc_crc_scnt_8 == 4'd0)) begin
      adc_status[4] <= adc_crc_mismatch_8 & adc_crc_valid_p;
      adc_status[3] <= 1'b0;
      adc_status[2] <= 1'b0;
      adc_status[1] <= 1'b0;
      adc_status[0] <= adc_seq_foos;
    end else begin
      adc_status[4] <= adc_crc_mismatch_8 & adc_crc_valid_p;
      adc_status[3] <= adc_data_int[30] & adc_valid_s;
      adc_status[2] <= adc_data_int[27] & adc_valid_s;
      adc_status[1] <= adc_data_int[31] & adc_valid_s;
      adc_status[0] <= adc_seq_foos;
    end
  end

  always @(posedge adc_clk) begin
    adc_data_8 <= adc_ch_data_0 | adc_ch_data_1 | adc_ch_data_2 | adc_ch_data_3 |
                  adc_ch_data_4 | adc_ch_data_5 | adc_ch_data_6 | adc_ch_data_7;
    adc_crc_mismatch_8 <= |adc_crc_mismatch_s;
  end

  // CRC check

  assign adc_crc_mismatch_s[0] = (adc_crc_read_data_0 == adc_crc_s_0) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[1] = (adc_crc_read_data_1 == adc_crc_s_1) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[2] = (adc_crc_read_data_2 == adc_crc_s_2) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[3] = (adc_crc_read_data_3 == adc_crc_s_3) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[4] = (adc_crc_read_data_4 == adc_crc_s_4 && NUM_CHANNELS == 8) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[5] = (adc_crc_read_data_5 == adc_crc_s_5 && NUM_CHANNELS == 8) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[6] = (adc_crc_read_data_6 == adc_crc_s_6 && NUM_CHANNELS == 8) ? 1'b0 : adc_crc_enable;
  assign adc_crc_mismatch_s[7] = (adc_crc_read_data_7 == adc_crc_s_7 && NUM_CHANNELS == 8) ? 1'b0 : adc_crc_enable;  

  assign adc_crc_s_0 = crc8(adc_crc_data_0, adc_crc_in_s_0);
  assign adc_crc_s_1 = crc8(adc_crc_data_1, adc_crc_in_s_1);
  assign adc_crc_s_2 = crc8(adc_crc_data_2, adc_crc_in_s_2);
  assign adc_crc_s_3 = crc8(adc_crc_data_3, adc_crc_in_s_3);
  assign adc_crc_s_4 = crc8(adc_crc_data_4, adc_crc_in_s_4);
  assign adc_crc_s_5 = crc8(adc_crc_data_5, adc_crc_in_s_5);
  assign adc_crc_s_6 = crc8(adc_crc_data_6, adc_crc_in_s_6);
  assign adc_crc_s_7 = crc8(adc_crc_data_7, adc_crc_in_s_7);

  assign adc_crc_in_s_0 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_0;
  assign adc_crc_in_s_1 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_1;
  assign adc_crc_in_s_2 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_2;
  assign adc_crc_in_s_3 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_3;
  assign adc_crc_in_s_4 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_4;
  assign adc_crc_in_s_5 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_5;
  assign adc_crc_in_s_6 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_6;
  assign adc_crc_in_s_7 = (adc_crc_enable == 'd1) ? 8'hff : adc_crc_reg_7;

 always @(posedge adc_clk) begin
   adc_crc_ch_mismatch_s[0] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[0] : adc_crc_ch_mismatch_s[0];
   adc_crc_ch_mismatch_s[1] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[1] : adc_crc_ch_mismatch_s[1];
   adc_crc_ch_mismatch_s[2] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[2] : adc_crc_ch_mismatch_s[2];
   adc_crc_ch_mismatch_s[3] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[3] : adc_crc_ch_mismatch_s[3];
   adc_crc_ch_mismatch_s[4] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[4] : adc_crc_ch_mismatch_s[4];
   adc_crc_ch_mismatch_s[5] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[5] : adc_crc_ch_mismatch_s[5];
   adc_crc_ch_mismatch_s[6] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[6] : adc_crc_ch_mismatch_s[6];
   adc_crc_ch_mismatch_s[7] <= (adc_crc_valid_p_d == 1'b1 ) ? adc_crc_mismatch_s[7] : adc_crc_ch_mismatch_s[7];
   
  end

  // numbers of samples count 

  assign adc_crc_cnt_value = 4'h4; 
  assign adc_cnt_crc_enable_s = (adc_crc_scnt_8 < adc_crc_cnt_value) ? 1'b1 : 1'b0;

  always @(posedge adc_clk) begin

    if ((sync_miso_s == 1'b1) || (adc_cnt_crc_enable_s == 1'b0) || (adc_crc_enable == 1'b0) ) begin
      adc_crc_scnt_8 <= 4'd0;
    end else if (adc_valid_p == 1'b1) begin
      adc_crc_scnt_8 <= adc_crc_scnt_8 + 1'b1;
    end
    if (adc_crc_scnt_8 == adc_crc_cnt_value) begin
      adc_crc_valid_p <= 1'b1;
    end else begin
      adc_crc_valid_p <= 1'b0;
    end
    adc_crc_valid_p_d <= adc_crc_valid_p;
  end
  
  // capturing 4 samples after sync flag 
always @(posedge adc_clk) begin
  adc_cnt_crc_enable_s_d  <= adc_cnt_crc_enable_s;
  adc_cnt_crc_enable_s_dd <= adc_cnt_crc_enable_s_d;
  if((adc_cnt_crc_enable_s_dd == 1'b1) && (adc_valid_s == 1'b1) ) begin 
    adc_crc_data_0_s <= {adc_crc_data_0_s[71:0],adc_data_0_s[23:0]};
    adc_crc_data_1_s <= {adc_crc_data_1_s[71:0],adc_data_1_s[23:0]};
    adc_crc_data_2_s <= {adc_crc_data_2_s[71:0],adc_data_2_s[23:0]};
    adc_crc_data_3_s <= {adc_crc_data_3_s[71:0],adc_data_3_s[23:0]};
    adc_crc_data_4_s <= {adc_crc_data_4_s[71:0],adc_data_4_s[23:0]};
    adc_crc_data_5_s <= {adc_crc_data_5_s[71:0],adc_data_5_s[23:0]};
    adc_crc_data_6_s <= {adc_crc_data_6_s[71:0],adc_data_6_s[23:0]};
    adc_crc_data_7_s <= {adc_crc_data_7_s[71:0],adc_data_7_s[23:0]};
  end else if(adc_cnt_crc_enable_s_dd == 1'b0) begin 
    adc_crc_data_0_s <= 94'd0;
    adc_crc_data_1_s <= 94'd0;
    adc_crc_data_2_s <= 94'd0;
    adc_crc_data_3_s <= 94'd0;
    adc_crc_data_4_s <= 94'd0;
    adc_crc_data_5_s <= 94'd0;
    adc_crc_data_6_s <= 94'd0;
    adc_crc_data_7_s <= 94'd0;
  end
end

always @(posedge adc_clk) begin
  if(adc_crc_valid_p == 1'b1 ) begin
    adc_crc_data_0 <= adc_crc_data_0_s; 
    adc_crc_data_1 <= adc_crc_data_1_s;
    adc_crc_data_2 <= adc_crc_data_2_s;
    adc_crc_data_3 <= adc_crc_data_3_s;
    adc_crc_data_4 <= adc_crc_data_4_s;
    adc_crc_data_5 <= adc_crc_data_5_s;
    adc_crc_data_6 <= adc_crc_data_6_s;
    adc_crc_data_7 <= adc_crc_data_7_s;
    adc_crc_reg_0  <= adc_crc_s_0;
    adc_crc_reg_1  <= adc_crc_s_1;
    adc_crc_reg_2  <= adc_crc_s_2;
    adc_crc_reg_3  <= adc_crc_s_3;
    adc_crc_reg_4  <= adc_crc_s_4;
    adc_crc_reg_5  <= adc_crc_s_5;
    adc_crc_reg_6  <= adc_crc_s_6;
    adc_crc_reg_7  <= adc_crc_s_7;
  end else begin 
    adc_crc_data_0 <= 96'b0;
    adc_crc_data_1 <= 96'b0;
    adc_crc_data_2 <= 96'b0;
    adc_crc_data_3 <= 96'b0;
    adc_crc_data_4 <= 96'b0;
    adc_crc_data_5 <= 96'b0;
    adc_crc_data_6 <= 96'b0;
    adc_crc_data_7 <= 96'b0;
    adc_crc_reg_0  <= 'b0;
    adc_crc_reg_1  <= 'b0;
    adc_crc_reg_2  <= 'b0;
    adc_crc_reg_3  <= 'b0;
    adc_crc_reg_4  <= 'b0;
    adc_crc_reg_5  <= 'b0;
    adc_crc_reg_6  <= 'b0;
    adc_crc_reg_7  <= 'b0;

  end 
end

 // capturing the CRC data generated by the chip

  always @(posedge adc_clk) begin
    if (adc_crc_valid_p == 1'b1) begin
      adc_crc_read_data_0 <=adc_data_0_s_d[31:24];
      adc_crc_read_data_1 <=adc_data_1_s_d[31:24];
      adc_crc_read_data_2 <=adc_data_2_s_d[31:24];
      adc_crc_read_data_3 <=adc_data_3_s_d[31:24];
      adc_crc_read_data_4 <=adc_data_4_s_d[31:24];
      adc_crc_read_data_5 <=adc_data_5_s_d[31:24];
      adc_crc_read_data_6 <=adc_data_6_s_d[31:24];
      adc_crc_read_data_7 <=adc_data_7_s_d[31:24];
    end else begin
      adc_crc_read_data_0 <=8'b0;
      adc_crc_read_data_1 <=8'b0;
      adc_crc_read_data_2 <=8'b0;
      adc_crc_read_data_3 <=8'b0;
      adc_crc_read_data_4 <=8'b0;
      adc_crc_read_data_5 <=8'b0;
      adc_crc_read_data_6 <=8'b0;
      adc_crc_read_data_7 <=8'b0;
    end
  end

  assign adc_cnt_value = (adc_format  == 'h0) ? 'hff :  
                         ((adc_format == 'h1) ? 'h7f : 
                         ((adc_format == 'h2) ? 'h3f : 'h1f ) );

  assign adc_cnt_enable_s = (adc_cnt_p < adc_cnt_value) ? 1'b1 : 1'b0;

  always @(negedge adc_clk) begin
    if (adc_ready == 1'b0) begin
      adc_cnt_p <= 'h000;
    end else if (adc_cnt_enable_s == 1'b1) begin
      adc_cnt_p <= adc_cnt_p + 1'b1;
    end
    if (adc_cnt_p == adc_cnt_value) begin
      adc_valid_p <= 1'b1;
    end else begin
      adc_valid_p <= 1'b0;
    end
  end

   //delay data 1 clk for data, data_valid and crc mismatch for alignment
 
  always @(posedge adc_clk) begin
    if (adc_valid_s == 1'b1) begin  
      adc_data_0_s_d <= adc_data_0_s;
      adc_data_1_s_d <= adc_data_1_s;
      adc_data_2_s_d <= adc_data_2_s;
      adc_data_3_s_d <= adc_data_3_s;
      adc_data_4_s_d <= adc_data_4_s;
      adc_data_5_s_d <= adc_data_5_s;
      adc_data_6_s_d <= adc_data_6_s;
      adc_data_7_s_d <= adc_data_7_s;
      adc_valid_s_d  <= adc_valid_s;
    end else begin
      adc_data_0_s_d <= 32'b0;
      adc_data_1_s_d <= 32'b0;
      adc_data_2_s_d <= 32'b0;
      adc_data_3_s_d <= 32'b0;
      adc_data_4_s_d <= 32'b0;
      adc_data_5_s_d <= 32'b0;
      adc_data_6_s_d <= 32'b0;
      adc_data_7_s_d <= 32'b0;  
      adc_valid_s_d  <=  1'b0;         
    end 
  end

   always @(posedge adc_clk) begin
  
    adc_ch_data_d0 <= {adc_ch_data_d0[((32*6)+31):(32*0)],adc_data_0_s};
    adc_ch_data_d1 <= {adc_ch_data_d1[((32*6)+31):(32*0)],adc_data_1_s};
    adc_ch_data_d2 <= {adc_ch_data_d2[((32*6)+31):(32*0)],adc_data_2_s};
    adc_ch_data_d3 <= {adc_ch_data_d3[((32*6)+31):(32*0)],adc_data_3_s};
    adc_ch_data_d4 <= {adc_ch_data_d4[((32*6)+31):(32*0)],adc_data_4_s};
    adc_ch_data_d5 <= {adc_ch_data_d5[((32*6)+31):(32*0)],adc_data_5_s};
    adc_ch_data_d6 <= {adc_ch_data_d6[((32*6)+31):(32*0)],adc_data_6_s};
    adc_ch_data_d7 <= {adc_ch_data_d7[((32*6)+31):(32*0)],adc_data_7_s};
    adc_ch_data_0 <= adc_ch_data_d0[((32*0)+31):(32*0)];
    adc_ch_data_1 <= adc_ch_data_d1[((32*1)+31):(32*1)];
    adc_ch_data_2 <= adc_ch_data_d2[((32*2)+31):(32*2)];
    adc_ch_data_3 <= adc_ch_data_d3[((32*3)+31):(32*3)];
    adc_ch_data_4 <= adc_ch_data_d4[((32*4)+31):(32*4)];
    adc_ch_data_5 <= adc_ch_data_d5[((32*5)+31):(32*5)];
    adc_ch_data_6 <= adc_ch_data_d6[((32*6)+31):(32*6)];
    adc_ch_data_7 <= adc_ch_data_d7[((32*7)+31):(32*7)];

  end
  
 always @(posedge adc_clk) begin
    if (adc_valid_p == 1'b1) begin
      if( adc_format == 'h0) begin          // 1 active line 
        adc_data_0_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_1_s <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_2_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_3_s <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_4_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_5_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_6_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_7_s <= adc_data_p[((32*0)+31):(32*0)];
      end else if( adc_format == 'h1) begin   // 2 active lines
        adc_data_0_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_1_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_2_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_3_s <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_4_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_5_s <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_6_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_7_s <= adc_data_p[((32*4)+31):(32*4)];
      end else if( adc_format == 'h2) begin  // 4 active lines
        adc_data_0_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_1_s <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_2_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_3_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_4_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_5_s <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_6_s <= adc_data_p[((32*7)+31):(32*7)];
        adc_data_7_s <= adc_data_p[((32*6)+31):(32*6)];
      end else begin                       // 8 active lines
        adc_data_0_s <= adc_data_p[((32*0)+31):(32*0)];
        adc_data_1_s <= adc_data_p[((32*1)+31):(32*1)];
        adc_data_2_s <= adc_data_p[((32*2)+31):(32*2)];
        adc_data_3_s <= adc_data_p[((32*3)+31):(32*3)];
        adc_data_4_s <= adc_data_p[((32*4)+31):(32*4)];
        adc_data_5_s <= adc_data_p[((32*5)+31):(32*5)];
        adc_data_6_s <= adc_data_p[((32*6)+31):(32*6)];
        adc_data_7_s <= adc_data_p[((32*7)+31):(32*7)];
      end
      adc_valid_s    <= adc_valid_p;
    end else begin
      adc_data_0_s <= 32'b0;
      adc_data_1_s <= 32'b0;
      adc_data_2_s <= 32'b0;
      adc_data_3_s <= 32'b0;
      adc_data_4_s <= 32'b0;
      adc_data_5_s <= 32'b0;
      adc_data_6_s <= 32'b0;
      adc_data_7_s <= 32'b0;
	    adc_valid_s  <=  1'b0;           
    end 
  end

  // data (individual lanes)

 always @(negedge adc_clk) begin
    if( adc_format == 'h0 && NUM_CHANNELS == 8 ) begin     // 1 active line
      if (adc_cnt_p == 'h0 ) begin  
        adc_data_p[((256*0)+255):(256*0)] <= {255'd0, data_in[0]};
      end else begin
        adc_data_p[((256*0)+255):(255*0)] <= {adc_data_p[((256*0)+254):(256*0)], data_in[0]};
      end
    end else if( adc_format == 'h1 || (adc_format == 'h0 && NUM_CHANNELS == 4 )) begin  // 2 active lines or 1 active lane for 4 channels
      if (adc_cnt_p == 'h0 ) begin 
        adc_data_p[((128*0)+127):(128*0)] <= {127'd0, data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {127'd0, data_in[1]};
      end else begin
        adc_data_p[((128*0)+127):(128*0)] <= {adc_data_p[((128*0)+126):(128*0)], data_in[0]};
        adc_data_p[((128*1)+127):(128*1)] <= {adc_data_p[((128*1)+126):(128*1)], data_in[1]};
      end
    end else if( adc_format == 'h2 && NUM_CHANNELS == 8 ) begin  // 4 active lines
      if (adc_cnt_p == 'h0 ) begin
        adc_data_p[((64*0)+63):(64*0)] <= {63'd0, data_in[0]};
        adc_data_p[((64*1)+63):(64*1)] <= {63'd0, data_in[1]};
        adc_data_p[((64*2)+63):(64*2)] <= {63'd0, data_in[2]};
        adc_data_p[((64*3)+63):(64*3)] <= {63'd0, data_in[3]};
      end else begin
        adc_data_p[((64*0)+63):(64*0)] <= {adc_data_p[((64*0)+62):(64*0)], data_in[0]};
        adc_data_p[((64*1)+63):(64*1)] <= {adc_data_p[((64*1)+62):(64*1)], data_in[1]};
        adc_data_p[((64*2)+63):(64*2)] <= {adc_data_p[((64*2)+62):(64*2)], data_in[2]};
        adc_data_p[((64*3)+63):(64*3)] <= {adc_data_p[((64*3)+62):(64*3)], data_in[3]};
      end
    end else if( adc_format == 'h3 || (adc_format == 'h2 && NUM_CHANNELS == 4)  )  begin   // 8 active lines or 4 active lane for 4 channels
     if (adc_cnt_p == 'h0 ) begin 
        adc_data_p[((32*0)+31):(32*0)] <= {31'd0, data_in[0]};
        adc_data_p[((32*1)+31):(32*1)] <= {31'd0, data_in[1]};
        adc_data_p[((32*2)+31):(32*2)] <= {31'd0, data_in[2]};
        adc_data_p[((32*3)+31):(32*3)] <= {31'd0, data_in[3]};
        adc_data_p[((32*4)+31):(32*4)] <= {31'd0, data_in[4]};
        adc_data_p[((32*5)+31):(32*5)] <= {31'd0, data_in[5]};
        adc_data_p[((32*6)+31):(32*6)] <= {31'd0, data_in[6]};
        adc_data_p[((32*7)+31):(32*7)] <= {31'd0, data_in[7]};
      end else begin
        adc_data_p[((32*0)+31):(32*0)] <= {adc_data_p[((32*0)+30):(32*0)], data_in[0]};
        adc_data_p[((32*1)+31):(32*1)] <= {adc_data_p[((32*1)+30):(32*1)], data_in[1]};
        adc_data_p[((32*2)+31):(32*2)] <= {adc_data_p[((32*2)+30):(32*2)], data_in[2]};
        adc_data_p[((32*3)+31):(32*3)] <= {adc_data_p[((32*3)+30):(32*3)], data_in[3]};
        adc_data_p[((32*4)+31):(32*4)] <= {adc_data_p[((32*4)+30):(32*4)], data_in[4]};
        adc_data_p[((32*5)+31):(32*5)] <= {adc_data_p[((32*5)+30):(32*5)], data_in[5]};
        adc_data_p[((32*6)+31):(32*6)] <= {adc_data_p[((32*6)+30):(32*6)], data_in[6]};
        adc_data_p[((32*7)+31):(32*7)] <= {adc_data_p[((32*7)+30):(32*7)], data_in[7]};
      end
    end
  end

  // ready (single shot or continous)

  always @(posedge adc_clk) begin
    adc_ready_d1 <= adc_ready_in_s;
    adc_ready <= adc_sshot ~^ adc_ready_d1;
   
  end

  // control signals

  assign adc_status_clr_s = adc_status_clr & ~adc_status_clr_d;

  always @(posedge adc_clk) begin


    adc_sshot_m1 <= up_sshot;
    adc_sshot <= adc_sshot_m1;

    adc_format_m1 <= up_format;
    adc_format <= adc_format_m1;

    adc_crc_enable_m1 <= up_crc_enable;
    adc_crc_enable <= adc_crc_enable_m1;

    adc_crc_4_or_16_n_m1 <= 1'd1;
    adc_crc_4_or_16_n <= adc_crc_4_or_16_n_m1;

    adc_status_clr_m1 <= up_status_clr;
    adc_status_clr <= adc_status_clr_m1;
    adc_status_clr_d <= adc_status_clr;

    sync_miso_m1 <= sync_miso;
    sync_miso_m2 <= sync_miso_m1;
  end

  // rising edge detection sync_miso

  assign sync_miso_s = sync_miso_m2 &~ sync_miso_d;

  always @(posedge adc_clk) begin
  sync_miso_d <= sync_miso_m2;
  end

endmodule

// ***************************************************************************
// ***************************************************************************