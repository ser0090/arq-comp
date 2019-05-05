`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar

module Bubble_unit#
  (
   parameter NB_REG    = `NB_REG,
   parameter NB_MUX_FW = `NB_MUX_FW
   )
  (
   output             o_if_id_we,
   output             o_pc_we,
   output             o_flush,

   input [NB_REG-1:0] i_if_id_rs, //
   input [NB_REG-1:0] i_if_id_rt, //
   input [NB_REG-1:0] i_id_ex_rt,
   input [NB_REG-1:0] i_id_ex_rd, //TODO: revisar
   input              i_id_ex_mem_rd, // si es una instruccion de lectura de mem
   input              i_id_branch
  );

   reg                if_id_we;
   reg                pc_we;
   reg                flush;

   assign o_if_id_we = if_id_we;
   assign o_pc_we    = pc_we;
   assign o_flush    = flush;

   always @(*) begin
      //Hazard unit Bubble unit
      if(i_id_ex_mem_rd && // load case
         (i_if_id_rt == i_id_ex_rt || i_if_id_rs == i_id_ex_rt)) begin
         if_id_we = 1'b0;
         pc_we    = 1'b0;
         flush    = 1'b1;
      end
      else if(i_id_branch &&  //brach case , TODO: revisar
              (i_if_id_rs == i_id_ex_rt || i_if_id_rs == i_id_ex_rd ||
               i_if_id_rt == i_id_ex_rt || i_if_id_rt == i_id_ex_rd)) begin
         if_id_we = 1'b0;
         pc_we    = 1'b0;
         flush    = 1'b1;
      end
      else begin
         if_id_we = 1'b1;
         pc_we    = 1'b1;
         flush    = 1'b0;
      end // else: !if(i_id_branch &&...
   end // always @ (*)
endmodule // Bubble_unit

