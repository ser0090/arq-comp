
`timescale 1ns/1ps
///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar

module tb_Data_Memory (); /* this is automatically generated */

	localparam RAM_WIDTH      = 32;
	localparam NB_DEPTH       = 10;
	localparam FILE_DEPTH     = 31;
	
	reg        i_clk;
    reg        i_rst;

	wire [RAM_WIDTH-1:0] o_data;
	reg  [NB_DEPTH-1:0] i_addr;
	reg [RAM_WIDTH-1:0] i_data;
	reg           [1:0] i_write_enable;
	reg           [1:0] i_read_enable;
	
	localparam ADDR_BASE  = 10'h3F0;
	localparam DATA_BYTE  = 32'hFFFFFF33;
	localparam DATA_HALF  = 32'hFFFF5555;
  localparam DATA_WORD  = 32'h77777777;

	initial begin
		i_clk = 1'b0;
		i_addr = 10'b0;
		i_data = 32'hFFFFFFFF;
		i_write_enable = `WRITE_DISABLE;
		i_read_enable = `READ_DISABLE;

      $display("\n\n\n");
      $display("******************************************************************************");
      $display("******************              TESTS DE Data Memory          ****************");
      $display("******************************************************************************");
 
		

		//test WRITE/READ WORD
		#10
		i_addr = ADDR_BASE;
        i_data = DATA_WORD;
        i_write_enable = `WRITE_WORD;
        i_read_enable = `READ_WORD;
        #10
        if(o_data == DATA_WORD) begin
         $display("WORD_WRITE / WORD_READ Test OK");
         end
        else begin
         $display("WORD_WRITE / WORD_READ Test fail\n        \
                                 expected:  %b\n        \
                                 out:%b",DATA_WORD,o_data);
        end

    #10
        i_write_enable = `WRITE_DISABLE;
        i_read_enable = `READ_HALFWORD;
        #10
        if(o_data == {{`HALFWORD{1'b0}},DATA_WORD[`HALFWORD-1:0]} )begin
         $display("READ_HALFWORD Test OK");
         end
        else begin
         $display("READ_HALFWORD Test fail\n        \
                                 expected:  %b\n        \
                                 out:%b",{{`HALFWORD{1'b0}},DATA_WORD[`HALFWORD-1:0]},o_data);
        end

    #10
        i_write_enable = `WRITE_DISABLE;
        i_read_enable = `READ_BYTE;
        #10
        if(o_data == {{`HALFWORD{1'b0}},{`BYTE{1'b0}},DATA_WORD[`BYTE-1:0]} )begin
         $display("READ_BYTE Test OK");
         end
        else begin
         $display("READ_BYTE Test fail\n        \
                                 expected:  %b\n        \
                                 out:%b",{{`HALFWORD{1'b0}},{`BYTE{1'b0}},DATA_WORD[`BYTE-1:0]},o_data);
        end


    #10
		    i_addr = ADDR_BASE;
        i_data = DATA_HALF;
        i_write_enable = `WRITE_HALFWORD;
        i_read_enable = `READ_WORD;
        #10
        if(o_data == {DATA_WORD[`WORD-1:`HALFWORD],DATA_HALF[`HALFWORD-1:0]}) begin
         $display("WRITE_HALF Test OK");
         end
        else begin
         $display("WRITE_HALF Test fail\n        \
                                 expected:  %b\n        \
                                 out:%b",{DATA_WORD[`WORD-1:`HALFWORD],DATA_HALF[`HALFWORD-1:0]},o_data);
        end

    #10
		    i_addr = ADDR_BASE;
        i_data = DATA_BYTE;
        i_write_enable = `WRITE_BYTE;
        i_read_enable = `READ_WORD;
        #10
        if(o_data == {DATA_WORD[`WORD-1:`HALFWORD],DATA_HALF[`HALFWORD-1:`BYTE],DATA_BYTE[`BYTE-1:0]}) begin
         $display("WRITE_BYTE Test OK");
         end
        else begin
         $display("WRITE_BYTE Test fail\n        \
                                 expected:  %b\n        \
                                 out:%b",{DATA_WORD[`WORD-1:`HALFWORD],DATA_HALF[`HALFWORD-1:`BYTE],DATA_BYTE[`BYTE-1:0]},o_data);
        end




  #10
  $display("\n\n\n");
  $finish;
	end

	// (*NOTE*) replace reset, clock, others

	

	always #2.5 i_clk = ~i_clk;
	Data_Memory #(
			.RAM_WIDTH(RAM_WIDTH),
			.NB_DEPTH(NB_DEPTH),
			.FILE_DEPTH(FILE_DEPTH)
			
		) inst_Data_Memory (
			.o_data         (o_data),
			.i_addr         (i_addr),
			.i_data         (i_data),
			.i_write_enable (i_write_enable),
			.i_read_enable  (i_read_enable),
			.i_clk          (i_clk)
		);


endmodule
