`timescale 1ns / 1ps
///  SER0090
`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

module tb_fetch_decode();
   parameter NB_BITS   = `NB_BITS; /* asigancion de parametro local */
   parameter NB_REG    = `NB_REG;
   parameter NB_JMP    = `NB_JUMP;
   parameter NB_EXEC   = `NB_CTR_EXEC;
   parameter NB_MEM    = `NB_CTR_MEM;
   parameter NB_WB     = `NB_CTR_WB;

   reg [NB_BITS-1:0]  i_wb_data;
   reg [NB_REG-1:0]   i_reg_dst;
   reg                i_wb_rf_webn;
   reg                i_clk;
   reg                i_rst;

   wire [NB_BITS-1:0] fet_2_dec_pc;
   wire [NB_BITS-1:0] fet_2_dec_instr;

   wire [NB_BITS-1:0] dec_2_fet_brh_addr;
   wire [NB_JMP-1:0]  dec_2_fet_jmp_addr;
   wire               dec_2_fet_pc_beq;
   wire               dec_2_fet_pc_src;
   wire               dec_2_fet_flush;

   wire [NB_BITS-1:0] o_id_ex_pc;
   wire [NB_BITS-1:0] o_id_ex_rs;
   wire [NB_BITS-1:0] o_id_ex_rt;
   wire [NB_BITS-1:0] o_id_ex_sgext;
   wire [NB_EXEC-1:0] o_id_ex_exec;
   //output [NB_REG-1:0] o_if_id_rs_num,
   wire [NB_REG-1:0]  o_id_ex_rt_num;
   wire [NB_REG-1:0]  o_id_ex_rd_num;

   wire [5:0]         operacion = fet_2_dec_instr[31:26];
   
   initial begin
      i_clk = 1'b1;
      i_rst = 1'b1;
      i_wb_data = 0;
      i_reg_dst = 0;
      i_wb_rf_webn = 0;
      
      #5 i_rst = 1'b0;
      
      #5 i_wb_rf_webn = 1; // load r1
      i_wb_data       = 1;
      i_reg_dst       = 1;
      #5 i_wb_rf_webn = 0;
      #5 i_wb_rf_webn = 1; // load r2
      i_wb_data       = 2;
      i_reg_dst       = 2;
      #5 i_wb_rf_webn = 0;
      #5 i_wb_rf_webn = 1; // load r10
      i_wb_data       = 8;
      i_reg_dst       = 10;
      #5 i_wb_rf_webn = 0;
      i_wb_data       = 0;
      i_reg_dst       = 29;
      
      #150 $finish;
   end
   always #2.5 i_clk = ~i_clk;

   Fetch_module #
     (
      .FILE_DEPTH(60),
      .INIT_FILE  ("/home/ssulca/arq-comp/mips_final/include/mem_instr.txt") //Comentar
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
			.o_id_ex_pc     (o_id_ex_pc),
			.o_id_ex_rs     (o_id_ex_rs),
			.o_id_ex_rt     (o_id_ex_rt),
			.o_id_ex_sgext  (o_id_ex_sgext),
			.o_id_ex_exec   (o_id_ex_exec),
			.o_brh_addr     (dec_2_fet_brh_addr),
			.o_jmp_addr     (dec_2_fet_jmp_addr),
			.o_id_ex_rt_num (o_id_ex_rt_num),
			.o_id_ex_rd_num (o_id_ex_rd_num),
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

endmodule
