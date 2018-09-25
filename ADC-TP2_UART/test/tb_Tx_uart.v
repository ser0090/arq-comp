
`timescale 1ns/1ps

module tb_Tx_uart (); /* this is automatically generated */
parameter NB_BITS = 8;

	reg clk;
	reg res;
	reg [NB_BITS-1:0] data;
	reg data_ready;
	wire done;
	wire tx;
	wire rate;
	// clock
	initial begin
		clk = 0;
		res = 1'b1;
		data_ready = 1'b0;
		data = 8'h0;
		#2 res = 1'b0;

		#10 data = 8'b01010011; //start
			data_ready = 1'b1;
		#20 data_ready = 1'b0; 
		#60000 $finish;
	end

	always #0.5 clk = ~clk;

	Tx_uart #(
			.NB_BITS(NB_BITS)
		) inst_Tx_uart (
			.o_tx         (tx),
			.o_tx_done    (done),
			.i_data_ready (data_ready),
			.i_clk        (clk),
			.i_rate		  (rate),
			.i_rst        (res),
			.i_data       (data)
		);

	Baud_rate_gen 
		inst_Baud_rate_gen 
		(
			.o_rate (rate),
			.i_clk  (clk),
			.i_rst  (res)
		);

	
endmodule
