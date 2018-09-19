`timescale 1ns/1ps

module tb_rx_i_a(); /* this is automatically generated */

   parameter NB_BITS = 8;
   
   reg i_clk;
	 reg i_rst;
   
   reg i_rx;
   
   reg i_tx_done;

	 wire o_rate;

   wire [NB_BITS-1:0] o_rx_data;
   wire               o_rx_done;
   
   wire [NB_BITS-1:0] o_ic_data;
   wire               o_tx_start;

   wire               tx;
   wire               o_tx_done;
   
   
   
	 // clock
	 initial begin
		  i_clk = 0;
		  i_rst = 1'b1;
      i_tx_done = 1'b0;
      i_rx = 1'b0;

		  #10 i_rst = 1'b0;
      #10 i_rx = 1'b0; //start

		  #5200 i_rx = 1'b1; // data
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;

		  #5200 i_rx = 1'b1; // stop
      
      #5200 i_rx = 1'b0; //start

      #5200 i_rx = 1'b1; // ADD
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b1;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;

		  #5200 i_rx = 1'b1; // stop

      
      #5200 i_rx = 1'b0; //start

		  #5200 i_rx = 1'b1; // data
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;
		  #5200 i_rx = 1'b0;

		  #5200 i_rx = 1'b1; // stop
 
      
		  #200000 $finish;

	 end

	 always #0.5 i_clk = ~i_clk;

   Baud_rate_gen
     u_baud_rate_gen 
       (
        .o_rate (o_rate),
        .i_clk  (i_clk),
        .i_rst  (i_rst)
        );
   
   Rx_uart
     u_Rx_uart 
       (
			  .o_data    (o_rx_data),
			  .o_rx_done (o_rx_done),
			  .i_clk     (i_clk),
			  .i_rate    (o_rate),
			  .i_rx      (i_rx),
			  .i_rst     (i_rst)
		    );

	 
   Interface_Circuit
     u_interface_circuit 
       (
			  .o_data     (o_ic_data),
			  .o_tx_start (o_tx_start),
			  .i_rx_data  (o_rx_data),
			  .i_rx_done  (o_rx_done),
			  .i_tx_done  (o_tx_done),
			  .i_rst      (i_rst),
			  .i_clk      (i_clk)
		    );

   Tx_uart  
     inst_Tx_uart 
       (
			  .o_tx         (tx),
			  .o_tx_done    (o_tx_done),
			  .i_data_ready (o_tx_start),
			  .i_clk        (i_clk),
			  .i_rate		    (o_rate),
			  .i_rst        (i_rst),
			  .i_data       (o_ic_data)
		    );

endmodule // tb_baud_rate_get
