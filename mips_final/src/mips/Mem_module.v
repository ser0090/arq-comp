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
   localparam NB_CTR  = `NB_CTR_MEM >> 1
   )
   (
    output [NB_BITS-1:0]    o_mem_data,
    output [NB_BITS-1:0]    o_alu_data,
    output [`NB_CTR_WB-1:0] o_wb_ctl,
    output [`NB_REG-1:0]    o_reg_dst,
    //output [`NB_REG-1:0]    o_reg_dst,
    // DEBUG singnal
    output [NB_BITS-1:0]    o_data_debug,

    input [NB_BITS-1:0]     i_addr,
    input [NB_BITS-1:0]     i_data,
    input [NB_CTR-1:0]      i_write_ctl,
    input [NB_CTR-1:0]      i_read_ctl,
    input [`NB_REG-1:0]     i_reg_dst,
    input [`NB_CTR_WB-1:0]  i_wb_ctl,
    input                   i_clk,
    input                   i_rst,
    // DEBUG signals
    input [NB_DEPTH-1:0]    i_addr_debug,
    input                   i_addr_sel,
    input                   i_debug,
    input                   i_step
    );

   localparam COL_WIDTH   = 8;
   localparam NB_COL      = 4;
   localparam NB_LATCH    = `NB_CTR_WB+NB_BITS+`NB_REG;

   //-- SECUENCIAL
   reg [NB_LATCH-1:0]       latched_out;
   reg                      step_prev;

   wire [NB_BITS-1:0]       mem_out;
   //-- OUTPUTS
   assign o_wb_ctl   = latched_out[`NB_CTR_WB-1:0];
   assign o_mem_data = mem_out; // latched_out[39:8];
   assign o_alu_data = latched_out[`NB_CTR_WB+NB_BITS-1:`NB_CTR_WB];
   assign o_reg_dst  = latched_out[`NB_CTR_WB+`NB_REG+NB_BITS+-1:`NB_CTR_WB+NB_BITS];

   always @(posedge i_clk) begin
      if (i_rst) begin
         latched_out <= {NB_LATCH{1'b0}};
         step_prev   <= 1'b0;
      end
      else begin
         if(i_debug) begin
            step_prev <= i_step;
            if(i_step && !step_prev) begin
               latched_out[`NB_CTR_WB-1:0]                                   <= i_wb_ctl;
               latched_out[`NB_CTR_WB+NB_BITS-1:`NB_CTR_WB]                  <= i_addr;
               latched_out[`NB_CTR_WB+`NB_REG+NB_BITS+-1:`NB_CTR_WB+NB_BITS] <= i_reg_dst;
            end
         end // if (i_debug)
         else begin
            //latched_out [39:8]  <= mem_out;
            latched_out[`NB_CTR_WB-1:0]                                   <= i_wb_ctl;
            // normalmente ingresa una addr de la alu pero puede ser un dat0
            latched_out[`NB_CTR_WB+NB_BITS-1:`NB_CTR_WB]                  <= i_addr;
            latched_out[`NB_CTR_WB+`NB_REG+NB_BITS+-1:`NB_CTR_WB+NB_BITS] <= i_reg_dst;
            //latched_out [79:77] <= 3'd0;
         end // else: !if(i_debug)
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
      .o_data_debug   (o_data_debug),
      .i_addr         ({2'b00, i_addr[9:2]}),
      .i_data         (i_data),
      .i_write_enable (i_write_ctl),
      .i_read_enable  (i_read_ctl),
      .i_clk          (i_clk),
      .i_addr_debug   (i_addr_debug),
      .i_debug_sel    (i_addr_sel),
      .i_ce_latch     ((i_debug)? (i_step && !step_prev) : 1'b1)
      );

endmodule // Mem_module
