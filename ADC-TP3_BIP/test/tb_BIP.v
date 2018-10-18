
`timescale 1ns/1ps

module tb_BIP (); /* this is automatically generated */

	reg  i_clk;
	reg  i_rst;

	// clock
	initial begin
		i_clk = 0;
		forever #0.5 i_clk = ~i_clk;
	end

	// reset
	initial begin
		i_rst = 1;
		#5
		i_rst = 0;
		#40
		$finish;
	end

	// (*NOTE*) replace reset, clock, others

	parameter NB_BITS        = 16;
	parameter INS_MEM_DEPTH  = 2048;
	parameter DATA_MEM_DEPTH = 1024;
	parameter NB_SIGX        = 11;
	parameter PROGRAM_FILE   = "/home/martin/Documentos/arq-comp/ADC-TP3_BIP/src/program_memory.txt";



	BIP #(
			.NB_BITS(NB_BITS),
			.INS_MEM_DEPTH(INS_MEM_DEPTH),
			.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
			.NB_SIGX(NB_SIGX),
			.PROGRAM_FILE(PROGRAM_FILE)
		) inst_BIP (
			.i_clk (i_clk),
			.i_rst (i_rst)
		);


endmodule
