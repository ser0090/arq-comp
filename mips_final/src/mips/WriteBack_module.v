`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar
///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar

module WriteBack_module #
  (
   parameter NB_BITS    = 32,
   localparam FROM_MEM  = `DATA_FROM_MEM,
   localparam FROM_ALU  = `DATA_FROM_ALU,
   localparam SIGN_BYTE = `DATA_SIGN_BYT,
   localparam SIGN_HALF = `DATA_SIGN_HAL
   )
   (
    output [NB_BITS-1:0] o_data,
    input [NB_BITS-1:0]  i_mem_data,
    input [NB_BITS-1:0]  i_alu_data,
    input [1:0]          i_mux_mem_to_reg
    );

   localparam BYTE = 8;
   localparam HALF = 16;

   reg [NB_BITS-1:0] mux_out;

   assign o_data = mux_out;

   always @(*) begin
  	  case(i_mux_mem_to_reg)
  		  FROM_MEM:  mux_out = i_mem_data;
  		  FROM_ALU:  mux_out = i_alu_data;
  		  SIGN_BYTE: mux_out = {{NB_BITS-BYTE+1{i_mem_data[BYTE-1]}},i_mem_data[BYTE-2:0]};
  		  SIGN_HALF: mux_out = {{NB_BITS-HALF+1{i_mem_data[HALF-1]}},i_mem_data[HALF-2:0]};
  	  endcase // case (i_mux_mem_to_reg)
   end
endmodule // WriteBack_module
