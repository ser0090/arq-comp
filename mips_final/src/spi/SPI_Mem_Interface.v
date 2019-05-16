
`timescale 1ns/1ps

module SPI_Mem_Interface#(
		parameter NB_BITS   = 32,
		parameter NB_LATCH  = 72,//`NB_CTR_WB+NB_BITS+`NB_REG
		parameter RAM_DEPTH = 10
	) /* this is automatically generated */
	(
		output reg [NB_BITS-1:0] o_SPI,   //conectar al SPI_Slave data_in
		output [RAM_DEPTH-1:0]	 o_addr,  //conectar al DataMem addr_in_2

		input  [NB_LATCH-1:0]  i_latch, //conectal latch (probablemente hay que concatenar regs)
		input  [NB_BITS-1:0]   i_mem_data,
		input  [NB_BITS-1:0]   i_SPI   //conectar al SPI_Slave data_out
	);

	/* FORMATO DE PETICION
	 * bits:
	 * 15-0 : direccion de memoria
	 * 17-16: 00 = memory_out
	 *        01 = latch word_0 / mem_latched
	 *        10 = latch word_1 / 
	 *        11 = latch word_2 / 
	 *
	 *
	 */
	assign o_addr = i_SPI[RAM_DEPTH-1:0];

	always @(*) begin
		case(i_SPI[17:16])
			2'b00: o_SPI = i_mem_data;
			2'b01: o_SPI = i_latch[1*NB_BITS-1:0];
			2'b10: o_SPI = i_latch[2*NB_BITS-1:1*NB_BITS];
			2'b11: o_SPI = {{3*NB_BITS-NB_LATCH{1'b0}},i_latch[NB_LATCH-1:2*NB_BITS]};
		endcase
	end





endmodule