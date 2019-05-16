`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Execution_module#
  (
   parameter NB_BITS         = 32, /* asigancion de parametro local */
   parameter NB_ALU_OP_CTL   = 4,
   parameter NB_FUNCTION     = 6,

   localparam NB_OPE         = 5,
   localparam NB_REG         = `NB_REG,
   localparam PC_TO_A        = `PC_TO_A    ,
   localparam RS_TO_A        = `RS_TO_A    ,
   localparam SEXT_TO_A      = `SEXT_TO_A  ,

   localparam RT_TO_B        = `RT_TO_B  ,
   localparam SEXT_TO_B      = `SEXT_TO_B,

   localparam FROM_ID_EX     = `FROM_ID_EX ,
   localparam FROM_EX_MEM    = `FROM_EX_MEM,
   localparam FROM_MEM_WB    = `FROM_MEM_WB,

   localparam DEST_FROM_RD   = `DEST_FROM_RD  ,
   localparam DEST_FROM_RT   = `DEST_FROM_RT  ,
   localparam DEST_TO_RETURN = `DEST_TO_RETURN,

   localparam NB_WB          = `NB_CTR_WB,
   localparam NB_MEM         = `NB_CTR_MEM
   )
   (
    output [NB_BITS-1:0]      o_alu_out,
    output [NB_BITS-1:0]      o_data_reg,
    output [NB_REG-1:0]       o_reg_dst,
    output [NB_REG-1:0]       o_num_rd, // singal for bubble Unit
    output [NB_WB-1:0]        o_wb_ctl,
    output [NB_MEM-1:0]       o_mem_ctl,
    //##### debug output singals #####
    //output [NB_BITS-1:0] o_data_debug, // TODO: conectar al SPI

    //desde hz unit
    input [1:0]               i_mux_a_hz,
    input [1:0]               i_mux_b_hz,
    input [NB_BITS-1:0]       i_ex_mem_reg_hz,
    input [NB_BITS-1:0]       i_mem_wb_reg_hz,
    //desde ctl
    input [NB_ALU_OP_CTL-1:0] i_alu_op_ctl,
    input [1:0]               i_mux_rs_ctl,
    input                     i_mux_rt_ctl,
    input [1:0]               i_mux_dest_ctl,
    //desde ID/EX
    input [4:0]               i_rt,      // lo q esta en la instruccion
    input [4:0]               i_rd,
    input [NB_BITS-1:0]       i_sign_ext,
    input [NB_BITS-1:0]       i_rt_reg,  //dato
    input [NB_BITS-1:0]       i_rs_reg,  // dato
    input [NB_BITS-1:0]       i_pc_4,
    input [NB_FUNCTION-1:0]   i_function,
    input [NB_WB-1:0]         i_wb_ctl,  // estas son las señales de control
    input [NB_MEM-1:0]        i_mem_ctl, // que pasa para la proxima etapa

    input                     i_clk,
    input                     i_rst,
    //##### debug input singals #####
    //input [NB_BITS-1:0]  i_data_debug, TODO: conectar al SPI-salve
    input                     i_debug_enb
    );

   localparam NB_LATCH = 2*NB_BITS+NB_REG+NB_MEM+NB_WB;

   wire [4:0]                 operation;
   wire [NB_BITS-1:0]         alu_out;
   //wire alu_zero;
   /* ##### COMBINACIONAL ###### */
   reg [NB_BITS-1:0]          dato_a;
   reg [NB_BITS-1:0]          dato_b;
   reg [NB_BITS-1:0]          dato_aux_a;
   reg [NB_BITS-1:0]          dato_aux_b;
   reg [4:0]                  reg_dst;
   /* ##### SECUENCIAL ###### */
   reg [NB_LATCH-1:0]         EX_MEM;

   assign o_wb_ctl   = EX_MEM[NB_WB-1:0]  ;
   assign o_mem_ctl  = EX_MEM[NB_MEM+NB_WB-1:NB_WB];
   assign o_alu_out  = EX_MEM[NB_MEM+NB_WB+NB_BITS-1:NB_MEM+NB_WB];
   assign o_data_reg = EX_MEM[2*NB_BITS+NB_MEM+NB_WB-1:NB_MEM+NB_WB+NB_BITS];
   assign o_reg_dst  = EX_MEM[NB_LATCH-1:2*NB_BITS+NB_MEM+NB_WB];
   /*--- bubble signal rd ---*/
   assign o_num_rd   = reg_dst;

   always @(posedge i_clk) begin
      if (i_rst) begin
         EX_MEM[NB_LATCH-1:0]  <= {NB_LATCH{1'b0}};
      end
      else begin
         if(i_debug_enb) begin
            EX_MEM[NB_WB-1:0]                                     <= i_wb_ctl;
            EX_MEM[NB_MEM+NB_WB-1:NB_WB]                          <= i_mem_ctl;
            EX_MEM[NB_MEM+NB_WB+NB_BITS-1:NB_MEM+NB_WB]           <= alu_out;
            EX_MEM[2*NB_BITS+NB_MEM+NB_WB-1:NB_MEM+NB_WB+NB_BITS] <= i_rt_reg;
            EX_MEM[NB_LATCH-1:2*NB_BITS+NB_MEM+NB_WB]             <= reg_dst;
         end
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   always @(*) begin
      /* selector de la fuente del primet argumento de
       * la alu
       */
      case (i_mux_rs_ctl)
        PC_TO_A :     dato_aux_a = i_pc_4;
        RS_TO_A : dato_aux_a = i_rs_reg;
        SEXT_TO_A : dato_aux_a = i_sign_ext;
        default :     dato_aux_a = 0;
      endcase
   end

   always @(*) begin
      /* selector de la fuente del segundo argumento 
       * de la alu
       */
      case(i_mux_rt_ctl)
        RT_TO_B  : dato_aux_b = dato_b;
        SEXT_TO_B: dato_aux_b = i_sign_ext;
        // default  : dato_aux_b = 0;
      endcase
   end

   always @(*) begin
      /* selector para incorporar el hazzard unit
       */
      case(i_mux_a_hz)
        FROM_ID_EX : dato_a = dato_aux_a;  
        FROM_EX_MEM: dato_a = i_ex_mem_reg_hz;
        FROM_MEM_WB: dato_a = i_mem_wb_reg_hz;
        default    : dato_a = dato_aux_a;
      endcase
   end

   always @(*) begin
      /* selector para incorporar el hazzard unit
       */
      case(i_mux_b_hz)
        FROM_ID_EX : dato_b = i_rt_reg;  
        FROM_EX_MEM: dato_b = i_ex_mem_reg_hz;
        FROM_MEM_WB: dato_b = i_mem_wb_reg_hz;
        default    : dato_b = i_rt_reg;
      endcase
   end

   always @(*) begin
      /* selector del registro de destino, 
       * depende si esta codificado en rt o rd
       */
      case(i_mux_dest_ctl)
        DEST_FROM_RD:   reg_dst = i_rd;
        DEST_FROM_RT:   reg_dst = i_rt;
        DEST_TO_RETURN: reg_dst = 5'b11111;
        default:        reg_dst = i_rd; 
      endcase
   end

   Alu #
     (
      .NB_BITS(NB_BITS),
      .NB_OPE(NB_OPE)
      )
   inst_Alu
     (
      .o_alu     (alu_out),
      .i_data_a  (dato_a),
      .i_data_b  (dato_aux_b),
      .i_ope_sel (operation)
      );

   Alu_Control #
     (
      .NB_OPE(NB_OPE),
      .NB_ALU_OP_CTL(NB_ALU_OP_CTL),
      .NB_FUNCTION(NB_FUNCTION)
      )
   inst_Alu_Control
     (
      .o_alu        (operation),
      .i_alu_op_ctl (i_alu_op_ctl),
      .i_function   (i_function)
      );

endmodule // Execution_module
