`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar

module WriteBack_module #
  (parameter NB_BITS = 32,
  localparam DATA_FROM_MEM = `DATA_FROM_MEM,
  localparam DATA_FROM_ALU = `DATA_FROM_ALU
  )
  (
    output [NB_BITS-1:0] o_data,

    input [NB_BITS-1:0]  i_mem_data,
    input [NB_BITS-1:0]  i_alu_data,
    input        i_mux_mem_to_reg
  );

  reg [NB_BITS-1:0] mux_out;
  assign o_data = mux_out;



  always @(*) begin
  	case(i_mux_mem_to_reg)
  		DATA_FROM_MEM: mux_out = i_mem_data;
  		DATA_FROM_ALU: mux_out = i_alu_data;
  	endcase
  end


  endmodule