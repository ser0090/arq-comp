`timescale 1ns / 1ps

/* 
 * estandar definido : CPOL=0 , CPHA=0
 * para ams info:
 * https://alchitry.com/blogs/tutorials/serial-peripheral-interface-spi
 */
module SPI_Slave_Parallel #(
	 parameter NB_BITS = 32
	)
	(
	 inout 	[NB_BITS-1:0] o_MISO,
	 output [NB_BITS-1:0] o_data, //datos recibidos

	 input [NB_BITS-1:0]  i_MOSI,
	 input 				  			i_SCLK,
	 input                i_cs,
	 input [NB_BITS-1:0]  i_data, //datos a transmitir
	 input 								i_rst,
	 input 								i_clk
	);

	localparam IDLE        = 2'b00,
						 TRANSFERING = 2'b01,
						 FINISH      = 2'b10;

	localparam NB_COUNTER = clog2(NB_BITS);

	reg [NB_BITS-1:0]    shift_reg;
	reg [NB_BITS-1:0]    data_out;
	reg 								 old_CLK; //auxiliar para detectar el flanco
	
	assign o_MISO = i_cs? shift_reg : 'bz;
	assign o_data = data_out;

	always @(posedge i_clk) begin
		if (i_rst) begin 
			data_out <= {NB_BITS{1'b0}};
		end
		else if (i_cs && (~old_CLK && i_SCLK)) begin // flanco ascendente
			data_out <= i_MOSI;
		end
		else begin
			data_out <= data_out;
		end
	end
always @(posedge i_clk) begin
		if (i_rst) begin 
			shift_reg <= {NB_BITS{1'b0}};
		end
		else if (i_cs && (old_CLK && ~i_SCLK)) begin // flanco ascendente
			shift_reg <= i_data;
		end
		else begin
			shift_reg <= shift_reg;
		end
	end

always @(posedge i_clk) begin
		if (i_rst) begin 
			shift_reg <= {NB_BITS{1'b0}};
		end
		else if (i_cs) 
			old_CLK     <= i_SCLK;
	end

   /**
    * Funcion clog2 , Calcula el logaritmo base 2
    */
   function integer clog2;
      input integer   depth;
      for (clog2=0; depth>0; clog2=clog2+1)
        depth = depth >> 1;
   endfunction // clog2

endmodule
