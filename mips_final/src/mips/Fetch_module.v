`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

/// IOTINCHO
//`include "/home/tincho/../arq-comp/mips_final/include/include.v" //Comentar
`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Fetch_module #
  (
   parameter NB_BITS    = `NB_BITS,
   parameter NB_JMP     = `NB_JUMP,
   parameter RAM_DEPTH  = `RAM_FETCH_DEPTH,
   parameter FILE_DEPTH = 31,
   parameter INIT_FILE  = ""
   )
   (
    output [NB_BITS-1:0] o_if_id_pc,
    output [NB_BITS-1:0] o_if_id_instr,
    input [NB_BITS-1:0]  i_brq_addr,
    input [NB_BITS-1:0]  i_jmp_addr,
    input                i_ctr_beq,
    input                i_ctr_jmp,
    input                i_ctr_flush,
    input                i_pc_we,
    input                i_if_id_we,
    input                i_clk,
    input                i_rst
    );

   reg [NB_BITS-1:0]     if_id_pc;
   //reg [NB_BITS-1:0]     if_id_instr;
   reg [NB_BITS-1:0]     pc;

   //wire [NB_BITS-1:0]    data_mem;
   //wire [NB_BITS-1:0]    mux_beq, mux_jmp;
   //wire                  wea, ena;
   initial
     pc =  {NB_BITS{1'b0}};
   //Muxes
   //assign mux_beq = (i_ctr_beq)? i_brq_addr : pc + 4;
   //assign mux_jmp = (i_ctr_jmp)? {if_id_pc[NB_BITS-1:NB_JMP], i_jmp_addr} : mux_beq;

   //Outputs
   assign o_if_id_pc    = if_id_pc;
   //assign o_if_id_instr = data_mem;

   always @(posedge i_clk) begin
      if(i_rst) begin
         pc       <= {NB_BITS{1'b0}};
         if_id_pc <= {NB_BITS{1'b0}};
      end
      else begin
         case({i_pc_we, i_ctr_beq, i_ctr_jmp})
           3'b100:  pc <= pc + 4;
           3'b110:  pc <= i_brq_addr;
           3'b101:  pc <= i_jmp_addr;
           default: pc <= pc;
         endcase // case ({i_pc_we, i_ctr_beq, i_ctr_jmp})
         if_id_pc <= (i_if_id_we)? pc + 4: if_id_pc;
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   /*always @ (*) begin
      case({i_ctr_flush, i_if_id_we})
        2'b01:   if_id_instr = data_mem;
        2'b10:   if_id_instr = SSL;
        2'b11:   if_id_instr = SSL;
        default: if_id_instr = data_mem;
      endcase // case ({i_ctr_flush, i_if_id_we}
   end */

   Single_port_ram #
     (
      .RAM_WIDTH       (NB_BITS),        // Specify RAM data width
      .NB_DEPTH        (RAM_DEPTH),
      .FILE_DEPTH      (FILE_DEPTH),
      .SSL             (`NOP_OPERATION), // NOP operation sll $0 $0 0
      .INIT_FILE       (INIT_FILE)
      )
   inst_ram_instruction
     (
      .o_data      (o_if_id_instr),     // RAM output data,  RAM_WIDTH
      .i_addr      (pc[RAM_DEPTH+1:2]), // Address bus, width determined from RAM_DEPTH
      .i_data      (0),                 // RAM input data, width determined from RAM_WIDTH
      .i_clk       (i_clk),             // Clock
      .i_wea       (1'b0),              // Write enable
      //.i_ena     (i_if_id_we)         // RAM Enable
      .i_ctr_flush (i_ctr_flush),
      .i_if_id_we  (i_if_id_we)
      );
endmodule // Fetch_module

