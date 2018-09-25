`timescale 1ns/1ps

module tb_top(); /* this is automatically generated */

   parameter NB_BITS = 8;
   
   reg i_clk;
	 reg i_rst;
   
   reg i_rx;
   wire o_tx;
  
	 // clock
	 initial begin
		  i_clk = 1'b0;
		  i_rst = 1'b1;
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

   Top 
     u_top 
       (
			  .UART_RXD_OUT (o_tx),
			  .UART_TXD_IN  (i_rx),
			  .i_clk        (i_clk),
			  .BTNC         (i_rst)
		    );
   
endmodule // tb_baud_rate_get
