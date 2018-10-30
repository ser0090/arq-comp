`timescale 1ns / 1ps

module Datapath #
  (
   parameter NB_BITS = 16,
   parameter NB_ADDR = 11,
   localparam NB_SIGX = NB_ADDR  	//catidad de bits sin la extension
   )
   (
    output [NB_BITS-1:0] o_acc, 	//add syntesis
    output [NB_BITS-1:0] o_data,
    input [NB_BITS-1:0]  i_data_mem,
    input [NB_SIGX-1:0]  i_data_ins,
    input [1:0]          i_sel_a,
    input                i_sel_b,
    input                i_wr_acc,
    input                i_op_code,
    input                i_clk,
    input                i_rst
    );
   
   reg [NB_BITS-1:0]     acc;
   
   wire [NB_BITS-1:0]    mux_2;
   wire [NB_BITS-1:0]    result;
   wire [NB_BITS-1:0]    sig_extension;
   
   /*definicion del comportamiento de  mux 2*/
   assign mux_2 = (i_sel_b)? sig_extension : i_data_mem;
   
   /*definicion del comportamiento de la ALU simple*/
   assign result = (i_op_code)? acc + mux_2 : acc - mux_2;
  
   /* Signal Extension */
   assign sig_extension = {{NB_BITS-NB_SIGX{i_data_ins[NB_SIGX-1]}}, i_data_ins};
   
   assign o_data = acc;
   assign o_acc = acc;
   
   always @ (posedge i_clk) begin
      if (i_rst) begin
         acc <= {NB_BITS{1'b0}};
      end
      else if (i_wr_acc) begin
         case (i_sel_a)
           2'b00: acc <= i_data_mem;
           2'b01: acc <= sig_extension;
           2'b10: acc <= result;
           default: acc <= acc;
         endcase // case (i_sel_a)
      end
      else begin
         acc <= acc;
      end
   end // always @ (posedge i_clk)
endmodule // Data_Memory

