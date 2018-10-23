
`timescale 1ns/1ps

module tb_BIP (); /* this is automatically generated */
   parameter NB_BITS        = 16;
   parameter INS_MEM_DEPTH  = 2048;
   parameter DATA_MEM_DEPTH = 1024;
   parameter NB_SIGX        = 11;
   parameter PROGRAM_FILE   = "/home/sergio/Documentos/ADC/arq-comp/ADC-TP3_BIP/src/program_memory.txt";
   
   reg  i_clk;
   reg  i_rst;
   wire [NB_BITS-1:0] o_acc, o_prog_inst;
   wire [10:0]        o_pc;
   initial begin
	  	i_clk = 0;
  		i_rst = 1;
  		#5
        i_rst = 0;
   		#40
   		  $finish;
   end
   always #0.5 i_clk = ~i_clk;
   
   BIP
     inst_BIP 
       (
        .o_acc       (o_acc),
        .o_prog_inst (o_prog_inst),
        .o_pc        (o_pc),
      	.i_clk       (i_clk),
        .BTNC        (i_rst)
       	);
   
endmodule // tb_BIP

