`timescale 1ns/1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar


module Mem_module #
  (
   parameter NB_BITS  = 32,
   parameter NB_DEPTH = 10,
   localparam NB_CTR  = `NB_CTR_MEM >> 1 // div en 2
   )
   (
    output [NB_BITS-1:0]    o_mem_data,
    output [NB_BITS-1:0]    o_alu_data,
    output [`NB_CTR_WB-1:0] o_wb_ctl,
    output [`NB_REG-1:0]    o_reg_dst,
    //output [`NB_REG-1:0]    o_reg_dst,
    //##### DEBUG outpus singals #####
    output [NB_BITS-1:0]    o_to_SPI, // conectar spi

    input [NB_BITS-1:0]     i_addr,
    input [NB_BITS-1:0]     i_data,
    input [NB_CTR-1:0]      i_write_ctl,
    input [NB_CTR-1:0]      i_read_ctl,
    input [`NB_REG-1:0]     i_reg_dst,
    input [`NB_CTR_WB-1:0]  i_wb_ctl,
    input                   i_clk,
    input                   i_rst,
    //##### DEBUG input singals #####
    input [NB_BITS-1:0]     i_from_SPI, // conectar spi
    input                   i_debug_enb
    );

   localparam COL_WIDTH   = 8;
   localparam NB_COL      = 4;
   localparam NB_LATCH    = `NB_CTR_WB+NB_BITS+`NB_REG;

   /* ###### SECUENCIAL ###### */
   reg [NB_LATCH-1:0]       latched_out;

   wire [NB_BITS-1:0]       mem_out;

   /* ### cables para debug unit ### */

   wire [NB_DEPTH-1:0] debug_addr;
   wire [NB_BITS-1:0]  mem_to_debug;

   /* ###### OUTPUTS ###### */
   assign o_wb_ctl   = latched_out[`NB_CTR_WB-1:0];
   assign o_mem_data = mem_out; // latched_out[39:8];
   assign o_alu_data = latched_out[`NB_CTR_WB+NB_BITS-1:`NB_CTR_WB];
   assign o_reg_dst  = latched_out[`NB_CTR_WB+`NB_REG+NB_BITS+-1:`NB_CTR_WB+NB_BITS];

   always @(posedge i_clk) begin
      if (i_rst) begin
         latched_out <= {NB_LATCH{1'b0}};
      end
      else begin
         if(i_debug_enb) begin
            //latched_out [39:8]  <= mem_out;
            latched_out[`NB_CTR_WB-1:0]                  <= i_wb_ctl;
            // normalmente ingresa una addr de la alu pero puede ser un dat0
            latched_out[`NB_CTR_WB+NB_BITS-1:`NB_CTR_WB] <= i_addr;
            latched_out[NB_LATCH-1:`NB_CTR_WB+NB_BITS]   <= i_reg_dst;
            //latched_out [79:77] <= 3'd0;
         end
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   Data_Memory #
     (
      .NB_DEPTH       (NB_DEPTH),
      .NB_COL         (NB_COL),
      .COL_WIDTH      (COL_WIDTH)
      )
   inst_Data_Memory
     (
      .o_data         (mem_out),
      .o_data_debug   (mem_to_debug),  //conectar bus para sacar los datos, esperar un clico mas
      .i_addr         ({2'b00, i_addr[9:2]}),
      .i_data         (i_data),
      .i_write_enable (i_write_ctl),
      .i_read_enable  (i_read_ctl),
      .i_clk          (i_clk),
      .i_rst          (i_rst),
      .i_addr_debug   (debug_addr), //conectar cables de direccion de debug
      .i_debug_enb    (i_debug_enb)
      );
      SPI_Mem_Interface #(
      .NB_BITS(NB_BITS),
      .NB_LATCH(NB_LATCH+NB_BITS),
      .RAM_DEPTH(NB_DEPTH)
    ) inst_SPI_Mem_Interface (
      .o_SPI      (o_to_SPI),
      .o_addr     (debug_addr),
      .i_latch    ({latched_out,mem_out}),
      .i_mem_data (mem_to_debug),
      .i_SPI      (i_from_SPI)
    );

endmodule // Mem_module
