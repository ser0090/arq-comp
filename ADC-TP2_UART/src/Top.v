`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8

module Top #
  (
   parameter NB_BITS =`NB_BITS
   )
  (
   output UART_RXD_OUT,
   input  UART_TXD_IN,
   input  i_clk,
   input  BTNC
   );

   wire   rate;
   wire [NB_BITS-1:0] rx_data;
   wire [NB_BITS-1:0] tx_data;
   wire               rx_done;
   wire               tx_start;
   wire               tx_done;
   
   wire i_rst;
   wire i_rx_uart;
   wire o_tx_uart;
   
   assign i_rst = BTNC;
   
   Baud_rate_gen
     u_baud_rate_gen 
       (
        .o_rate (rate),
        .i_clk  (i_clk),
        .i_rst  (i_rst)
        );
   
   Rx_uart
     u_Rx_uart 
       (
			  .o_data    (rx_data),
			  .o_rx_done (rx_done),
			  .i_clk     (i_clk),
			  .i_rate    (rate),
			  .i_rx      (UART_TXD_IN),
			  .i_rst     (i_rst)
		    );

   Interface_Circuit
     u_interface_circuit 
       (
			  .o_data     (tx_data),
			  .o_tx_start (tx_start),
			  .i_rx_data  (rx_data),
			  .i_rx_done  (rx_done),
			  .i_tx_done  (tx_done),
			  .i_rst      (i_rst),
			  .i_clk      (i_clk)
		    );

   Tx_uart  
     u_Tx_uart 
       (
			  .o_tx         (UART_RXD_OUT),
			  .o_tx_done    (tx_done),
			  .i_data_ready (tx_start),
			  .i_clk        (i_clk),
			  .i_rate		    (rate),
			  .i_rst        (i_rst),
			  .i_data       (tx_data)
		    );
   
endmodule // Top
