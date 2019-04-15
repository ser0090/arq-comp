`timescale 1ns / 1ps


module tb_fetch();
   parameter NB_BITS = 32;
   
   wire [NB_BITS-1:0] o_if_id_pc;
   wire [NB_BITS-1:0] o_if_id_instr;
   reg [NB_BITS-1:0]  i_brq_addr;
   reg [NB_BITS-1:0]  i_jmp_addr;
   reg                i_ctr_beq;
   reg                i_ctr_jmp;
   reg                i_ctr_flush;
   reg                i_pc_we;
   reg                i_if_id_we;
   reg                i_clk;
   reg                i_rst;
   
   initial begin
      i_brq_addr  = 40;
      i_jmp_addr  = 100;
      i_ctr_beq   = 1'b0;
      i_ctr_jmp   = 1'b0;
      i_ctr_flush = 1'b0;
      i_pc_we     = 1'b1;
      i_if_id_we  = 1'b1;
      i_clk       = 1'b1;
      i_rst       = 1'b1;

      #10 i_rst       = 1'b0;
      // branch
      #20 i_ctr_beq   = 1'b1;
      i_ctr_flush     = 1'b1;
      #5 i_ctr_beq    = 1'b0;
      i_ctr_flush     = 1'b0;
      // jump
      #20 i_ctr_jmp   = 1'b1;
      i_ctr_flush     = 1'b1;
      #10 i_ctr_beq   = 1'b1;
      #5 i_ctr_beq    = 1'b0;
      #5 i_ctr_jmp    = 1'b0;
      i_ctr_flush     = 1'b0;
      // we
      #30 i_pc_we     = 1'b0;
      i_if_id_we      = 1'b0;
      
      #10 i_ctr_flush = 1'b1;
      #5 i_ctr_flush  = 1'b0;
      
      #5 i_pc_we      = 1'b1;
      #5 i_if_id_we   = 1'b1;
      #10 $finish;
      
   end
   always #2.5 i_clk = ~i_clk;
   
   Fetch_module
     u_fetch
       (
        .o_if_id_pc    (o_if_id_pc),
        .o_if_id_instr (o_if_id_instr) ,
        .i_brq_addr    (i_brq_addr),
        .i_jmp_addr    (i_jmp_addr),
        .i_ctr_beq     (i_ctr_beq),
        .i_ctr_jmp     (i_ctr_jmp),
        .i_ctr_flush   (i_ctr_flush),
        .i_pc_we       (i_pc_we),
        .i_if_id_we    (i_if_id_we),
        .i_clk         (i_clk),
        .i_rst         (i_rst)
        );

endmodule
