`timescale 1ns / 1ps

module Control #
  (
   parameter NB_BITS = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   localparam NB_SELA = 2
   )
   (
    output [clogb2(INS_MEM_DEPTH-1)-1:0] o_addr_ins,
    output [NB_SIGX-1:0]                 o_data_ins,
    output [NB_SELA-1:0]                 o_sel_a,
    output                               o_sel_b,
    output                               o_wr_acc,
    output                               o_op_code,
    output                               o_wr,
    output                               o_rd,
    input [NB_BITS-1:0]                  i_instruction,
    input                                i_clk,
    input                                i_rst
    );
   
   reg [clogb2(INS_MEM_DEPTH-1)-1:0]     pc;
   reg [NB_SELA-1:0]                     sel_a;
   reg                                   sel_b;
   reg                                   Wrpc;
   reg                                   wr_acc;
   reg                                   op_code;
   reg                                   wr;
   reg                                   rd;
   
   assign o_sel_a = sel_a;
   assign o_sel_b = sel_b;
   assign o_wr_acc = wr_acc;
   assign o_op_code = op_code;
   assign o_wr = wr;
   assign o_rd = rd;
   
   assign o_addr_ins = pc;
   
   /* actualizacion del pc */
   always @(posedge i_clk) begin
      if (i_rst) begin
         pc <= {clogb2(INS_MEM_DEPTH-1){1'b0}};
      end
      else if (Wrpc) begin
         pc <= pc + 1;
      end
      else begin
         pc <= pc;
      end
   end // always @ (posedge i_clk)
   
   /* operando */
   assign o_data_ins = i_instruction[NB_SIGX-1:0];

   always @(*) begin
      case(i_instruction[NB_BITS-1:NB_SIGX])
        5'b00000:begin //halt
           Wrpc = 1'b0;
           sel_a = 2'b00;
           sel_b = 1'b0;
           wr_acc = 1'b0;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00001:begin //Store Variable
           Wrpc = 1'b1;
           sel_a = 2'b11;
           sel_b = 1'b0;
           wr_acc = 1'b0;
           op_code = 1'b0;
           wr = 1'b1;
           rd = 1'b0;
        end
        5'b00010:begin //Load Variable
           Wrpc = 1'b1;
           sel_a = 2'b00;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00011:begin //Load inmediate
           Wrpc = 1'b1;
           sel_a = 2'b01;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00100:begin //Add Variable
           Wrpc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b1;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00101:begin //Add Inmediate
           Wrpc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b1;
           wr_acc = 1'b1;
           op_code = 1'b1;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00110:begin //Substract Variable
           Wrpc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00111:begin //Substract Inmediate
           Wrpc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b1;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        default: begin
           Wrpc = 1'b0;
           sel_a = 2'b00;
           sel_b = 1'b0;
           wr_acc = 1'b0;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
      endcase // case (i_instruction[NB_BITS-1:NB_SIGX])
   end // always @ (*)
   
   function integer clogb2;
      input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
   endfunction // clogb2
   
endmodule // Control
