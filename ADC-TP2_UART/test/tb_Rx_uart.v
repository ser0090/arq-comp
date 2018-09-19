
`timescale 1ns/1ps


module tb_Rx_uart (); /* this is automatically generated */
	parameter NB_BITS = 8;
		
	reg clk;
	reg rx;
	reg res;
	wire[NB_BITS-1:0] data;
	wire done;
	// clock
	initial begin
		clk = 0;
		res = 1'b1;
		rx = 1'b1;
		#2 res = 1'b0;

		#10 rx = 1'b0; //start

		#16 rx = 1'b1; // data
		#16 rx = 1'b0;
		#16 rx = 1'b0;
		#16 rx = 1'b0;
		#16 rx = 1'b1;
		#16 rx = 1'b0;
		#16 rx = 1'b1;
		#16 rx = 1'b0;

		#16 rx = 1'b1; // stop

		#50 $finish;

	end


	always #0.5 clk = ~clk;


	Rx_uart #(
			.NB_BITS(NB_BITS)
		) inst_Rx_uart (
			.o_data    (data),
			.o_rx_done (done),
			.i_clk     (clk),
			.i_rate    (clk),
			.i_rx      (rx),
			.i_rst     (res)
		);

	
endmodule
