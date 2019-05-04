`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar

module Forwarding_Unit#
  (
   parameter NB_REG    = `NB_REG,
   parameter NB_MUX_FW = `NB_MUX_FW
   )
  (
   output [NB_MUX_FW-1:0] o_mux_a_hz,
   output [NB_MUX_FW-1:0] o_mux_b_hz,

   input [NB_REG-1:0]     i_ex_mem_rd,
   input [NB_REG-1:0]     i_mem_wb_rd,
   input [NB_REG-1:0]     i_id_ex_rs,
   input [NB_REG-1:0]     i_id_ex_rt,
   input                  i_ex_mem_wr_en,
   input                  i_mem_wb_wr_en
  );

   /*parametros definiedos tambine en Execurtion module */
   localparam FROM_ID_EX  = 2'b00;
   localparam FROM_EX_MEM = 2'b01;
   localparam FROM_MEM_WB = 2'b10;

   reg [1:0]          mux_a;
   reg [1:0]          mux_b;

   assign o_mux_a_hz = mux_a;
   assign o_mux_b_hz = mux_b;

   always @(*) begin
      //forward RS
      if(i_ex_mem_wr_en &&
         i_ex_mem_rd != 0 &&
         i_ex_mem_rd == i_id_ex_rs) mux_a = FROM_EX_MEM;

      else if(i_mem_wb_wr_en &&
              i_mem_wb_rd != 0 &&
              i_ex_mem_rd == i_id_ex_rs) mux_a =FROM_MEM_WB;
      else
        mux_a = FROM_ID_EX;

      //forward RT
      if(i_ex_mem_wr_en &&
         i_ex_mem_rd != 0 &&
         i_ex_mem_rd == i_id_ex_rt) mux_b = FROM_EX_MEM;

      else if(i_mem_wb_wr_en &&
              i_mem_wb_rd != 0 &&
              i_ex_mem_rd == i_id_ex_rt) mux_b =FROM_MEM_WB;
      else
         mux_b = FROM_ID_EX;
   end //always
endmodule // Forwarding_Unit
