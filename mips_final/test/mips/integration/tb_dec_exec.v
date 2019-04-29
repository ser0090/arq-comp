`timescale 1ns / 1ps
///  SER0090
`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar

module tb_dec_exec();
   parameter NB_BITS   = `NB_BITS; /* asigancion de parametro local */
   parameter NB_REG    = `NB_REG;
   parameter NB_JMP    = `NB_JUMP;
   parameter NB_EXEC   = `NB_CTR_EXEC;
   parameter NB_MEM    = `NB_CTR_MEM;
   parameter NB_WB     = `NB_CTR_WB;
   parameter FILE      =  "/home/ssulca/arq-comp/mips_final/bin_str_file";  //Comentar
   
   wire [NB_BITS-1:0] o_alu_out;
   wire [NB_BITS-1:0] o_data_reg;
   wire [4:0]         o_reg_dst;
   wire [7:0]         o_wb_ctl;
   wire [7:0]         o_mem_ctl;
   
   wire [NB_BITS-1:0] dec_2_ex_pc;
   wire [NB_BITS-1:0] dec_2_ex_rs;
   wire [NB_BITS-1:0] dec_2_ex_rt;
   wire [NB_BITS-1:0] dec_2_ex_sgext;
   wire [NB_EXEC-1:0] dec_2_ex_exec;
   wire [5:0]         dec_2_ex_func;
   
   wire [NB_BITS-1:0] o_brh_addr;
   wire [NB_JMP-1:0]  o_jmp_addr;
   //wire [NB_REG-1:0] o_if_id_rs_num;
   wire [NB_REG-1:0]  dec_2_ex_rt_num;
   wire [NB_REG-1:0]  dec_2_ex_rd_num;
   //wire [NB_MEM-1:0]  o_id_ex_mem;
   //wire [NB_WB-1:0]   o_id_ex_wrback;
   wire               o_pc_beq;
   wire               o_pc_src;
   wire               o_flush;
   
   reg [NB_BITS-1:0]  i_pc;
   reg [NB_BITS-1:0]  i_instr;
   reg [NB_BITS-1:0]  i_wb_data;
   reg [NB_REG-1:0]   i_reg_dst;
   reg                i_wb_rf_webn;
   reg                i_clk;
   reg                i_rst;
   
   wire [5:0]         operacion = i_instr[31:26];
   //wire [5:0]         funct     = i_instr[5:0];
   integer            file;
   
   initial begin
      i_clk        = 1'b1;
      i_rst        = 1'b1;
      i_wb_data    = 0;
      i_reg_dst    = 0;
      i_wb_rf_webn = 0;
      i_pc         = 0;
      i_instr      = 0;
      file = $fopen(FILE,"r"); //"r" means reading and "w" means writing
      if(file == 0) begin
         $display("fail read file\n");
         $finish;
      end
      
      #5 i_rst        = 1'b0;
      #5.1 $fscanf(file,"%32b\n", i_instr);
      i_wb_rf_webn    = 1; // load r1
      i_wb_data       = 1;
      i_reg_dst       = 1;
      i_pc            = i_pc + 1;
      #5 i_wb_rf_webn = 0;
      i_pc            = i_pc + 1;
      #5 $fscanf(file,"%32b\n", i_instr);
      i_wb_rf_webn    = 1; // load r2
      i_wb_data       = 2;
      i_reg_dst       = 2;
      i_pc            = i_pc + 1;
      #5 i_wb_rf_webn = 0;
      i_pc            = i_pc + 1;
      #5 $fscanf(file,"%32b\n", i_instr);
      i_wb_rf_webn    = 1; // load r21
      i_wb_data       = 48;
      i_reg_dst       = 21;
      i_pc            = i_pc + 1;
      #5 i_wb_rf_webn = 0;
      i_pc            = i_pc + 1;
      #5 $fscanf(file,"%32b\n", i_instr);
        i_wb_rf_webn  = 1; // load r20
      i_wb_data       = 58;
      i_reg_dst       = 20;
      i_pc            = i_pc + 1;
      #5 i_wb_rf_webn = 0;
      i_pc            = i_pc + 1;
      i_wb_data       = 0;
      i_reg_dst       = 29;
      while (!$feof(file)) begin  //read until an "end of file" is reached.
         #5 $fscanf(file,"%32b\n", i_instr); //scan each line and get the value as an binary
         i_pc = i_pc + 1;
      end
      $fclose(file);
      #50 $finish;
   end
   always #2.5 i_clk = ~i_clk;
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

   Decode_module #()
   inst_Decode_module
     (
			.o_id_ex_pc     (dec_2_ex_pc),
			.o_id_ex_rs     (dec_2_ex_rs),
			.o_id_ex_rt     (dec_2_ex_rt),
			.o_id_ex_sgext  (dec_2_ex_sgext),
			.o_id_ex_exec   (dec_2_ex_exec),
			.o_brh_addr     (o_brh_addr),
			.o_jmp_addr     (o_jmp_addr),
			.o_id_ex_rt_num (dec_2_ex_rt_num),
			.o_id_ex_rd_num (dec_2_ex_rd_num),
      .o_id_ex_func   (dec_2_ex_func),
			.o_pc_beq       (o_pc_beq),
			.o_pc_src       (o_pc_src),
			.o_flush        (o_flush),
			.i_pc           (i_pc),
			.i_instr        (i_instr),
			.i_wb_data      (i_wb_data),
			.i_reg_dst      (i_reg_dst),
			.i_wb_rf_webn   (i_wb_rf_webn),
			.i_clk          (i_clk),
			.i_rst          (i_rst)
		);


endmodule
