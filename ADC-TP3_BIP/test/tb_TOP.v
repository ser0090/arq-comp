
`timescale 1ns/1ps

module tb_TOP (); /* this is automatically generated */

	parameter DATA_WIDTH     = 16;
	parameter UART_DATA_SIZE = 8;
	parameter INS_MEM_DEPTH  = 2048;
	parameter DATA_MEM_DEPTH = 2048;
	parameter NB_SIGX        = 11;
	//parameter PROGRAM_FILE   = "/home/martin/Documentos/arq-comp/ADC-TP3_BIP/src/program_memory.txt";

	reg i_clk;
	reg i_rst;
	reg i_rx;
	wire o_tx;
	// clock
	initial begin
		i_clk = 0;
		forever #0.5 i_clk = ~i_clk;
	end


	// reset
	initial begin
		i_clk = 0;
		i_rst = 1;
		i_rx = 1;
		#5 i_rst = 0;
		#3 i_rx = 1'b0; //start

		#400 i_rx = 1'b0; // data
		#400 i_rx = 1'b0;
		#400 i_rx = 1'b0;
		#400 i_rx = 1'b1;
		#400 i_rx = 1'b0;
		#400 i_rx = 1'b0;
		#400 i_rx = 1'b1;
		#400 i_rx = 1'b0;

		#400 i_rx = 1'b1; // stop
		#5200
		$finish;
	end

	// (*NOTE*) replace reset, clock, others




	Top #(
			.DATA_WIDTH(DATA_WIDTH),
			.UART_DATA_SIZE(UART_DATA_SIZE),
			.INS_MEM_DEPTH(INS_MEM_DEPTH),
			.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
			.NB_SIGX(NB_SIGX)
			//.PROGRAM_FILE(PROGRAM_FILE)
		) inst_TOP (
			.UART_RXD_OUT  (o_tx),
			.UART_TXD_IN  (i_rx),
			.i_clk (i_clk),
			.BTNC (i_rst)
		);


endmodule
