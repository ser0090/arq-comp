
`timescale 1ns/1ps


module tb_baud_rate_get(); /* this is automatically generated */
	 reg i_clk;
	 reg i_rst;
   
	 wire o_rate;
   
	 // clock
	 initial begin
		  i_clk = 0;
		  i_rst = 1'b1;
      
		  #10 i_rst = 1'b0;
      
		  #10000 $finish;

	 end


	 always #2.5 i_clk = ~i_clk;

   Baud_rate_gen
     u_baud_rate_gen 
       (
        .o_rate (o_rate),
        .i_clk  (i_clk),
        .i_rst  (i_rst)
        );
   
endmodule // tb_baud_rate_get
