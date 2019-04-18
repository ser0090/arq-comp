`timescale 1ns / 1ps

module Alu #
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_OPE = 5
   )
   (
    output [NB_BITS-1:0] o_alu, /* N bits more carry */
    output               o_zero,
    input [NB_BITS-1:0]  i_data_a,
    input [NB_BITS-1:0]  i_data_b,
    input [NB_OPE-1:0]   i_ope_sel
    );
   
   localparam SLL = 5'b01000; // 8 shift lefth logical
   localparam SRL = 5'b01001; // 9 shift rigth logical
   localparam SRA = 5'b01010; // 10 shift right arithmetic
   localparam ADD = 5'b00010; // 2 add unsigned word
   localparam SUB = 5'b00110; // 6 subtract unsigned word
   localparam AND = 5'b00000; // 0
   localparam OR  = 5'b00001; // 1
   localparam XOR = 5'b00011; // 3
   localparam NOR = 5'b01100; // 12
   localparam SLT = 5'b00111; // 7 set on less than
   localparam JAL = 5'b01101; // 13 jump and link
   localparam LUI = 5'b01110; // 14 
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
         ADD: alu = $unsigned(i_data_a) + $unsigned(i_data_b);
         SUB: alu = i_data_a - $signed(i_data_b);
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

