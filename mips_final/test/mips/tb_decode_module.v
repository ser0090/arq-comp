`timescale 1ns / 1ps

module tb_decode_module();
   parameter NB_BITS = 32; /* asigancion de parametro local */
   parameter NB_REG  = 5;
   parameter NB_JMP  = 28;
   parameter NB_EXEC = 9;
   parameter NB_MEM  = 3;
   parameter NB_WB   = 2;

   localparam J    = 32'b000010_00000000000000000000100000;
   localparam JAL  = 32'b000011_00000000000000000001000001;

   localparam BEQ  = 32'b000100_00001_00010_0000000010000001;
   localparam BEN  = 32'b000101_00001_00011_0000000000110000;
   localparam ADDI = 32'b001000_00001_00100_0000000000000111;
   localparam SLTI = 32'b001010_00001_00101_0000000000000100;
   localparam ANDI = 32'b001100_00010_00110_0000000000000001;
   localparam ORI  = 32'b001101_00001_00111_1110000000000000;
   localparam XORI = 32'b001110_00010_01000_0000000000001111;
   localparam LUI  = 32'b001111_00000_01001_0000000000000111;
   //localparam LB   = 32'b100000;
   //localparam LH   = 32'b100001;
   localparam LW_R1  = 32'b100011_00010_00001_0000000000000100;
   localparam LW_R2  = 32'b100011_00010_00010_0000000000000100;
   localparam LW_R10 = 32'b100011_00010_01010_0000000000000100;
   //localparam LBU  = 32'b100100;
   //localparam LHU  = 32'b100101;
   //localparam LWU  = 32'b100111;
   //localparam SB   = 32'b101000;
   //localparam SH   = 32'b101001;
   localparam SW_R1  = 32'b101011_00010_00001_0000000000001000;
   localparam SW_R2  = 32'b101011_00010_00010_0000000000001000;
   localparam SW_R10 = 32'b101011_00010_01010_0000000000001000;

   localparam JR   = 32'b000000_01010_000000000000000_001000;
   localparam JALR = 32'b000000_01010_00000_01011_00000_001001;

   wire [NB_BITS-1:0] o_id_ex_pc;
   wire [NB_BITS-1:0] o_id_ex_rs;
   wire [NB_BITS-1:0] o_id_ex_rt;
   wire [NB_BITS-1:0] o_id_ex_sgext;
   wire [NB_EXEC-1:0] o_id_ex_exec;
   wire [NB_BITS-1:0] o_brh_addr;
   wire [NB_JMP-1:0]  o_jmp_addr;
   //wire [NB_REG-1:0] o_if_id_rs_num;
   wire [NB_REG-1:0]  o_id_ex_rt_num;
   wire [NB_REG-1:0]  o_id_ex_rd_num;
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

   initial begin
      i_pc            = 0;
      i_instr         = 0;
      i_wb_data       = 0;
      i_reg_dst       = 0;
      i_wb_rf_webn    = 0;
      i_clk           = 1;
      i_rst           = 1;
      #10 i_rst       = 0;
      i_instr         = LW_R1;
      i_wb_data       = 1;
      i_reg_dst       = 1;
      i_wb_rf_webn    = 1;
      #5 i_wb_rf_webn = 0;
      i_instr         = 0;
      #5 i_instr      = LW_R2;
      i_wb_data       = 2;
      i_reg_dst       = 2;
      i_wb_rf_webn    = 1;
      #5 i_wb_rf_webn = 0;
      i_instr         = 0;
      #5 i_instr      = LW_R10;
      i_wb_data       = 8;
      i_reg_dst       = 10;
      i_wb_rf_webn    = 1;
      #5 i_wb_rf_webn = 0;
      i_instr         = 0;
      i_wb_data       = 0;
      i_reg_dst       = 0;
      #5 i_instr      = SW_R1;
      #5 i_instr      = SW_R2;
      #5 i_instr      = SW_R10;
      
      #5 i_instr      = J;
      #5 i_instr      = 0;
      #5 i_instr      = JAL;
      #5 i_instr      = 0;
      #5 i_instr      = BEQ;
      #5 i_instr      = 0;
      #5 i_instr      = BEN;
      #5 i_instr      = 0;
      #5 i_instr      = JR;
      #5 i_instr      = 0;
      #5 i_instr      = JALR;
      #5 i_instr      = 0;
      #5 i_instr      = ADDI;
      #5 i_instr      = SLTI;
      #5 i_instr      = ANDI;
      #5 i_instr      = ORI;
      #5 i_instr      = XORI;
      #5 i_instr      = LUI;
      
      
      #10 $finish;
   end

   always #2.5 i_clk = ~i_clk;

   Decode_module
     inst_Decode_module
       (
			  .o_id_ex_pc     (o_id_ex_pc),
			  .o_id_ex_rs     (o_id_ex_rs),
			  .o_id_ex_rt     (o_id_ex_rt),
			  .o_id_ex_sgext  (o_id_ex_sgext),
			  .o_id_ex_exec   (o_id_ex_exec),
			  .o_brh_addr     (o_brh_addr),
			  .o_jmp_addr     (o_jmp_addr),
			  .o_id_ex_rt_num (o_id_ex_rt_num),
			  .o_id_ex_rd_num (o_id_ex_rd_num),
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
endmodule // tb_decode_module
