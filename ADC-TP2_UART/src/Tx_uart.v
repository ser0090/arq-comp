`timescale 1ns / 1ps

module Tx_uart #(
             parameter NB_BITS = 8 /* asigancion de parametro local */
             )(
               output [NB_BITS:0]  o_data, /* N bits more carry */
               output o_rx_done,
               input i_clk,
               input i_rx
               );



endmodule