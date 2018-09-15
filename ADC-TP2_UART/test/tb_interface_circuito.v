`timescale 1ns / 1ps

module tb_interface_circuit ();
   parameter NB_BITS = 8;
   parameter NB_SEL = 6;
   parameter LEN = 3;
   
   wire [NB_BITS-1:0] o_data;
   wire               o_tx_start;
   
   reg [NB_BITS-1:0]  i_rx_data;
   reg                i_rx_done;
   reg                i_tx_done;
   reg                i_rst;
   reg                i_clk;

   initial begin
      i_clk = 1'b0;
      i_rx_data = {NB_BITS{1'b0}};
      i_rx_done = 1'b0;
      i_tx_done = 1'b0;
      i_rst = 1'b1;

      #10 i_rst = 1'b0;
      #10 i_rx_data = 8'h0f;
      #5 i_rx_done = 1'b1;
      #15 i_rx_done = 1'b0;

      #10 i_rx_data = 8'd43;
      #5 i_rx_done = 1'b1;
      #15 i_rx_done = 1'b0;

      #10 i_rx_data = 8'h01;
      #5 i_rx_done = 1'b1;
      #15 i_rx_done = 1'b0;

      #50 i_tx_done = 1'b1;
      #10 i_tx_done = 1'b0;
      #20 $finish;
      
   end
   always #2.5 i_clk = ~i_clk;

   Interface_Circuit #(.NB_BITS(NB_BITS), .NB_SEL(NB_SEL))
     u_interface_circuit 
       (
        .o_data     (o_data),
			  .o_tx_start (o_tx_start),
			  .i_rx_data  (i_rx_data),
			  .i_rx_done  (i_rx_done),
			  .i_tx_done  (i_tx_done),
			  .i_rst      (i_rst),
			  .i_clk      (i_clk)
		    );
endmodule
