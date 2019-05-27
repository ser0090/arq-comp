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
    output [NB_BITS-1:0] o_if_id_pc,   // to decode and debug
    output [NB_BITS-1:0] o_if_id_instr,
    //##### debug output sig ######
    output [NB_BITS-1:0] o_to_SPI,  //TODO: conectar al SPI-salve

    input [NB_BITS-1:0]  i_brq_addr,
    input [NB_BITS-1:0]  i_jmp_addr,
    input                i_ctr_beq,
    input                i_ctr_jmp,
    input                i_ctr_flush,
    input                i_pc_we,
    input                i_if_id_we,
    input                i_clk,
    input                i_rst,
    //##### debug input singals #####
    input [NB_BITS-1:0]  i_from_SPI,
    input                i_debug_enb,     // debug enable activo por alto
    input                i_cs_debug    // chip sel para los mux modo debug
    );

   /* ###### SECUENCIAL ###### */
   reg [NB_BITS-1:0]     if_id_pc;
   reg [NB_BITS-1:0]     pc;

   //Outputs
   assign o_if_id_pc = if_id_pc;

   initial
     pc = {NB_BITS{1'b0}};

   always @(posedge i_clk) begin
      if(i_rst) begin
         pc        <= {NB_BITS{1'b0}};
         if_id_pc  <= {NB_BITS{1'b0}};
      end
      else if(i_debug_enb) begin
         case({i_pc_we, i_ctr_beq, i_ctr_jmp})
           3'b100:  pc <= pc + 4;
           3'b110:  pc <= i_brq_addr;
           3'b101:  pc <= i_jmp_addr;
           default: pc <= pc;
         endcase // case ({i_pc_we, i_ctr_beq, i_ctr_jmp})
         if_id_pc <= (i_if_id_we)? pc + 4: if_id_pc;
      end
   end // always @ (posedge i_clk)


   //wires para conectar la interfaz de SPI
   wire [RAM_DEPTH-1:0] addr;
   wire [NB_BITS-1:0]   data;
   //wire [NB_BITS-1:0]   to_SPI;
   wire                 wea;


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
      .i_addr      (pc[RAM_DEPTH-1+2:2]),   //conectar Address bus para debug
      .i_wr_addr   (addr),              //conectar Address del SPI interface
      .i_data      (data),              // RAM input data, width determined from RAM_WIDTH
      .i_wea       (wea),               //conectar Write enable desde modulo SPI-slave
      .i_ctr_flush (i_ctr_flush),
      .i_if_id_we  (i_if_id_we),
      .i_clk       (i_clk),             // Clock
      .i_rst       (i_rst),
      .i_regcea    (i_debug_enb)         // Latch out Enable
      );

      SPI_Fetch_Interface #(
      .NB_BITS(NB_BITS),
      .NB_LATCH(64),
      .RAM_DEPTH(RAM_DEPTH)
    ) inst_SPI_Fetch_Interface (
      .o_addr   (addr),
      .o_data   (data),
      .o_wea    (wea),
      .o_SPI    (o_to_SPI),
      .i_PC     (pc),
      .i_latch  ({o_if_id_instr,if_id_pc}),
      .i_SPI    (i_from_SPI),
      .i_in_use (i_cs_debug),
      .i_clk    (i_clk),
      .i_rst    (i_rst)
    );

endmodule // Fetch_module

