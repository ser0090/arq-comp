`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8

module Top #
  (
   parameter NB_BITS =`NB_BITS
   )
  (
   output JA1,
   output JA2,
   output UART_RXD_OUT,
   input  UART_TXD_IN,
   input  i_clk,
   input  BTNC
   );

   wire         rate;
   wire [NB_BITS-1:0] rx_data;
   wire [NB_BITS-1:0] tx_data;
   wire               rx_done;
   wire               tx_start;
   wire               tx_done;
   
   wire               i_rst;
   wire               rx_uart;
   wire               tx_uart;
   
   assign i_rst = BTNC;

   assign rx_uart = UART_TXD_IN;
   assign UART_RXD_OUT= tx_uart;
   
   assign JA1 = rx_uart; /* salidas para el ver osic*/
   assign JA2 = tx_uart;
   
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
			  .i_rx      (rx_uart),
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
			  .o_tx         (tx_uart),
			  .o_tx_done    (tx_done),
			  .i_data_ready (tx_start),
			  .i_clk        (i_clk),
			  .i_rate		    (rate),
			  .i_rst        (i_rst),
			  .i_data       (tx_data)
		    );
   
endmodule // Top
