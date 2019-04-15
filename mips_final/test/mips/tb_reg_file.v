`timescale 1ns / 1ps


module tb_reg_file();
   parameter NB_BITS = 32;
   parameter NB_DEPTH  = 5;
   
   wire [NB_BITS-1:0] o_rs;
   wire [NB_BITS-1:0] o_rd;
   reg [NB_BITS-1:0]  i_data;
   reg [NB_DEPTH-1:0] i_read_addr_1;
   reg [NB_DEPTH-1:0] i_read_addr_2;
   reg [NB_DEPTH-1:0] i_write_addr;
   reg                i_wenb;
   reg                i_clk;
   reg                i_rst;

   initial begin
      i_data        = 0;
      i_read_addr_1 = 0;
      i_read_addr_2 = 0;
      i_write_addr  = 0;
      i_wenb        = 1'b0;
      i_clk         = 1'b1;
      i_rst         = 1'b1;

      #10 i_rst = 1'b0;
      i_wenb = 1'b1;
      i_data = 12;
      i_write_addr = 3;
      
      #10 i_data = 9;
      i_write_addr = 7;
      #5 i_wenb = 1'b0;
      #5 i_read_addr_1 = 3;
      #5 i_read_addr_2 = 7;
      #5 i_read_addr_1 = 7;
      #5 i_read_addr_2 = 3;


      
      #10 $finish;
   end
   always #2.5 i_clk = ~i_clk;
   
   Register_file
     u_reg_file
       (
        .o_rs          (o_rs), // registro rs de salid
        .o_rd          (o_rd), // registro rt de salida
        .i_data        (i_data), // data write
        .i_read_addr_1 (i_read_addr_1), // read register rs selector 1
        .i_read_addr_2 (i_read_addr_2), // read register rt selector 2
        .i_write_addr  (i_write_addr), // write selector
        .i_wenb        (i_wenb), // write control enable
        .i_clk         (i_clk), // clock
        .i_rst         (i_rst)          // reset
        );
endmodule // tb_reg_file

