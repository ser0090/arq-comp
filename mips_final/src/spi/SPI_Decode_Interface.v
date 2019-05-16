
`timescale 1ns/1ps

module SPI_Decode_Interface#(
		parameter NB_BITS   = 32,
		parameter NB_LATCH  = 128,//pc_4+rs_reg+rt_reg+sign_ext
		parameter RAM_DEPTH = 10,
		parameter NB_REG    = 5
	) /* this is automatically generated */
	(
		output [NB_BITS-1:0]	 o_SPI,   //conectar al SPI_Slave data_in
		output [NB_REG-1:0]    o_rs,    //conectar al File_Register rs_input

		input  [NB_LATCH-1:0]  i_latch, //conectal latch (probablemente hay que concatenar regs)
		input  [NB_REG-1:0]     i_rs,     // conectar al rs (parte correspondiente de la instruccion)
		input  [NB_BITS-1:0]   i_reg_data,   //conectar al FileRegister rs_output
		input  [NB_BITS-1:0]   i_SPI,   //conectar al SPI_Slave data_out
		input  								 i_in_use // conectar al debug signal
	);

	reg [NB_BITS-1:0]   to_SPI;
	reg [NB_BITS-1:0]   to_SPI_aux;

	/* FORMATO DE LA PETICION 
	 * bits: accion
	 * 20-16 : selector de registros: 0 = la operacion corresponde 
	 *																	a una extraccion del latch 
	 *																	y no de registro
	 *															X = numero de registro
	 * 														  
	 * 22-21 : selector de palabra de latch: 00 = PC_4     / primera palabra del latch
	 *																		 01 = RS_REG   / segunda palabra del latch
	 *																		 10 = RT_REG   / tercera palabra del latch
	 *																		 11 = SIGN_EXT / segunda palabra del latch
	 *
	 */

  localparam  GET_PC_4     = 2'b00,
  						GET_RS_REG   = 2'b01,
  						GET_RT_REG   = 2'b10,
  						GET_SIGN_EXT = 2'b11;

	assign o_SPI  = (|i_SPI[20:16])? i_reg_data : to_SPI;

	assign o_rs = i_in_use? i_SPI[20:16] : i_rs;

	always @(*) begin
		case(i_SPI[22:21])
			GET_PC_4    : to_SPI = i_latch[NB_BITS-1:0]; //PC_4
			GET_RS_REG  : to_SPI = i_latch[2*NB_BITS-1:NB_BITS]; //rs
			GET_RT_REG  : to_SPI = i_latch[3*NB_BITS-1:2*NB_BITS]; // rt
			GET_SIGN_EXT: to_SPI = i_latch[4*NB_BITS-1:3*NB_BITS]; //sign_ext
		endcase
	end

endmodule