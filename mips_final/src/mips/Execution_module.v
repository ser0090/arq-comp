`timescale 1ns / 1ps

module Execution_module#
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_ALU_OP_CTL = 4,
   parameter NB_FUNCTION = 6
   )
   (
    output [NB_BITS-1:0] o_alu_out,
    output [NB_BITS-1:0] o_data_reg,
    output [4:0]         o_reg_dst,
    output [7:0]         o_wb_ctl,
    output [7:0]         o_mem_ctl,
    
    //desde hz unit
    input [1:0]          i_mux_a_hz,
    input [1:0]          i_mux_b_hz,
    input [NB_BITS-1:0]  i_ex_mem_reg_hz,
    input [NB_BITS-1:0]  i_mem_wb_reg_hz,
    //desde ctl
    input [NB_ALU_OP_CTL-1:0]          i_alu_op_ctl,
    input [1:0]          i_mux_rs_ctl,
    input                i_mux_rt_ctl,
    input                i_mux_dest_ctl,
    //desde ID/EX
    input [4:0]          i_rt, // lo q esta en la instruccion
    input [4:0]          i_rd,
    input [NB_BITS-1:0]  i_sign_ext,
    input [NB_BITS-1:0]  i_rt_reg, //dato
    input [NB_BITS-1:0]  i_rs_reg, // dato
    input [NB_BITS-1:0]  i_pc_4,
    input [NB_FUNCTION-1:0] i_function,
    input [7:0]             i_wb_ctl, // estas son las señales de control
    input [7:0]             i_mem_ctl,// que pasa para la proxima etapa
    
    input                   i_clk,
    input                   i_rst

    );

   localparam NB_OPE = 5;

   localparam PC_TO_A     = 2'b00;
   localparam EX_MEM_TO_A = 2'b01;
   localparam MEM_WB_TO_A = 2'b10;

   localparam RT_TO_B     = 1'b0;
   localparam SEXT_TO_B   = 1'b1;

   localparam FROM_ID_EX  = 2'b00;
   localparam FROM_EX_MEM = 2'b01;
   localparam FROM_MEM_WB = 2'b10;


   wire operation;
   wire alu_out;
   wire alu_zero;
   reg [NB_BITS-1:0] dato_a;
   reg [NB_BITS-1:0] dato_b;
   reg [NB_BITS-1:0] dato_aux_a;
   reg [NB_BITS-1:0] dato_aux_b;
   reg [4:0]         reg_dst;
   reg [95:0]        EX_MEM;

   assign o_wb_ctl   = EX_MEM[7:0]  ; 
   assign o_mem_ctl  = EX_MEM[15:8] ;
   assign o_alu_out  = EX_MEM[47:16]; 
   assign o_data_reg = EX_MEM[79:48]; 
   assign o_reg_dst  = EX_MEM[84:80];


   always @(posedge i_clk or posedge i_rst) begin
     if (i_rst) begin
       EX_MEM[95:0]  <= 96'd0;       
     end
     else begin
       EX_MEM[7:0]   <= i_wb_ctl;
       EX_MEM[15:8]  <= i_mem_ctl;
       EX_MEM[47:16] <= alu_out;
       EX_MEM[79:48] <= i_rt_reg;
       EX_MEM[84:80] <= reg_dst;
       EX_MEM[95:85] <= 11'd0;
     end
   end

   always @(*) begin
     /* selector de la fuente del primet argumento de 
      * la alu
      */
     case (i_mux_rs_ctl)
        PC_TO_A :     dato_aux_a = i_pc_4;
        EX_MEM_TO_A : dato_aux_a = i_rs_reg;
        MEM_WB_TO_A : dato_aux_a = i_sign_ext;
        default :     dato_aux_a = 0;
      endcase
      /* selector de la fuente del segundo argumento 
       * de la alu
       */
      case(i_mux_rt_ctl)
        RT_TO_B  : dato_aux_b = i_rt_reg;
        SEXT_TO_B: dato_aux_b = i_sign_ext;
       // default  : dato_aux_b = 0;
      endcase

      /* selector para incorporar el hazzard unit
       */
      case(i_mux_a_hz)
        FROM_ID_EX : dato_a = dato_aux_a;  
        FROM_EX_MEM: dato_a = i_ex_mem_reg_hz;
        FROM_MEM_WB: dato_a = i_mem_wb_reg_hz;
        default    : dato_a = dato_aux_a;
      endcase

      /* selector para incorporar el hazzard unit
       */
      case(i_mux_b_hz)
        FROM_ID_EX : dato_b = dato_aux_b;  
        FROM_EX_MEM: dato_b = i_ex_mem_reg_hz;
        FROM_MEM_WB: dato_b = i_mem_wb_reg_hz;
        default    : dato_b = dato_aux_b;
      endcase

      /* selector del registro de destino, 
       * depende si esta codificado en rt o rd
       */
      case(i_mux_dest_ctl)
        1'b0: reg_dst =  i_rd;
        1'b1: reg_dst = i_rt;
      endcase
   end


  Alu #(
      .NB_BITS(NB_BITS),
      .NB_OPE(NB_OPE)
    ) inst_Alu (
      .o_alu     (alu_out),
      .o_zero    (alu_zero),
      .i_data_a  (dato_a),
      .i_data_b  (dato_b),
      .i_ope_sel (operation)
    );
  Alu_Control #(
      .NB_OPE(NB_OPE),
      .NB_ALU_OP_CTL(NB_ALU_OP_CTL),
      .NB_FUNCTION(NB_FUNCTION)
    ) inst_Alu_Control (
      .o_alu        (operation),
      .i_alu_op_ctl (i_alu_op_ctl),
      .i_function   (i_function)
    );

   endmodule