`timescale 1ns / 1ps

/* definicion de parametros globales */
`define NB_BITS 8
`define NB_OPE 6

module Alu #(
             parameter NB_BITS = `NB_BITS, /* asigancion de parametro local */
             parameter NB_OPE = `NB_OPE
             )(
               output [NB_BITS:0]  o_led, /* N bits more carry */
               input [NB_BITS-1:0] i_dato_a,
               input [NB_BITS-1:0] i_dato_b,
               input [NB_OPE-1:0]  i_ope_sel
               );
   
   /* asignacion de la salida sintax switch case = MUX */
   assign o_led = (i_ope_sel == 6'b100000)? i_dato_a + i_dato_b: /* ADD */
                  (i_ope_sel == 6'b100010)? i_dato_a - i_dato_b: /* SUB */
                  (i_ope_sel == 6'b100100)? i_dato_a & i_dato_b: /* AND */
                  (i_ope_sel == 6'b100101)? i_dato_a | i_dato_b: /* OR */
                  (i_ope_sel == 6'b100110)? i_dato_a ^ i_dato_b: /* XOR */
                  (i_ope_sel == 6'b100111)? ~(i_dato_a | i_dato_b): /* NOR */
                  (i_ope_sel == 6'b000010)? i_dato_a >> i_dato_b: /* SRL */
                  (i_ope_sel == 6'b000011)? {{NB_BITS{i_dato_a[NB_BITS-1]}},
                                             i_dato_a[NB_BITS-1:0]} >> i_dato_b: /* SRA */
                  8'h00; /* default */
   /*
    reg [8:0] sra
    always @(*) begin
    sra = $signed(i_dato_a) >>> i_dato_b;
   end */
endmodule
