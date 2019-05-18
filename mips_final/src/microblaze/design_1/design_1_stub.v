// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Fri May 17 22:07:16 2019
// Host        : s510u running 64-bit Manjaro Linux
// Command     : write_verilog -force -mode synth_stub /home/sergio/Documentos/DDA2018/rtl/micro/design_1/design_1_stub.v
// Design      : design_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module design_1(clock50, gpio_rtl_tri_i, gpio_rtl_tri_o, 
  gpio_rtl_tri_t, o_lock_clock, reset, sys_clock, usb_uart_rxd, usb_uart_txd)
/* synthesis syn_black_box black_box_pad_pin="clock50,gpio_rtl_tri_i[31:0],gpio_rtl_tri_o[31:0],gpio_rtl_tri_t[31:0],o_lock_clock,reset,sys_clock,usb_uart_rxd,usb_uart_txd" */;
  output clock50;
  input [31:0]gpio_rtl_tri_i;
  output [31:0]gpio_rtl_tri_o;
  output [31:0]gpio_rtl_tri_t;
  output o_lock_clock;
  input reset;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;
endmodule
