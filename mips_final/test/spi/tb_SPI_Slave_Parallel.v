
`timescale 1ns/1ps

module tb_SPI_Slave_Parallel (); /* this is automatically generated */
	
	parameter NB_BITS     = 32;

	wire [NB_BITS-1:0] o_MISO;
	wire [NB_BITS-1:0] o_data;
	
	reg i_rst;
	reg i_clk;
	reg [NB_BITS-1:0] i_MOSI;
	reg               i_SCLK;
	reg               i_cs;
	reg [NB_BITS-1:0] i_data;

	localparam MOSI_VALUE = 32'hAAAAAAAA;
	// clock
	initial begin
		i_clk  = 1'b0;
		i_rst  = 1'b1;
		i_MOSI = {NB_BITS{1'b0}};
		i_SCLK  = 1'b0;
		i_cs   = 1'b0;
		i_data = {NB_BITS{1'b0}};
		
		#34
		i_rst = 1'b0;
		i_data = 32'hA0000005;
		#11
		i_cs   = 1'b1;
		i_MOSI = MOSI_VALUE;
	   
	  //for(integer i=0; i<NB_BITS;i=i+1) begin
		//repeat(NB_BITS) begin
		#50 
		i_SCLK  = 1'b1;
		#50 
		i_SCLK  = 1'b0;
		//	i_MOSI  = 1'b0;
		//end
		#50
		i_MOSI  = {NB_BITS{1'b0}};
		i_cs = 1'b0;
		#200
		$finish();

	
	end

	always #5 i_clk = ~i_clk;

	SPI_Slave_Parallel #(
			.NB_BITS(NB_BITS)
		) inst_SPI_Slave (
			.o_MISO (o_MISO),
			.o_data (o_data),
			.i_MOSI (i_MOSI),
			.i_SCLK  (i_SCLK),
			.i_cs   (i_cs),
			.i_data (i_data),
			.i_rst  (i_rst),
			.i_clk  (i_clk)
		);


endmodule
