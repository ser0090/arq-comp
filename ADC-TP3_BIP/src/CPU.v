`timescale 1ns / 1ps

module CPU #
  (
   parameter NB_BITS = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   localparam NB_SELA = 2
   )
   (
    output [clogb2(INS_MEM_DEPTH-1)-1:0]  o_addr_ins,
    output [clogb2(INS_MEM_DEPTH-1)-1:0]  o_addr_data,
    output [NB_BITS-1:0]  o_data,
    output                o_wr,
    output                o_rd,
    input [NB_BITS-1:0]   i_instruction,
    input [NB_BITS-1:0]   i_data_mem,
    input                 i_clk,
    input                 i_rst
    );

   wire [NB_SELA-1:0] sel_a;
   wire sel_b;
   wire wr_acc;
   wire op_code;
   wire wr;
   wire rd;
   wire [clogb2(INS_MEM_DEPTH-1)-1:0]  addr_ins;
   wire [clogb2(INS_MEM_DEPTH-1)-1:0]  addr_data;
   wire [NB_BITS-1:0] data;
   wire [NB_SIGX-1:0]  data_ins;

   assign o_addr_ins = addr_ins;
   assign o_addr_data = data_ins; //addr_data;
   assign o_data = data;
   assign o_rd = rd;
   assign o_wr = wr;

    Datapath #(
      .NB_BITS(NB_BITS),
      .NB_SIGX(NB_SIGX)
    ) inst_Datapath (
      .o_data     (data),
      .i_data_mem (i_data_mem),
      .i_data_ins (data_ins),
      .i_sel_a    (sel_a),
      .i_sel_b    (sel_b),
      .i_wr_acc   (wr_acc),
      .i_op_code  (op_code),
      .i_clk      (i_clk),
      .i_rst      (i_rst)
    );
  Control #(
      .NB_BITS(NB_BITS),
      .INS_MEM_DEPTH(INS_MEM_DEPTH),
      .NB_SIGX(NB_SIGX)
    ) inst_Control (
      .o_addr_ins    (addr_ins),
      .o_data_ins    (data_ins),
      .o_sel_a       (sel_a),
      .o_sel_b       (sel_b),
      .o_wr_acc      (wr_acc),
      .o_op_code     (op_code),
      .o_wr          (wr),
      .o_rd          (rd),
      .i_instruction (i_instruction),
      .i_clk         (i_clk),
      .i_rst         (i_rst)
    );


    function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    endfunction // clogb

   endmodule