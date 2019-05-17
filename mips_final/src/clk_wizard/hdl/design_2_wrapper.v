//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
//Date        : Fri May 17 15:26:13 2019
//Host        : grela running 64-bit Ubuntu 18.04.2 LTS
//Command     : generate_target design_2_wrapper.bd
//Design      : design_2_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_2_wrapper
   (clk_out1_0,
    locked_0,
    reset,
    sys_clock);
  output clk_out1_0;
  output locked_0;
  input reset;
  input sys_clock;

  wire clk_out1_0;
  wire locked_0;
  wire reset;
  wire sys_clock;

  design_2 design_2_i
       (.clk_out1_0(clk_out1_0),
        .locked_0(locked_0),
        .reset(reset),
        .sys_clock(sys_clock));
endmodule
