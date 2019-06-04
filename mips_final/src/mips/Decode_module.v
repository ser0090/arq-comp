`timescale 1ns / 1ps

///  SER0090
//`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/../arq-comp/mips_final/include/include.v" //Comentar
//`include "/home/martin/Documentos/arq-comp/mips_final/include/include.v" //Comentar

module Decode_module #
  (
   parameter NB_BITS   = `NB_BITS, /* asigancion de parametro local */
   parameter NB_REG    = `NB_REG,
   parameter NB_JMP    = `NB_JUMP,
   parameter NB_EXEC   = `NB_CTR_EXEC,
   parameter NB_MEM    = `NB_CTR_MEM,
   parameter NB_WB     = `NB_CTR_WB,
   parameter NB_FUN    = `NB_FUN,
   //###### OPERATIOS #######
   localparam J        = `OP_INSTR_J, // jump
   localparam JAL      = `OP_INSTR_JAL, // jump and link
   localparam BEQ      = `OP_INSTR_BEQ,
   localparam BEN      = `OP_INSTR_BEN,
   localparam ADDI     = `OP_INSTR_ADDI, // add inmediate word
   localparam SLTI     = `OP_INSTR_SLTI, // set on less than
   localparam ANDI     = `OP_INSTR_ANDI,
   localparam ORI      = `OP_INSTR_ORI,
   localparam XORI     = `OP_INSTR_XORI,
   localparam LUI      = `OP_INSTR_LUI,
   localparam LB       = `OP_INSTR_LB,
   localparam LH       = `OP_INSTR_LH,
   localparam LW       = `OP_INSTR_LW,
   localparam LBU      = `OP_INSTR_LBU,
   localparam LHU      = `OP_INSTR_LHU,
   localparam LWU      = `OP_INSTR_LWU,
   localparam SB       = `OP_INSTR_SB,
   localparam SH       = `OP_INSTR_SH,
   localparam SW       = `OP_INSTR_SW,
   localparam SPECIAL  = `OP_INSTR_SPECIAL,
   localparam HALT     = `OP_INSTR_HALT,
   //###### SPECIAL JUMP #######
   localparam JR       = `FUNC_JR,
   localparam JALR     = `FUNC_JALR,
   localparam SSL      = `FUNC_SLL,
   localparam SRL      = `FUNC_SRL,
   localparam SRA      = `FUNC_SRA,
   //######## ALU CODE ##########
   localparam ALU_J    = `OP_ALU_NONE,
   localparam ALU_JAL  = `OP_ALU_JAL,
   localparam ALU_BRQ  = `OP_ALU_NONE, // OP_ALU_SUB,
   localparam ALU_ADDI = `OP_ALU_ADD,
   localparam ALU_SLTI = `OP_ALU_SLTI,
   localparam ALU_ANDI = `OP_ALU_ANDI,
   localparam ALU_ORI  = `OP_ALU_ORI,
   localparam ALU_XORI = `OP_ALU_XORI,
   localparam ALU_LUI  = `OP_ALU_LUI,
   localparam ALU_LOAD = `OP_ALU_ADD,
   localparam ALU_SCP  = `OP_ALU_FUNC,
   //###### SIGN EXTEND #######
   localparam JMP_EXT  = `JMP_EXT,
   localparam SGN_EXT  = `SGN_EXT,
   localparam ZRO_EXT  = `ZRO_EXT,
   localparam SPC_EXT  = `SPC_EXT,
   //###### MUX R1 ALU ##########
   localparam PC_TO_A  = `PC_TO_A,
   localparam RS_TO_A  = `RS_TO_A,
   localparam SE_TO_A  = `SEXT_TO_A,
   localparam DEF_TO_A = 2'b11,
   //###### MUX R2 ALU ##########
   localparam RT_TO_B  = `RT_TO_B,
   localparam SE_TO_B  = `SEXT_TO_B,
   //###### MUX DEST ##########
   localparam RD       = `DEST_FROM_RD,
   localparam RT       = `DEST_FROM_RT,
   localparam R31      = `DEST_TO_RETURN
   )
   (
    output [NB_BITS-1:0] o_id_ex_pc,
    output [NB_BITS-1:0] o_id_ex_rs,
    output [NB_BITS-1:0] o_id_ex_rt,
    output [NB_BITS-1:0] o_id_ex_sgext,
    output [NB_REG-1:0]  o_id_ex_rs_num,
    output [NB_REG-1:0]  o_id_ex_rt_num,
    output [NB_REG-1:0]  o_id_ex_rd_num,
    output [NB_FUN-1:0]  o_id_ex_func,
    //#### CONTROL output signals ####
    output [NB_WB-1:0]   o_id_ex_wrback,
    output [NB_MEM-1:0]  o_id_ex_mem,
    output [NB_EXEC-1:0] o_id_ex_exec,
    //### JUMP/BRACH control outputs ###
    output [NB_BITS-1:0] o_brh_addr,
    output [NB_BITS-1:0] o_jmp_addr,
    output               o_bmb_brch, //signal brach instr
    output               o_bmb_rjmp, //signal jump register instr
    output               o_pc_beq,
    output               o_pc_src,
    output               o_flush,
    //##### HALT singal #####
    output               o_halt,
    //##### debug output singals #####
    output [NB_BITS-1:0] o_to_SPI, //conectar al SPI

    input [NB_BITS-1:0]  i_pc,
    input [NB_BITS-1:0]  i_instr,
    input [NB_BITS-1:0]  i_wb_data,
    input [NB_REG-1:0]   i_reg_dst,
    input                i_rst,
    input                i_clk,
    //##### WB inputs signal ######
    input                i_wb_rf_webn,
    //##### BUBLE control signal ######
    input                i_bubble, // bubble case
    //##### debug input singals #####
    input [NB_BITS-1:0]  i_from_SPI, // conectar al SPI-salve
    input                i_cs_debug, // chip sel para los mux modo debug
    input                i_debug_enb
    );

   localparam NB_INM = 16;
   localparam NB_IDX = 26;
   localparam SA     = 6;

   /* ##### SECUENCIAL ###### */
   reg [NB_BITS-1:0]     pc;
   reg [NB_BITS-1:0]     rs;
   reg [NB_BITS-1:0]     rt;
   reg [NB_BITS-1:0]     sg_ext;
   reg [NB_FUN-1:0]      funct;
   reg [NB_REG-1:0]      rt_num;
   reg [NB_REG-1:0]      rs_num;
   reg [NB_REG-1:0]      rd_num;
   reg [NB_EXEC-1:0]     ctr_exec;
   reg [NB_MEM-1:0]      ctr_mem;
   reg [NB_WB-1:0]       ctr_wrbk;

   /* ##### COMBINACIONAL ###### */
   // -------- SIGN EXTEND ----------
   reg [NB_BITS-1:0]     sign_extend;
   reg [1:0]             se_case;
   // -------  ALU signals ----------
   reg [3:0]             alu_op; // 4
   reg [1:0]             rs_alu; // 2
   reg [1:0]             rd_sel; // 2
   reg                   rt_alu; // 1
   // ------  BRQ JMP Signals -------
   reg                   beq;
   reg                   ben;
   reg                   pc_src;
   reg                   jal_addr;
   // ------  MEM ctrl Signals ------
   reg [1:0]             mem_wr;
   reg [1:0]             mem_rd;
   // --- WRITE BACK ctrl Signals ---
   reg [NB_WB-2:0]       wrt_back;
   reg                   wrt_enb;
   // --- HATL Signal ---
   reg                   halt;

   /* #### WIRES #####*/
   // --- Register file Signals ---
   wire [NB_BITS-1:0]    rfile_rs;
   wire [NB_BITS-1:0]    rfile_rt;
   wire                  rfile_zero;

   /* --- DEBUG signals --- */
   wire [NB_REG-1:0]     rs_from_interface;

   /* ########## SALIDAS ############ */
   /* --- ID/EX latch --- */
   assign o_id_ex_pc     = pc;
   assign o_id_ex_rs     = rs;
   assign o_id_ex_rt     = rt;
   assign o_id_ex_sgext  = sg_ext;
   assign o_id_ex_func   = funct;
   assign o_id_ex_rt_num = rt_num;
   assign o_id_ex_rs_num = rs_num;
   assign o_id_ex_rd_num = rd_num;
   assign o_id_ex_exec   = ctr_exec;
   assign o_id_ex_mem    = ctr_mem;
   assign o_id_ex_wrback = ctr_wrbk;
   /* --- BRANCH AND JAMP signals --- */

   assign o_jmp_addr = (jal_addr)? rfile_rs :
                       {i_pc[NB_BITS-1:NB_JMP], sign_extend[NB_JMP-1:0] << 2};
   assign o_brh_addr = $signed(sign_extend << 2) + $signed(i_pc);
   assign o_pc_beq   = (beq & rfile_zero) | (ben & ~rfile_zero);
   assign o_pc_src   = pc_src;
   assign o_flush    = ((beq & rfile_zero) | (ben & ~rfile_zero)) | pc_src;
   assign o_bmb_brch = beq | ben;
   assign o_bmb_rjmp = jal_addr;
   // --- HATL Signal ---
   assign o_halt     = halt;

   always @ (posedge i_clk) begin
      if(i_rst) begin
         pc        <= {NB_BITS{1'b0}};
         rs        <= {NB_BITS{1'b0}};
         rt        <= {NB_BITS{1'b0}};
         sg_ext    <= {NB_BITS{1'b0}};
         funct     <= {NB_FUN{1'b0}};
         rt_num    <= {NB_REG{1'b0}};
         rs_num    <= {NB_REG{1'b0}};
         rd_num    <= {NB_REG{1'b0}};
         ctr_exec  <= {NB_EXEC{1'b0}};
         ctr_mem   <= {NB_MEM{1'b0}};
         ctr_wrbk  <= {NB_WB{1'b0}};
      end
      else begin
         if(i_debug_enb) begin
            pc       <= i_pc;
            rs       <= rfile_rs;
            rt       <= rfile_rt;
            sg_ext   <= sign_extend;
            funct    <= i_instr[NB_FUN-1:0];
            rt_num   <= i_instr[20:16];
            rs_num   <= i_instr[25:21];
            rd_num   <= i_instr[15:11];
            ctr_exec <= (i_bubble)? {NB_EXEC{1'b0}} : {alu_op, rs_alu, rd_sel, rt_alu};
            ctr_mem  <= (i_bubble)? {NB_MEM{1'b0}} : {mem_rd, mem_wr};
            ctr_wrbk <= (i_bubble)? {NB_WB{1'b0}} : {wrt_enb, wrt_back};
         end // if (i_debug_enb)
      end // else: !if(i_rst)
   end // always @ (posedge i_clk)

   // ########### SIGN EXTEND ##############
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
   // TODO : agregar funciones de la instruccion HALT
   always @ (*) begin
      case(i_instr[31:26])
        J: begin
           se_case  = JMP_EXT;
           // exec signals
           alu_op   = ALU_J;
           rs_alu   = DEF_TO_A;
           rt_alu   = SE_TO_B;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b1;
           //branch signals
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
        end // case: J
        JAL: begin
           se_case  = JMP_EXT;
           // exec signals
           alu_op   = ALU_JAL;
           rs_alu   = PC_TO_A;  // pc
           rt_alu   = SE_TO_B;
           rd_sel   = R31;  // reg 31
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b1;
           //branch signals
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1; // reg 31
           // HALT signal
           halt     = 1'b1;
       end // case: JAL
        BEQ: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_BRQ;   //TODO: con un NOP es lo mismo
           rs_alu   = DEF_TO_A;
           rt_alu   = SE_TO_B;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           //branch signals
           beq      = 1'b1;  // beq case
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
       end // case: BEQ
        BEN: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_BRQ;   //TODO: con un NOP es lo mismo
           rs_alu   = DEF_TO_A;
           rt_alu   = SE_TO_B;
           rd_sel   = RD;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           //pc_beq   = 1'b1;
           //flush    = 1'b0;  // nop
           //branch signals
           beq      = 1'b0;
           ben      = 1'b1;  //ben case
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
       end // case: BEN
        ADDI: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_ADDI;
           rs_alu   = RS_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: ADDI
        SLTI: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_SLTI;
           rs_alu   = RS_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: SLTI
        ANDI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_ANDI;
           rs_alu   = RS_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: ANDI
        ORI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_ORI;
           rs_alu   = RS_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: ORI
        XORI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_XORI;
           rs_alu   = RS_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // muxs de saltos
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: XOIR
        LUI: begin
           se_case  = ZRO_EXT;
           // exec signals
           alu_op   = ALU_LUI;
           rs_alu   = DEF_TO_A; // rs
           rt_alu   = SE_TO_B; // inm
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LUI
        LB: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_BYTE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_SIGN_BYT;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LB
        LH: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_HALFWORD;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_SIGN_HAL;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LH
        LW: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_WORD;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LW
        LBU: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_BYTE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LBU
        LHU: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_HALFWORD;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LHU
        LWU: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_WORD;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b1;
           // HALT signal
           halt     = 1'b1;
       end // case: LWU
        SB: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_BYTE;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
       end // case: SB
        SH: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_HALFWORD;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
       end // case: SH
        SW: begin
           se_case  = SGN_EXT;
           // exec signals
           alu_op   = ALU_LOAD;
           rs_alu   = RS_TO_A; // rs base
           rt_alu   = SE_TO_B; // in
           rd_sel   = RT;
           // mux salto
           jal_addr = 1'b0;
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_WORD;
           //write back signals
           wrt_back = `DATA_FROM_MEM;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b1;
       end // case: SW
        SPECIAL: begin
           se_case  = SPC_EXT;
           // exec signals
           alu_op   = ALU_SCP;
           case(i_instr[5:0])
             JALR:    rs_alu = PC_TO_A;
             SSL:     rs_alu = SE_TO_A;
             SRL:     rs_alu = SE_TO_A;
             SRA:     rs_alu = SE_TO_A;
             default: rs_alu = RS_TO_A;
           endcase // case (i_instr[5:0])
           rt_alu   = RT_TO_B; // rt
           rd_sel   = RD;
           // mux salto Special Jump
           jal_addr = (i_instr[5:0]==JR || i_instr[5:0]==JALR)? 1'b1 : 1'b0;
           pc_src   = (i_instr[5:0]==JR || i_instr[5:0]==JALR)? 1'b1 : 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //mem signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           //write back signals
           wrt_back = `DATA_FROM_ALU;
           wrt_enb  = (i_instr[5:0]==JR)? 1'b0 : 1'b1;
           // HALT signal
           halt     = 1'b1;
        end // case: SPECIAL
        default: begin    // -----------HALT--------
           se_case  = ZRO_EXT;   // zero exetnd
           alu_op   = ALU_SCP;   // especial ope
           rs_alu   = DEF_TO_A;  // default
           rt_alu   = SE_TO_B;   // sgin extension
           rd_sel   = R31;       // por si escribe el reg 0
           jal_addr = 1'b0;      //
           pc_src   = 1'b0;
           beq      = 1'b0;
           ben      = 1'b0;
           //CTR signals
           mem_rd   = `READ_DISABLE;
           mem_wr   = `WRITE_DISABLE;
           wrt_back = 2'b00;
           wrt_enb  = 1'b0;
           // HALT signal
           halt     = 1'b0;
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
      .i_read_addr_1 (rs_from_interface), // read register rs selector 1
      .i_read_addr_2 (i_instr[20:16]), // read register rt selector 2
      .i_write_addr  (i_reg_dst),      // write selector
      .i_wenb        (i_wb_rf_webn),   // write control enable
      .i_clk         (i_clk),          // clock
      .i_rst         (i_rst)           // reset
      );

  SPI_Decode_Interface #
     (
      .NB_BITS(NB_BITS),
      .NB_LATCH(NB_BITS*4),
      .NB_REG(NB_REG)
      )
   u_SPI_Decode_Interface
     (
      .o_SPI      (o_to_SPI),
      .o_rs       (rs_from_interface),
      .i_latch    ({sg_ext, rt , rs, pc}),
      .i_rs       (i_instr[25:21]),
      .i_reg_data (rfile_rs),
      .i_SPI      (i_from_SPI),
      .i_in_use   (i_cs_debug)
      );

endmodule // Decode_module

