`timescale 1ns / 1ps
///  SER0090
`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar
module Instr_memory_latch #
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_DATA = 16,
   parameter NB_ADDR = 10
   )
   (
    output [NB_BITS-1:0] o_data, /* N bits more carry */
    output [NB_BITS-1:0] o_memdata,
    output [NB_ADDR-1:0] o_addr,
    output               o_wenb,
    input [NB_BITS-1:0]  i_inst,
    input [NB_BITS-1:0]  i_pc,
    input [NB_BITS-1:0]  i_pc_lt,
    input [NB_BITS-1:0]  i_instr_lt,
    input                i_valid,
    input                i_clk,
    input                i_rst
    );

   localparam ADDR    = 16'd1;
   localparam LDATA   = 16'd2;
   localparam HDATA   = 16'd3;
   localparam PC      = 16'd4;
   localparam PC_LT   = 16'd5;
   localparam INST_LT = 16'd6;

   /* ##### SECUENCIAL ###### */
   reg [NB_BITS-1:0]     instruction;
   reg [NB_BITS-1:0]     deb_data;
   reg [NB_BITS-1:0]     mdata;
   reg [NB_ADDR-1:0]     addr;
   reg                   valid_prev;
   reg                   wenb;

   assign o_data    = deb_data;
   assign o_memdata = mdata;
   assign o_addr    = addr;
   assign o_wenb    = wenb;
   
   always @ ( posedge i_clk ) begin
      if(i_rst) begin
         instruction <= {NB_BITS{1'b0}};
         deb_data    <= {NB_BITS{1'b0}};
         mdata       <= {NB_BITS{1'b0}};
         addr        <= {NB_ADDR{1'b0}};
         valid_prev  <= 1'b0;
         wenb        <= 1'b0;
      end
      else begin
         valid_prev  <= i_valid;
         // latch por flanco ascendente
         instruction <= (i_valid && !valid_prev)? i_inst : instruction;
         case(instruction[NB_BITS-1:NB_DATA])
           ADDR: begin
              addr                     <= instruction[NB_ADDR-1:0];
              deb_data                 <= 0;
              wenb                     <= 1'b0;
           end
           LDATA: begin
              mdata[NB_DATA-1:0]       <= instruction[NB_DATA-1:0];
              deb_data                 <= 0;
              wenb                     <= 1'b0;
           end
           HDATA: begin
              mdata[NB_BITS-1:NB_DATA] <= instruction[NB_DATA-1:0];
              deb_data                 <= 0;
              wenb                     <= 1'b1;
           end
           PC:begin
              deb_data                 <= i_pc;
              wenb                     <= 1'b0;
           end
           PC_LT: begin
              deb_data                 <= i_pc_lt;
              wenb                     <= 1'b0;
           end
           INST_LT: begin
              deb_data                 <= i_instr_lt;
              wenb                     <= 1'b0;
           end
           default: begin
              deb_data                 <= 0;
              mdata                    <= 0;
              addr                     <= 0;
              wenb                     <= 1'b0;
           end
         endcase; // case (instruction)
      end // else: !if(i_rst)
   end // always @ ( posedge i_clk )
endmodule // Instr_memory_latch


