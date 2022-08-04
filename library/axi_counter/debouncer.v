// ***************************************************************************
// ***************************************************************************
// Copyright 2022 (c) Analog Devices, Inc. All rights reserved.
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
// This is the LVDS/DDR interface, note that overrange is independent of data path,
// software will not be able to relate overrange to a specific sample!

`timescale 1ns/100ps

module debouncer (
  input     in,
  input     clk,
  output    debounced_out
);

reg [26:0] nb = 0;

wire       slow_clk;
wire       Q0;
wire       Q1; 
wire       Q2;
wire       Q2_bar;

assign Q2_bar = ~Q2;
assign debounced_out = Q1 & Q2_bar;

d_flip_flop d0(
   .clk(slow_clk),
   .reset(1'b0),
   .d(Q0),
   .q(Q1));

d_flip_flop d1(
   .clk(slow_clk),
   .reset(1'b0),
   .d(Q0),
   .q(Q1));

d_flip_flop d2(
   .clk(slow_clk),
   .reset(1'b0),
   .d(Q0),
   .q(Q1));

// clock divider 

assign slow_clk = (nb < 125000)?1'b0:1'b1;

always @(posedge clk)
begin
    nb <= (nb>=249999)?0:nb+1;
    
end
endmodule
