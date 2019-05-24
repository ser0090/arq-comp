
`timescale 1ns/1ps

module SPI_Execution_Interface#(
		parameter NB_BITS   = 32,
		parameter NB_LATCH  = 96//2*NB_BITS+NB_REG+`NB_CTR_WB+`NB_CTR_MEM
	) /* this is automatically generated */
	(
		output [NB_BITS-1:0]	 o_SPI,   //conectar al SPI_Slave data_in

		input  [NB_LATCH-1:0]  i_latch, //conectal latch (probablemente hay que concatenar regs)
		input  [NB_BITS-1:0]   i_SPI   //conectar al SPI_Slave data_out
	);

	/*FORMATO DE PETICION
	 * bits: 17-16: 00 = alu_out
	 *              01 = rt_reg
	 *              10 = rd
	 */

	 localparam GET_ALU    = 2'b00;
	 localparam GET_RT_REG = 2'b01;
	 localparam GET_RD     = 2'b10;

	 reg [NB_BITS-1:0] to_SPI;
	 assign o_SPI = to_SPI;

	 always @(*) begin
	 	case(i_SPI[17:16])
	 		GET_ALU    : to_SPI = i_latch[`NB_CTR_WB+`NB_CTR_MEM+NB_BITS-1:`NB_CTR_WB+`NB_CTR_MEM];
	 		GET_RT_REG : to_SPI = i_latch[2*NB_BITS+`NB_CTR_WB+`NB_CTR_MEM-1:`NB_CTR_WB+`NB_CTR_MEM+NB_BITS];		
	 		GET_RD     : to_SPI = {{NB_BITS-NB_LATCH-1-2*NB_BITS+`NB_CTR_WB+`NB_CTR_MEM{1'b0}},i_latch[NB_LATCH-1:2*NB_BITS+`NB_CTR_WB+`NB_CTR_MEM]};
	 		default: to_SPI = {NB_BITS{1'b0}};				
	 	endcase
	 end


endmodule