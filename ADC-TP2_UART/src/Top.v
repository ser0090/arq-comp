`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8

module Top #
  (
   parameter NB_BITS =`NB_BITS
   )
  (
   output o_tx_uart,
   input  i_rx_uart,
   input  i_clk,
   input  i_rst
   );

   wire   rate;
   wire [NB_BITS-1:0] rx_data;
   wire [NB_BITS-1:0] tx_data;
   wire               rx_done;
   wire               tx_start;
   wire               tx_done;
   
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
			  .i_rx      (i_rx_uart),
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
     inst_Tx_uart 
       (
			  .o_tx         (o_tx_uart),
			  .o_tx_done    (tx_done),
			  .i_data_ready (tx_start),
			  .i_clk        (i_clk),
			  .i_rate		    (rate),
			  .i_rst        (i_rst),
			  .i_data       (tx_data)
		    );
   
endmodule // Top
