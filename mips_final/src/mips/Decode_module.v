`timescale 1ns / 1ps

module Decode_module #
  (
   parameter NB_BITS = 32, /* asigancion de parametro local */
   parameter NB_REG  = 5,
   parameter NB_JMP  = 28,
   parameter NB_EXEC = 9,
   parameter NB_MEM  = 3,
   parameter NB_WB   = 2
   )
   (
    output [NB_BITS-1:0] o_id_ex_pc,
    output [NB_BITS-1:0] o_id_ex_rs,
    output [NB_BITS-1:0] o_id_ex_rt,
    output [NB_BITS-1:0] o_id_ex_sgext,
    output [NB_EXEC-1:0] o_id_ex_exec,
    output [NB_BITS-1:0] o_brh_addr,
    output [NB_JMP-1:0]  o_jmp_addr,
    //output [NB_REG-1:0] o_if_id_rs_num,
    output [NB_REG-1:0]  o_id_ex_rt_num,
    output [NB_REG-1:0]  o_id_ex_rd_num,
    //output [NB_MEM-1:0]  o_id_ex_mem,
    //output [NB_WB-1:0]   o_id_ex_wrback,
    output               o_pc_beq,
    output               o_pc_src,
    output               o_flush,
    input [NB_BITS-1:0]  i_pc,
    input [NB_BITS-1:0]  i_instr,
    input [NB_BITS-1:0]  i_wb_data,
    input [NB_REG-1:0]   i_reg_dst,
    input                i_wb_rf_webn,
    input                i_clk,
    input                i_rst
    );


   localparam NB_INM = 16;
   localparam NB_IDX = 26;
   localparam SA     = 6;
   //#############################################################
   //#####################  OPS CODES  ###########################
   //#############################################################
   localparam J    = 6'b000010; // jump
   localparam JAL  = 6'b000011; // jump and link
   localparam BEQ  = 6'b000100;
   localparam BEN  = 6'b000101;
   localparam ADDI = 6'b001000; // add inmediate word
   localparam SLTI = 6'b001010; // set on less than
   localparam ANDI = 6'b001100;
   localparam ORI  = 6'b001101;
   localparam XORI = 6'b001110;
   localparam LUI  = 6'b001111;

   localparam LB   = 6'b100000;
   localparam LH   = 6'b100001;
   localparam LW   = 6'b100011;
   localparam LBU  = 6'b100100;
   localparam LHU  = 6'b100101;
   localparam LWU  = 6'b100111;
   localparam SB   = 6'b101000;
   localparam SH   = 6'b101001;
   localparam SW   = 6'b101011;

   localparam SPECIAL = 6'd0;
   //##################### SPECIAL JUMP ########################
   localparam JR   = 6'b001000;
   localparam JALR = 6'b001001;

   //###########################################################
   //###################### ALU CODE ###########################
   //###########################################################
   localparam ALU_J    = 4'b1000;
   localparam ALU_JAL  = 4'b1001;
   localparam ALU_BRQ  = 4'b0001;
   localparam ALU_ADDI = 4'b0000;
   localparam ALU_SLTI = 4'b0011;
   localparam ALU_ANDI = 4'b0100;
   localparam ALU_ORI  = 4'b0101;
   localparam ALU_XORI = 4'b0110;
   localparam ALU_LUI  = 4'b0111;
   localparam ALU_LOAD = 4'b0000;
   localparam ALU_SCP  = 4'b0010;

   //###### SIGN EXTEND #######
   localparam JMP_EXT = 2'd0;
   localparam SGN_EXT = 2'd1;
   localparam ZRO_EXT = 2'd2;
   localparam SPC_EXT = 2'd3;
   
   //###### MUX DEST ##########
   localparam RD  = 2'd0;
   localparam RT  = 2'd1;
   localparam R31 = 2'd2;
  
   /* ##### SECUENCIAL ###### */
   reg [NB_BITS-1:0]     pc;
   reg [NB_BITS-1:0]     rs;
   reg [NB_BITS-1:0]     rt;
   reg [NB_BITS-1:0]     sg_ext;
   reg [NB_REG-1:0]      rt_num;
   reg [NB_REG-1:0]      rd_num;
   reg [NB_EXEC-1:0]     ctr_exec;
   
   /* ##### COMBINACIONAL ###### */
   // --- SIGN EXTEND ---
   reg [NB_BITS-1:0]     sign_extend;
   reg [1:0]             se_case;
   // --- ALU signals ---
   reg [3:0]             alu_op; // 4
   reg [1:0]             rs_alu; // 2
   reg [1:0]             rd_sel; // 2
   reg                   rt_alu; // 1
   // --- BRQ JMP Signals ---
   reg                   beq;
   reg                   ben;
   reg                   pc_src;
   reg                   flush;
   reg                   jal_addr;

   /* #### WIRES #####*/
   // --- Register file Signals ---
   wire [NB_BITS-1:0]    rfile_rs;
   wire [NB_BITS-1:0]    rfile_rt;
   wire                  rfile_zero;

   /* ########## SALIDAS ############ */
   /* --- ID/EX latch --- */
   assign o_id_ex_pc     = pc;
   assign o_id_ex_rs     = rs;
   assign o_id_ex_rt     = rt;
   assign o_id_ex_sgext  = sg_ext;
   assign o_id_ex_rt_num = rt_num;
   assign o_id_ex_rd_num = rd_num;
   assign o_id_ex_exec   = ctr_exec;
   /* --- BRANCH AND JAMP signals --- */
   assign o_jmp_addr = (jal_addr)? rfile_rs[NB_JMP-1:0] << 2 : sign_extend[NB_JMP-1:0] << 2;
   assign o_brh_addr = $signed(sign_extend << 2) + $signed(i_pc);
   assign o_pc_beq   = (beq & rfile_zero) | (ben & ~rfile_zero);
   assign o_pc_src   = pc_src;
   assign o_flush    = flush;

   always @ (posedge i_clk) begin
      if(i_rst) begin
         pc       <= {NB_BITS{1'b0}};
         rs       <= {NB_BITS{1'b0}};
         rt       <= {NB_BITS{1'b0}};
         sg_ext   <= {NB_BITS{1'b0}};
         rt_num   <= {NB_REG{1'b0}};
         rd_num   <= {NB_REG{1'b0}};
         ctr_exec <= {NB_EXEC{1'b0}};
      end
      else begin
         pc       <= i_pc;
         rs       <= rfile_rs;
         rt       <= rfile_rt;
         sg_ext   <= sign_extend;
         rt_num   <= i_instr[20:16];
         rd_num   <= i_instr[15:11];
         ctr_exec <= {alu_op, rs_alu, rt_alu, rd_sel};
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   // ###### SIGN EXTEND ###########
   always @ (*) begin
      case(se_case)
        JMP_EXT: sign_extend = {{NB_BITS-NB_IDX{1'b0}}, i_instr[NB_IDX-1:0]};
        SGN_EXT: sign_extend = {{NB_BITS-NB_INM+1{i_instr[NB_INM-1]}}, i_instr[NB_INM-2:0]};
        ZRO_EXT: sign_extend = {{NB_BITS-NB_INM{1'b0}}, i_instr[NB_INM-1:0]};
        SPC_EXT: sign_extend = {{NB_BITS-SA+1{1'b0}}, i_instr[NB_REG+SA-1:SA]};
      endcase // case (se_case)
   end
   
   /* ##################################################
      ###################### CONTROL ###################
      ################################################## */
   always @ (*) begin
      case(i_instr[31:26])
        J: begin
           se_case  = JMP_EXT;
           // exec signals
           alu_op   = ALU_J;
           rs_alu   = 2'd0;
           rt_alu   = 1'b0;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b1;
           flush    = 1'b1; // nop
           //branch signals
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: J
        JAL: begin
           se_case  = JMP_EXT;
           // exec signals
           alu_op   = ALU_JAL;
           rs_alu   = 2'd0;  // pc
           rt_alu   = 1'b0;
           rd_sel   = R31;  // reg 31
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b1;
           flush    = 1'b1; // nop
           //branch signals
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: JAL
        BEQ: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_BRQ;   //TODO: con un NOP es lo mismo
           rs_alu   = 2'd0;
           rt_alu   = 1'b0;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b1;  //nop
           //branch signals
           beq      = 1'b1;  // beq case
           ben      = 1'b0;
        end // case: BEQ
        BEN: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_BRQ;   //TODO: con un NOP es lo mismo
           rs_alu   = 2'd0;
           rt_alu   = 1'b0;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b1;  // nop
           //branch signals
           beq      = 1'b0;
           ben      = 1'b1;  //ben case
        end // case: BEN
        ADDI: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_ADDI;
           rs_alu   = 2'd1; // rs
           rt_alu   = 1'b1; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: ADDI
        SLTI: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_SLTI;
           rs_alu   = 2'd1; // rs
           rt_alu   = 1'b1; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: SLTI
        ANDI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_ANDI;
           rs_alu   = 2'd1; // rs
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: ANDI
        ORI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_ORI;
           rs_alu   = 2'd1; // rs
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: ORI
        XORI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_XORI;
           rs_alu   = 2'd1; // rs
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: XOIR
        LUI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_LUI;
           rs_alu   = 2'd0;
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: LUI
        LW: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = 2'd1; // rs base
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: LB
        SW: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = 2'd1; // rs base
           rt_alu   = 1'b1; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: SW
        SPECIAL: begin
           se_case  = SPC_EXT;
           // exec signals
           alu_op   = ALU_SCP;
           rs_alu   = 2'd2; // sa inmt
           rt_alu   = 1'b0; // rt
           rd_sel   = RD;
           // mux salto Special Jump
           jal_addr = (i_instr[5:0]==JR || i_instr[5:0]==JALR)? 1'b1 : 1'b0;
           pc_src   = (i_instr[5:0]==JR || i_instr[5:0]==JALR)? 1'b1 : 1'b0;
           flush    = (i_instr[5:0]==JR || i_instr[5:0]==JALR)? 1'b1 : 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: SPECIAL
        default: begin
           se_case  = SGN_EXT;
           alu_op   = ALU_J;
           rs_alu   = 2'd0;
           rt_alu   = 1'b0;
           rd_sel   = RD;
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           flush    = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
        end // case: default
      endcase // case (i_instr[31:26])
   end // always @ (*)

   Register_file # (.NB_BITS (NB_BITS))
   u_register_file
     (
      .o_rs          (rfile_rs),       // registro rs de salid
      .o_rt          (rfile_rt),       // registro rt de salida
      .o_zero        (rfile_zero),
      .i_data        (i_wb_data),      // data write
      .i_read_addr_1 (i_instr[25:21]), // read register rs selector 1
      .i_read_addr_2 (i_instr[20:16]), // read register rt selector 2
      .i_write_addr  (i_reg_dst),      // write selector
      .i_wenb        (i_wb_rf_webn),   // write control enable
      .i_clk         (i_clk),          // clock
      .i_rst         (i_rst)           // reset
      );
endmodule // Decode_module

