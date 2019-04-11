`timescale 1ns / 1ps

module Alu #
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_OPE = 4
   )
   (
    output [NB_BITS-1:0] o_alu, /* N bits more carry */
    output               o_zero,
    input [NB_BITS-1:0]  i_data_a,
    input [NB_BITS-1:0]  i_data_b,
    input [NB_OPE-1:0]   i_ope_sel
    );
   
   localparam SLL = 4'b1000; // 8 shift lefth logical
   localparam SRL = 4'b1001; // 9 shift rigth logical
   localparam SRA = 4'b1010; // 10 shift right arithmetic
   localparam ADD = 4'b0010; // 2 add unsigned word
   localparam SUB = 4'b0110; // 6 subtract unsigned word
   localparam AND = 4'b0000; // 0
   localparam OR  = 4'b0001; // 1
   localparam XOR = 4'b0011; // 3
   localparam NOR = 4'b1100; // 12
   localparam SLT = 4'b0111; // 7 set on less than
   localparam JAL = 4'b1101; // 13 jump and link
   localparam LUI = 4'b1110; // 14 
   //localparam JARL = 4'b1110; // jump and link register
   
   reg [NB_BITS-1:0] alu;
   
   assign o_alu = alu;
   assign o_zero = ~|alu; //NOR del resultado
   
   /* always (*) se interpreta como combinacional
    * asignacion de la salida sintax switch case = MUX */
    always @(*) begin
       case (i_ope_sel)
         SLL: alu = i_data_b << i_data_a[4:0]; // falta sign extnd
         SRL: alu = i_data_b >> i_data_a[4:0]; // falta sign extnd
         SRA: alu = $signed(i_data_b) >>> i_data_a[4:0]; // falta sign extnd
         ADD: alu = i_data_a + i_data_b;
         SUB: alu = i_data_a - i_data_b;
         AND: alu = i_data_a & i_data_b;
         OR : alu = i_data_a | i_data_b;
         XOR: alu = i_data_a ^ i_data_b;
         NOR: alu = ~(i_data_a | i_data_b);
         SLT: alu = (i_data_a < i_data_b)? 1 : 0;
         JAL: alu = i_data_a + 4;         // PC + 8
         LUI: alu = i_data_b << 5'd16;     // immediate || 0_16
         default: alu = 0; /* default */
       endcase // case (i_ope_sel)
    end // always @ (*)
endmodule // Alu

