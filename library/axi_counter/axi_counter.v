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
  input rst,
  input clk,
  output [2:0] leds,
  
  
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
  reg clk_div_1Hz;
  wire reset;
  // counter wires - 3 bits counter (3 Flip Flops)
  wire D0;
  wire Q0;
  wire D1;
  wire Q1;
  wire D2;
  wire Q2;
  // signal name changes

 debouncer debouncer_reset(clk_div_1Hz,rst,reset);
 
//counter core
 assign D0=~Q0;
 assign D1=Q0^Q1; //xor operator
 assign D2=(Q0&Q1)^Q2;

 d_flip_flop led_d0(clk_div_1Hz, D0, reset, Q0);
 d_flip_flop led_d1(clk_div_1Hz, D1, reset, Q1);
 d_flip_flop led_d2(clk_div_1Hz, D2, reset, Q2);
 
 assign leds[0]=Q0;
 assign leds[1]=Q1;
 assign leds[2]=Q2;

// clock divider 
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd150000000;

// The frequency of the input clk_in divided by DIVISOR
// The frequency of the output clk_out = 150Mhz/150.000.000 = 1Hz

always @(posedge clk) 
begin 
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;

 clk_div_1Hz <= (counter<DIVISOR/2)?1'b1:1'b0;
end

endmodule
