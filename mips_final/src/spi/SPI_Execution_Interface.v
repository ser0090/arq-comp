
`timescale 1ns/1ps

module SPI_Execution_Interface#(
		parameter NB_BITS   = 32,
		parameter NB_LATCH  = 96//2*NB_BITS+NB_REG+NB_MEM+NB_WB
	) /* this is automatically generated */
	(
		output [NB_BITS-1:0]	 o_SPI,   //conectar al SPI_Slave data_in

		input  [NB_LATCH-1:0]  i_latch, //conectal latch (probablemente hay que concatenar regs)
		input  [NB_BITS-1:0]   i_SPI   //conectar al SPI_Slave data_out
	);

	/*FORMATO DE PETICION
	 * bits: 17-16: indica la palabra (en orden) 
	 *						del latch que quiero extraer.
	 */
	 reg [NB_BITS-1:0] to_SPI;
	 assign o_SPI = to_SPI;

	 always @(*) begin
	 	case(i_SPI[17:16])
	 		2'b00  : to_SPI = i_latch[1*NB_BITS-1:0*NB_BITS];//word 0
	 		2'b01  : to_SPI = i_latch[2*NB_BITS-1:1*NB_BITS];//word 1		
	 		2'b10  : to_SPI = {{3*NB_BITS-NB_LATCH{1'b0}},i_latch[NB_LATCH-1:2*NB_BITS]};//word 2		
	 		default: to_SPI = {NB_BITS{1'b0}};				
	 	endcase
	 end


endmodule