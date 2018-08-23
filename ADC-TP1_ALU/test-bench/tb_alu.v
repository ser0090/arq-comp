`timescale 1ns / 1ps


module tb_alu();
   parameter NB_BITS = 8;
   parameter NB_OPE = 6;

   
   reg [NB_BITS-1:0] i_data_a;
   reg [NB_BITS-1:0] i_data_b;
   reg [NB_OPE-1:0]  i_ope_sel;
   reg               i_clk;
   
   wire [NB_BITS:0]   o_led;
   
   initial begin
      i_clk = 1'b0;
      i_ope_sel = 6'b100000; // add
      i_data_a = 8'hff;
      i_data_b = 8'h01;

      #20 i_ope_sel = 6'b100010; // sub
      i_data_a = 8'h05;
      i_data_b = 8'h07;
      #20 i_ope_sel = 6'b100100; // and
      i_data_a = 8'hff;
      i_data_b = 8'h08;
      #20 i_ope_sel = 6'b100101; // or
      i_data_a = 8'h0f;
      i_data_b = 8'hf0;
      #20 i_ope_sel = 6'b100110; // xor
      i_data_a = 8'h0f;
      i_data_b = 8'h3f;
      #20 i_ope_sel = 6'b100111; // nor
      i_data_a = 8'h0f;
      i_data_b = 8'hf0;
      #20 i_ope_sel = 6'b000010; // srl
      i_data_a = 8'h10;
      i_data_b = 8'h02;
      #20 i_ope_sel = 6'b000011; // sra
      i_data_a = 8'h80; //-128
      i_data_b = 8'h02;
      #20 $finish;
   end
   always #2.5 i_clk = ~i_clk;
   Alu
     u_alu(.o_led(o_led),
           .i_dato_a(i_data_a),
           .i_dato_b(i_data_b),
           .i_ope_sel(i_ope_sel)
           );
endmodule
