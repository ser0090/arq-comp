`timescale 1ns/1ps

module WriteBack_module #
  (parameter NB_BITS = 32)
  (
    output [NB_BITS-1:0] o_data,

    input [NB_BITS-1:0]  i_mem_data,
    input [NB_BITS-1:0]  i_alu_data,
    input        i_mux_mem_to_reg
  );

  reg [NB_BITS-1:0] mux_out;
  assign o_data = mux_out;

  localparam DATA_FROM_MEM = 1'b0;
  localparam DATA_FROM_ALU = 1'b1;


  always @(*) begin
  	case(i_mux_mem_to_reg)
  		DATA_FROM_MEM: mux_out = i_mem_data;
  		DATA_FROM_ALU: mux_out = i_alu_data;
  	endcase
  end


  endmodule