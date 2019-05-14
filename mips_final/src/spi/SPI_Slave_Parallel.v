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
	reg [1:0]            state; 
	reg [NB_BITS-1:0]    data_out;
	reg 								 old_CLK; //auxiliar para detectar el flanco

	
	assign o_MISO = i_cs? shift_reg : 'bz;
	assign o_data = data_out;

	always @(posedge i_clk) begin
		if (i_rst) begin
			shift_reg   <= {NB_BITS{1'b0}};
			state       <= IDLE;
			data_out    <= {NB_BITS{1'b0}};
			old_CLK     <= 1'b0;
		end
		else if (i_cs) begin
			old_CLK     <= i_SCLK;
			case(state)
				IDLE: begin 
				/* este estado inicia el ciclo cuando se habilita el chip,
				 * los dato a la entrada se almacenan en el registro y se publican
				 * luego el sistema queda a la espera del SCLK
				 */
					  		shift_reg   <= i_data ;
								state       <= TRANSFERING;
								data_out    <= data_out;
							end
			 TRANSFERING : begin
			 /* espera a que pase el pulso de clock (flanco de bajada),
			  * entonces captura lo que el master envia y lo publica al modulo posterior
			  */
								 		if(((old_CLK) && ~i_SCLK)) begin // si hay un flanco descendente
												shift_reg   <= shift_reg;
												data_out    <= i_MOSI;
												state       <= FINISH; // termino la recepcion/transmision 						
											end
										else begin
											shift_reg   <= shift_reg;
											state       <= state;
											data_out    <= data_out;
										end
									end
				FINISH: begin
				/* Este estado esta reservado para realizar acciones con los datos capturados del master,
				 * como puede ser escribir en una memoria.
				 * el valor que sale por MISO no se ve modificado.
				 * luego de realizar todo vuelve al estado inicial para reiniciar la cominucacion.
				 */
								state <= IDLE;
								shift_reg   <= shift_reg;
								data_out    <= data_out;
								/*
								 * CODEAR ACA TODAS LAS ACCIONES NECESARIAS PARA 
								 * QUE EL MODULO SEA UTIL, EJ: ESCRIBIR LA MEMORIA
								 */
								end
								
				default: begin
									shift_reg 	<= shift_reg;
									state 			<= state;
									data_out    <= data_out;
							end
				endcase
		end
		else begin
									shift_reg 	<= shift_reg;
									state 			<= IDLE;
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
