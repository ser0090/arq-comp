
`timescale 1ns/1ps

module tb_BIP (); /* this is automatically generated */
   parameter DATA_WIDTH       = 16;
	 parameter INS_MEM_DEPTH  = 2048;
	 parameter DATA_MEM_DEPTH = 1024;
	 parameter NB_SIGX        = 11;
	 parameter PROGRAM_FILE   = "/home/martin/Documentos/arq-comp/ADC-TP3_BIP/src/program_memory.txt";
   
	 reg  i_clk;
	 reg  i_rst;
   wire [DATA_WIDTH-1:0] o_acc;
	 
	 initial begin
		  i_clk = 0;
		  i_rst = 1;
		  #5
		    i_rst = 0;
		  #40
		    $finish;
	 end
	 always #0.5 i_clk = ~i_clk;
   
	 BIP #
     (
			.DATA_WIDTH(DATA_WIDTH),
			.INS_MEM_DEPTH(INS_MEM_DEPTH),
			.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
			.NB_SIGX(NB_SIGX),
			.PROGRAM_FILE(PROGRAM_FILE)
		  ) 
   inst_BIP 
     (
      .o_acc (o_acc),
			.i_clk (i_clk),
			.i_rst (i_rst)
		  );
   
endmodule // tb_BIP

