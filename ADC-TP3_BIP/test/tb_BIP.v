
`timescale 1ns/1ps

module tb_BIP (); /* this is automatically generated */

	logic rstb;
	logic srst;
	logic clk;

	// clock
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// reset
	initial begin
		rstb = 0;
		srst = 0;
		#20
		rstb = 1;
		repeat (5) @(posedge clk);
		srst = 1;
		repeat (1) @(posedge clk);
		srst = 0;
	end

	// (*NOTE*) replace reset, clock, others

	parameter NB_BITS        = 16;
	parameter INS_MEM_DEPTH  = 2048;
	parameter DATA_MEM_DEPTH = 1024;
	parameter NB_SIGX        = 11;
	parameter PROGRAM_FILE   = "";
	parameter NB_SELA        = 2;

	logic  i_clk;
	logic  i_rst;

	BIP #(
			.NB_BITS(NB_BITS),
			.INS_MEM_DEPTH(INS_MEM_DEPTH),
			.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
			.NB_SIGX(NB_SIGX),
			.PROGRAM_FILE(PROGRAM_FILE),
			.NB_SELA(NB_SELA)
		) inst_BIP (
			.i_clk (i_clk),
			.i_rst (i_rst)
		);

	initial begin
		// do something

		repeat(10)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_BIP.fsdb");
			$fsdbDumpvars(0, "tb_BIP", "+mda", "+functions");
		end
	end

endmodule
