`timescale 1ns / 1ps

///  SER0090
`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

///  IOTINCHO
//`include "/home/tincho/../arq-comp/mips_final/include/include.v" //Comentar

module Mpis #
  (
   parameter NB_BITS   = `NB_BITS, /* asigancion de parametro local */
   parameter NB_REG    = `NB_REG,
   parameter NB_JMP    = `NB_JUMP,
   parameter NB_EXEC   = `NB_CTR_EXEC,
   parameter NB_MEM    = `NB_CTR_MEM,
   parameter NB_WB     = `NB_CTR_WB,
   localparam NB_FUN   = `NB_FUN
   )
   (
    output [NB_BITS-1:0] o_alu_out,
    output [NB_BITS-1:0] o_data_reg,
    output [NB_REG-1:0]  o_reg_dst,
    output [7:0]         o_wb_ctl,
    output [7:0]         o_mem_ctl,
    input [NB_BITS-1:0]  i_wb_data,
    input [NB_REG-1:0]   i_reg_dst,
    input                i_wb_rf_webn,
    input                i_clk,
    input                i_rst
    );

   /* ##### SECUENCIAL ###### */

   /* ##### COMBINACIONAL ###### */

   /* #### WIRES #####*/
   // --- Wire Connectios FET/DEC ---
   wire [NB_BITS-1:0]    fet_2_dec_pc;
   wire [NB_BITS-1:0]    fet_2_dec_instr;
   wire [NB_BITS-1:0]    dec_2_fet_brh_addr;
   wire [NB_JMP-1:0]     dec_2_fet_jmp_addr;
   wire                  dec_2_fet_pc_beq;
   wire                  dec_2_fet_pc_src;
   wire                  dec_2_fet_flush;
   // --- Wire Connectios DEC/EXE ---
   wire [NB_BITS-1:0]    dec_2_ex_pc;
   wire [NB_BITS-1:0]    dec_2_ex_rs;
   wire [NB_BITS-1:0]    dec_2_ex_rt;
   wire [NB_BITS-1:0]    dec_2_ex_sgext;
   wire [NB_EXEC-1:0]    dec_2_ex_exec;
   wire [NB_FUN-1:0]     dec_2_ex_func;
   wire [NB_REG-1:0]     dec_2_ex_rt_num;
   wire [NB_REG-1:0]     dec_2_ex_rd_num;
   /* ########## SALIDAS ############ */
   /* --- EX/MEM latch --- */
   

   Fetch_module #
     (
      .FILE_DEPTH(60),
      .INIT_FILE  ("/home/ssulca/arq-comp/mips_final/include/mem_instr.txt") //Comentar
      //.INIT_FILE  ("/home/tincho/Documentos/ADC/mips_final/include/mem_instr.txt") //Comentar
		  )
   inst_Fetch_module
     (
			.o_if_id_pc    (fet_2_dec_pc),
			.o_if_id_instr (fet_2_dec_instr),
			.i_brq_addr    (dec_2_fet_brh_addr),
			.i_jmp_addr    (dec_2_fet_jmp_addr),
			.i_ctr_beq     (dec_2_fet_pc_beq),
			.i_ctr_jmp     (dec_2_fet_pc_src),
			.i_ctr_flush   (dec_2_fet_flush),
			.i_pc_we       (1'b1),
			.i_if_id_we    (1'b1),
			.i_clk         (i_clk),
			.i_rst         (i_rst)
		  );

   Decode_module #()
   inst_Decode_module
     (
			.o_id_ex_pc     (dec_2_ex_pc),
			.o_id_ex_rs     (dec_2_ex_rs),
			.o_id_ex_rt     (dec_2_ex_rt),
			.o_id_ex_sgext  (dec_2_ex_sgext),
			.o_id_ex_exec   (dec_2_ex_exec),
			.o_brh_addr     (dec_2_fet_brh_addr),
			.o_jmp_addr     (dec_2_fet_jmp_addr),
			.o_id_ex_rt_num (dec_2_ex_rt_num),
			.o_id_ex_rd_num (dec_2_ex_rd_num),
      .o_id_ex_func   (dec_2_ex_func),
			.o_pc_beq       (dec_2_fet_pc_beq),
			.o_pc_src       (dec_2_fet_pc_src),
			.o_flush        (dec_2_fet_flush),
			.i_pc           (fet_2_dec_pc),
			.i_instr        (fet_2_dec_instr),
			.i_wb_data      (i_wb_data),
			.i_reg_dst      (i_reg_dst),
			.i_wb_rf_webn   (i_wb_rf_webn),
			.i_clk          (i_clk),
			.i_rst          (i_rst)
		  );
   
   Execution_module #()
	 inst_Execution_module
     (
			.o_alu_out       (o_alu_out),
			.o_data_reg      (o_data_reg),
			.o_reg_dst       (o_reg_dst),
			.o_wb_ctl        (o_wb_ctl),
			.o_mem_ctl       (o_mem_ctl),
			.i_mux_a_hz      (0),
			.i_mux_b_hz      (0),
			.i_ex_mem_reg_hz (0),
			.i_mem_wb_reg_hz (0),
			.i_alu_op_ctl    (dec_2_ex_exec[8:5]),
			.i_mux_rs_ctl    (dec_2_ex_exec[4:3]),
			.i_mux_rt_ctl    (dec_2_ex_exec[0]),
			.i_mux_dest_ctl  (dec_2_ex_exec[2:1]),
			.i_rt            (dec_2_ex_rt_num),
			.i_rd            (dec_2_ex_rd_num),
			.i_sign_ext      (dec_2_ex_sgext),
			.i_rt_reg        (dec_2_ex_rt),
			.i_rs_reg        (dec_2_ex_rs),
			.i_pc_4          (dec_2_ex_pc),
			.i_function      (dec_2_ex_func),
			.i_wb_ctl        (0),
			.i_mem_ctl       (0),
			.i_clk           (i_clk),
			.i_rst           (i_rst)
		  );

endmodule // Mpis


