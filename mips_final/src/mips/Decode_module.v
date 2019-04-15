`timescale 1ns / 1ps

module Decode_module #
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_REG = 5
   )
   (
    output [NB_BITS-1:0] o_if_id_pc,
    output [NB_BITS-1:0] o_if_id_rs,
    output [NB_BITS-1:0] o_if_id_rt,
    output [NB_BITS-1:0] o_if_id_sgext,
    //output [NB_BITS-1:0] o_if_id_rs_num,
    output [NB_BITS-1:0] o_if_id_rt_num,
    output [NB_BITS-1:0] o_if_id_rd_num,
    output [6:0]         o_ctr_alu,
    //output [2:0]         o_ctr_mem,
    //output [1:0]         o_ctr_wrback,
    input [NB_BITS-1:0]  i_pc,
    input [NB_BITS-1:0]  i_instr,
    input [NB_BITS-1:0]  i_wb_data,
    input [NB_REG-1:0]   i_reg_dst,
    input                i_clk,
    input                i_rst
    );

   //#################################################################
   //#########################  OPS CODES  ###########################
   //##################################################################
   localparam J    = 6'b000010; // jump
   localparam JAL  = 6'b000011; //  jump and link
   localparam BEQ  = 6'b000100;
   localparam BEN  = 6'b000101;
   localparam ADDI = 6'b001000; //  add inmediate word
   localparam SLTI = 6'b001010; // 7 set on less than
   localparam ANDI = 6'b001100;
   localparam ORI  = 6'b001101;
   localparam XORI = 6'b001110;
   localparam LUI  = 6'b001111;

   localparam LB   = 6'b100000;
   localparam LH   = 6'b100001;
   localparam LBU  = 6'b100100;
   localparam LHU  = 6'b100101;
   localparam LWU  = 6'b100111;
   localparam SB   = 6'b101000;
   localparam SH   = 6'b101001;
   localparam SW   = 6'b101011;

   localparam SPECIAL = 6'd0;

   reg [NB_BITS-1:0]     pc;
   reg [NB_BITS-1:0]     rs;
   reg [NB_BITS-1:0]     rt;
   reg [NB_BITS-1:0]     sg_ext;
   reg [NB_REG-1:0]      rt_num;
   reg [NB_REG-1:0]      rd_num;
   reg [3:0]             alu_op;
   reg [2:0]             rs_mux;
   reg                   rt_mux;

   
endmodule // Alu
