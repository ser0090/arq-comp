`timescale 1ns / 1ps


module Register_file #
  (
   parameter NB_BITS   = 32,
   parameter NB_DEPTH  = 5,
   localparam RF_DEPTH = 2**NB_DEPTH
   )
   (
    output [NB_BITS-1:0] o_rs,          // registro rs de salid
    output [NB_BITS-1:0] o_rt,          // registro rt de salida
    output               o_zero,
    input [NB_BITS-1:0]  i_data,        // data write
    input [NB_DEPTH-1:0] i_read_addr_1, // read register rs selector 1
    input [NB_DEPTH-1:0] i_read_addr_2, // read register rt selector 2
    input [NB_DEPTH-1:0] i_write_addr,  // write selector
    input                i_wenb,        // write control enable
    input                i_clk,         // clock
    input                i_rst          // reset
   );

   reg [NB_BITS-1:0]     reg_file [RF_DEPTH-1:0];
   reg [NB_BITS-1:0]     rs, rt;
   integer               rf_index;

   assign o_rs = rs;
   assign o_rt = rt;
   assign o_zero = (rt == rs)? 1'b1 : 1'b0;

   always @ (posedge i_clk) begin
      if (i_rst)
        for(rf_index = 0; rf_index < RF_DEPTH; rf_index = rf_index + 1)
          reg_file[rf_index] <= {NB_BITS{1'b0}};
      else if (i_wenb)
        reg_file[i_write_addr] <= i_data;
      else
        for(rf_index = 0; rf_index < RF_DEPTH; rf_index = rf_index + 1)
          reg_file[rf_index] <= reg_file[rf_index];
   end

   always @(*) begin
      rs = reg_file[i_read_addr_1];
      rt = reg_file[i_read_addr_2];
   end
endmodule // Register_file

