`timescale 1ns / 1ps


module tb_alu();
   
   localparam SLL = 4'b1000; // 8 shift lefth logical
   localparam SRL = 4'b1001; // 9 shift rigth logical
   localparam SRA = 4'b1010; // 10 shift right arithmetic
   localparam ADD = 4'b0010; // 2 add unsigned word
   localparam SUB = 4'b0110; // 6 subtract unsigned word
   localparam AND = 4'b0000; // 0
   localparam OR  = 4'b0001; // 1
   localparam XOR = 4'b0011; // 3
   localparam NOR = 4'b1100; // 12
   localparam SLT = 4'b0111; // 7 set on less than
   localparam JAL = 4'b1101; // 13 jump and link
   localparam LUI = 4'b1110; // 14
   reg [31:0] i_data_a;
   reg [31:0] i_data_b;
   reg [3:0]  i_ope_sel;
   reg        i_clk;

   wire [31:0]   o_alu;
   wire          o_zero;
   
   initial begin
      i_clk = 1'b0;
      i_ope_sel = ADD ; // add
      i_data_a = 255;
      i_data_b = 1;

      #10 i_ope_sel = SUB; // sub
      i_data_a = 255;
      i_data_b = 255;
      #10 i_ope_sel = AND; // and
      i_data_a = 32'hffffffff;
      i_data_b = 32'h02;
      #10 i_ope_sel = OR; // or
      i_data_a = 32'hf00;
      i_data_b = 32'h0f0;
      #10 i_ope_sel = XOR; // xor
      i_data_a = 32'h0f;
      i_data_b = 32'h3f;
      #10 i_ope_sel = NOR; // nor
      i_data_a = 32'h00f;
      i_data_b = 32'hff0;
      #10 i_ope_sel = SRL; // srl
      i_data_b = 32'h1fff0f2f;
      i_data_a = 32'd4;
      #10 i_ope_sel = SRA; // sra
      i_data_b = 32'he0000080;
      i_data_a = 32'h4;
      #10 i_ope_sel = SLL;
      i_data_b = 32'he0000080;
      i_data_a = 32'h4;
      #10 i_ope_sel = SLT;
      i_data_a = 32'h4;
      i_data_b = 32'h5;
      #10 i_data_a = 32'h4;
      i_data_b = 32'h4;
      #10 i_ope_sel = JAL;
      i_data_a = 32'h10;
      i_data_b = 32'h5;
      #10 i_ope_sel = LUI;
      i_data_b = 32'h19fff;
      i_data_a = 32'h4;
      #10 i_ope_sel = 4'd15;
      
      #10 $finish;
   end
   always #2.5 i_clk = ~i_clk;
   Alu
     u_alu(.o_alu     (o_alu),
           .o_zero    (o_zero),
           .i_data_a  (i_data_a),
           .i_data_b  (i_data_b),
           .i_ope_sel (i_ope_sel)
           );
endmodule
