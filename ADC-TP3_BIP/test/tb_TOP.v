
`timescale 1ns/1ps

module tb_TOP (); /* this is automatically generated */

	parameter DATA_WIDTH     = 16;
	parameter UART_DATA_SIZE = 8;
	parameter INS_MEM_DEPTH  = 2048;
	parameter DATA_MEM_DEPTH = 2048;
	parameter NB_SIGX        = 11;
	parameter PROGRAM_FILE   = "/home/martin/Documentos/arq-comp/ADC-TP3_BIP/src/program_memory.txt";

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
		#5
		i_rst = 0;
		#5200
		$finish;
	end

	// (*NOTE*) replace reset, clock, others




	TOP #(
			.DATA_WIDTH(DATA_WIDTH),
			.UART_DATA_SIZE(UART_DATA_SIZE),
			.INS_MEM_DEPTH(INS_MEM_DEPTH),
			.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
			.NB_SIGX(NB_SIGX),
			.PROGRAM_FILE(PROGRAM_FILE)
		) inst_TOP (
			.o_tx  (o_tx),
			.i_rx  (i_rx),
			.i_clk (i_clk),
			.i_rst (i_rst)
		);



endmodule
