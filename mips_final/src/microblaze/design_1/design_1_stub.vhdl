-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Fri May 17 22:07:16 2019
-- Host        : s510u running 64-bit Manjaro Linux
-- Command     : write_vhdl -force -mode synth_stub /home/sergio/Documentos/DDA2018/rtl/micro/design_1/design_1_stub.vhdl
-- Design      : design_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1 is
  Port ( 
    clock50 : out STD_LOGIC;
    gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_tri_t : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_lock_clock : out STD_LOGIC;
    reset : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC
  );

end design_1;

architecture stub of design_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clock50,gpio_rtl_tri_i[31:0],gpio_rtl_tri_o[31:0],gpio_rtl_tri_t[31:0],o_lock_clock,reset,sys_clock,usb_uart_rxd,usb_uart_txd";
begin
end;
