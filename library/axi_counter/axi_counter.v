// ***************************************************************************
// ***************************************************************************
// Copyright 2021 (c) Analog Devices, Inc. All rights reserved.
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

module axi_counter (

  // counter ports 

  input               counter_clk,
  input               counter_reset,
  output              led0,
  output              led1,
  output              led2,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [ 15:0]     s_axi_awaddr,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [ 31:0]     s_axi_wdata,
  input       [  3:0]     s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [  1:0]     s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [ 15:0]     s_axi_araddr,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 31:0]     s_axi_rdata,
  output      [  1:0]     s_axi_rresp,
  input                   s_axi_rready,
  input       [  2:0]     s_axi_awprot,
  input       [  2:0]     s_axi_arprot
);

  // internal clocks and resets

  wire              up_clk;
  wire              up_rstn;

  // internal signals

  wire              up_wreq_s;
  wire    [ 13:0]   up_waddr_s;
  wire    [ 31:0]   up_wdata_s;
  wire              up_wack_s;
  wire              up_rreq_s;
  wire    [ 13:0]   up_raddr_s;
  wire    [ 31:0]   up_rdata_s;
  wire              up_rack_s;

  // counter wires

  wire debounced_reset;
  wire q0;
  wire q1;
  wire q2;
  wire clk_1hz;

  reg [26:0] counter_divider = 27'b0;
  reg divided_clk = 1'b0;

  // signal name changes

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign led0 = q0; 
  assign led1 = q1;
  assign led2 = q2; 

  //counter core

 debouncer debouncer_reset(
   .clk(counter_clk),
   .in(counter_reset),
   .debounced_out(debounced_reset));

 d_flip_flop led_d0(
   .clk(divided_clk),
   .reset(debounced_reset),
   .d(q2),
   .q(q0));

d_flip_flop led_d1(
   .clk(divided_clk),
   .reset(debounced_reset),
   .d(q0),
   .q(q1));

d_flip_flop led_d2(
   .clk(divided_clk),
   .reset(debounced_reset),
   .d(q1),
   .q(q2));

always @(posedge counter_clk) begin : clk_divider
    counter_divider <= (counter_divider>=1999)?0:counter_divider+1;
    divided_clk <= (counter_divider < 1000)?1'b0:1'b1;  
end

endmodule
