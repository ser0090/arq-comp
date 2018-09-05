`timescale 1ns / 1ps


module tb_top();
   parameter NB_SW = 8;
   parameter NB_BTN = 3;
   parameter NB_LED = 9;
   
   reg [NB_SW-1:0]  i_sw;
   reg [NB_BTN-1:0] i_btn;
   reg              i_clk,i_rst;
   
   wire [NB_LED-1:0] o_led;
   
   initial begin
      i_clk = 1'b0;
      i_rst = 1'b1;
      i_sw = 8'h0;
      i_btn = 3'h0;
      
      #10 i_rst = 1'b0;
      i_sw = 6'b100000; // add
      #10 i_btn = 3'b100;
      #10 i_btn = 3'b000;
      
      #10 i_sw = 8'h05;
      #10 i_btn = 3'b001;
      #10 i_btn = 3'b000;
      
      #10 i_sw = 8'h02;
      #15 i_btn = 3'b010;
      #15 i_btn = 3'b000;
      /*
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
      i_data_b = 8'h02; */
      #100 $finish;
   end
   always #2.5 i_clk = ~i_clk;
   Top
     u_top( .o_led     (o_led[7:0]),
            .debug_led (o_led[8]),
            .i_sw      (i_sw),
            .i_btnL    (i_btn[2]),
            .i_btnC    (i_btn[1]),
            .i_btnR    (i_btn[0]),
            .i_btnU    (i_rst),
            .i_clk     (i_clk) );

endmodule
