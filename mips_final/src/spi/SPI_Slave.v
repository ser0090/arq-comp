`timescale 1ns / 1ps

/* 
 * estandar definido : CPOL=0 , CPHA=0
 * para ams info:
 * https://alchitry.com/blogs/tutorials/serial-peripheral-interface-spi
 */
module SPI_Slave #(
	parameter NB_BITS = 32
	)
	(
	 inout 				  			o_MISO,
	 output [NB_BITS-1:0] o_data, //datos recibidos
	 
	 input 				  			i_MOSI,
	 input 				  			i_SCLK,
	 input                i_cs,
	 input [NB_BITS-1:0]  i_data, //datos a transmitir
	 input 								i_rst,
	 input 								i_clk
	);

	localparam IDLE       = 2'b00,
						 RECEVING   = 2'b01,
						 FINISH     = 2'b10;

	localparam NB_COUNTER = clog2(NB_BITS);

	reg [NB_BITS-1:0]    shift_reg;
	reg [1:0]            state;
	reg [NB_COUNTER-1:0] bit_counter; 
	reg [NB_BITS-1:0]    data_out;
	reg 								 old_CLK; //auxiliar para detectar el flanco

	
	assign o_MISO = i_cs? shift_reg[NB_BITS-1] : 'bz;
	assign o_data = data_out;

	always @(posedge i_clk) begin
		if (i_rst) begin
			shift_reg   <= {NB_BITS{1'b0}};
			state       <= IDLE;
			bit_counter <= {NB_COUNTER{1'b0}};
			data_out    <= {NB_BITS{1'b0}};
			old_CLK     <= 1'b0;
		end
		else if (i_cs) begin
			old_CLK     <= i_SCLK;
			case(state)
				IDLE: begin
					  		shift_reg   <= i_data;
							state       <= RECEVING;
							bit_counter <= NB_BITS-1;
							data_out    <= data_out;
							end
				RECEVING: begin
										if(((old_CLK) && ~i_SCLK)) begin // si hay un flanco descendente
											if(bit_counter != 0) begin // si el contador no llego a 0 
												shift_reg   <= {shift_reg[NB_BITS-2:0],i_MOSI};
												bit_counter <= bit_counter - 1'b1;
												state       <= state;
												data_out    <= data_out;
											end
											else begin
												state       <= FINISH; // termino la recepcion/transmision 						
												shift_reg   <= shift_reg;
												data_out    <= shift_reg;
												bit_counter <= bit_counter;
											end
										end
										else begin
											shift_reg   <= shift_reg;
											bit_counter <= bit_counter;
											state       <= state;
											data_out    <= data_out;
										end
									end
				FINISH: begin
								state <= IDLE;
								shift_reg   <= shift_reg;
								bit_counter <= {NB_COUNTER{1'b0}};
								data_out    <= data_out;
								/*
								 * CODEAR ACA TODAS LAS ACCIONES NECESARIAS PARA 
								 * QUE EL MODULO SEA UTIL, EJ: ESCRIBIR LA MEMORIA
								 */
								end
								
				default: begin
									shift_reg 	<= shift_reg;
									state 			<= state;
									bit_counter <= bit_counter;
									data_out    <= data_out;
							end
				endcase
		end
		else begin
									shift_reg 	<= shift_reg;
									state 			<= state;
									bit_counter <= bit_counter;
									data_out    <= data_out;
		end
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
