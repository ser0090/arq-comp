`timescale 1ns / 1ps
///  SER0090
`include "/home/ssulca/arq-comp/mips_final/include/include.v"  //Comentar
//`include "/home/sergio/arq-comp/mips_final/include/include.v"  //Comentar

//`include "/home/tincho/Documentos/ADC/arq-comp/mips_final/include/include.v" //Comentar
module tb_mips();
   parameter NB_BITS   = `NB_BITS; /* asigancion de parametro local */
   parameter NB_REG    = `NB_REG;
   parameter NB_JMP    = `NB_JUMP;
   parameter NB_EXEC   = `NB_CTR_EXEC;
   parameter NB_MEM    = `NB_CTR_MEM;
   parameter NB_WB     = `NB_CTR_WB;

   //reg [NB_BITS-1:0]  i_wb_data;
   //reg [NB_REG-1:0]   i_reg_dst;
   //reg                i_wb_rf_webn;
   reg                i_continue;
   reg                i_valid;
   reg                i_clk;
   reg                i_rst;
   wire [NB_BITS-1:0] o_data;
   wire [5:0]         o_operation;
   wire [5:0]         o_function;

   initial begin
      i_clk = 1'b1;
      i_rst = 1'b1;
      i_continue = 1'b1;
      i_valid    = 1'b0;
 
      #4.9 i_rst = 1'b0;
      i_continue = 1'b0;
      #10 i_valid    = 1'b1;
      #20 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #30 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #20 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #10 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #30 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #10 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #10 i_valid    = 1'b0;
      #10 i_valid    = 1'b1;
      #10 i_valid    = 1'b0;

      //sumulation
      #240 $finish;
   end
   always #2.5 i_clk = ~i_clk;

   Mips #()
   inst_Mips
     (
      .o_led       (o_data),
      .o_operation (o_operation),
      .o_function  (o_function),
      .i_valid     (i_valid),
      .i_continue  (i_continue),
      .i_clk       (i_clk),
      .i_rst       (i_rst)
      );
endmodule // tb_mips

