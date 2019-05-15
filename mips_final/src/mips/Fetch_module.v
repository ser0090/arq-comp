`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

/// IOTINCHO
//`include "/home/tincho/../arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Fetch_module #
  (
   parameter NB_BITS    = `NB_BITS,
   parameter NB_JMP     = `NB_JUMP,
   parameter RAM_DEPTH  = `RAM_FETCH_DEPTH,
   parameter FILE_DEPTH = 31,
   parameter INIT_FILE  = ""
   )
   (
    output [NB_BITS-1:0] o_if_id_pc, // to decode and debug
    output [NB_BITS-1:0] o_if_id_instr,
    // debug output sig
    output [NB_BITS-1:0] o_pc_debug,

    input [NB_BITS-1:0]  i_brq_addr,
    input [NB_BITS-1:0]  i_jmp_addr,
    // debug input singals
    //input [NB_BITS-1:0]  i_addr_debug, TODO: ver el tema de la direccion_pc
    input [NB_BITS-1:0]  i_data_debug,
    input                i_wren_debug,
    input                i_debug, // debug signals
    input                i_step, // step by step
    // fetch singals
    input                i_ctr_beq,
    input                i_ctr_jmp,
    input                i_ctr_flush,
    input                i_pc_we,
    input                i_if_id_we,
    input                i_clk,
    input                i_rst
    );

   reg [NB_BITS-1:0]     if_id_pc;
   reg [NB_BITS-1:0]     pc;
   reg                   step_prev;

   //Outputs
   assign o_if_id_pc = if_id_pc;
   assign o_pc_debug = pc;

   initial
     pc =  {NB_BITS{1'b0}};

   always @(posedge i_clk) begin
      if(i_rst) begin
         pc        <= {NB_BITS{1'b0}};
         if_id_pc  <= {NB_BITS{1'b0}};
         step_prev <= 1'b0;
      end
      else begin
         if(i_debug) begin
            step_prev <= i_step;
            if (i_step && !step_prev) begin // flaco ascendente
               case({i_pc_we, i_ctr_beq, i_ctr_jmp})
                 3'b100:  pc <= pc + 4;
                 3'b110:  pc <= i_brq_addr;
                 3'b101:  pc <= i_jmp_addr;
                 default: pc <= pc;
               endcase // case ({i_pc_we, i_ctr_beq, i_ctr_jmp})
               if_id_pc <= (i_if_id_we)? pc + 4: if_id_pc;
            end
         end // if (i_debug)
         else begin
            case({i_pc_we, i_ctr_beq, i_ctr_jmp})
              3'b100:  pc <= pc + 4;
              3'b110:  pc <= i_brq_addr;
              3'b101:  pc <= i_jmp_addr;
              default: pc <= pc;
            endcase // case ({i_pc_we, i_ctr_beq, i_ctr_jmp})
            if_id_pc <= (i_if_id_we)? pc + 4: if_id_pc;
         end // else: !if(i_debug)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

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
      .o_data      (o_if_id_instr),               // RAM output data,  RAM_WIDTH
      .i_addr      (pc[RAM_DEPTH+1:2]),           // Address bus, width determined from RAM_DEPTH
      .i_data      (i_data_debug),                // RAM input data, width determined from RAM_WIDTH
      .i_clk       (i_clk),                       // Clock
      .i_wea       ((i_debug)?i_wren_debug:1'b0), // Write enable
       //.i_ena     (i_if_id_we) // RAM Enable
      .i_ctr_flush (i_ctr_flush),
      .i_if_id_we  (i_if_id_we)
      );
endmodule // Fetch_module

