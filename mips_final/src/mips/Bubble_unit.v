`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

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
   output             o_bubble,

   input [NB_REG-1:0] i_if_rs, //
   input [NB_REG-1:0] i_if_rt, //
   input [NB_REG-1:0] i_idc_rd, // signal from ID/EXE latch
   input [NB_REG-1:0] i_exe_rd, // singals from EXE/MEM latch
   input [NB_REG-1:0] i_mem_rd, // singals from MEM/WB latch
   input              i_read_mem, // si es una instruccion de lectura de mem
   input              i_branch, // sin es una instruccion de salto taken
   input              i_jump,
   //input              i_write_fr
   input              i_idc_wfr,
   input              i_exe_wfr,
   input              i_mem_wfr  // TODO: revisar por si se puede ahorrar una burbuja
  );

   reg                if_id_we;
   reg                pc_we;
   reg                bubble;

   assign o_if_id_we = if_id_we;
   assign o_pc_we    = pc_we;
   assign o_bubble   = bubble;

   always @(*) begin
      //Hazard unit Bubble unit
      if(i_read_mem &&
        (i_if_rt == i_idc_rd || i_if_rs == i_idc_rd)) begin // load case
         if_id_we = 1'b0;
         pc_we    = 1'b0;
         bubble   = 1'b1;
      end
      else if(i_branch &&
              (((i_if_rs == i_idc_rd || i_if_rt == i_idc_rd) && i_idc_wfr) ||
               ((i_if_rs == i_exe_rd || i_if_rt == i_exe_rd) && i_exe_wfr) ||
               ((i_if_rs == i_mem_rd || i_if_rt == i_mem_rd) && i_mem_wfr)
               )) begin//branch case
         if_id_we = 1'b0;
         pc_we    = 1'b0;
         bubble   = 1'b1;
      end
      else if(i_jump &&
              ((i_if_rs == i_idc_rd && i_idc_wfr) ||
               (i_if_rs == i_exe_rd && i_exe_wfr) ||
               (i_if_rs == i_mem_rd && i_mem_wfr))
              ) begin//Jump case
         // write_fr && // JUMP
         //(i_idc_wfr || i_exe_wfr || i_mem_wfr) &&
         //(i_if_rs == i_idc_rd || i_if_rs == i_exe_rd || i_if_rs == i_mem_rd )) begin
         if_id_we = 1'b0;
         pc_we    = 1'b0;
         bubble   = 1'b1;
      end
      else begin
         if_id_we = 1'b1;
         pc_we    = 1'b1;
         bubble   = 1'b0;
      end // else: !if(!i_read_mem &&...
   end // always @ (*)
endmodule // Bubble_unit

