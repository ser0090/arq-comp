`timescale 1ns / 1ps

module Alu #
  (
   parameter NB_BITS = 8, /* asigancion de parametro local */
   parameter NB_OPE = 6
   )
   (
    output [NB_BITS-1:0] o_led, /* N bits more carry */
    input [NB_BITS-1:0]  i_dato_a,
    input [NB_BITS-1:0]  i_dato_b,
    input [NB_OPE-1:0]   i_ope_sel
    );

   reg [NB_BITS-1:0]     out_alu;
   
   assign o_led = out_alu;
   /* Alternativa dentro del assign
    * {{NB_BITS{i_dato_a[NB_BITS-1]}},i_dato_a[NB_BITS-1:0]} >> i_dato_b */
   /* always (*) se interpreta como combinacional
    * asignacion de la salida sintax switch case = MUX */
    always @(*) begin
       case (i_ope_sel)
         6'b100000: out_alu = $signed(i_dato_a) + $signed(i_dato_b); /* ADD */
         6'b100010: out_alu = $signed(i_dato_a) - $signed(i_dato_b); /* SUB */
         6'b100100: out_alu = i_dato_a & i_dato_b; /* AND */
         6'b100101: out_alu = i_dato_a | i_dato_b; /* OR */
         6'b100110: out_alu = i_dato_a ^ i_dato_b; /* XOR */
         6'b100111: out_alu = ~(i_dato_a | i_dato_b); /* NOR */
         6'b000010: out_alu = i_dato_a >> i_dato_b; /* SRL */
         6'b000011: out_alu = $signed(i_dato_a) >>> i_dato_b; /* SRA */
         default: out_alu = 8'h00; /* default */
       endcase // case (i_ope_sel)
    end
endmodule
