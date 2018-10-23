`timescale 1ns / 1ps

module Control #
  (
   parameter NB_BITS = 16,
   parameter INS_MEM_DEPTH = 2048,
   parameter DTA_MEM_DEPTH = 1024,
   parameter NB_SIGX = 11, //catidad de bits sin la extension
   localparam NB_SELA = 2,
   localparam NB_DTA = clogb2(DTA_MEM_DEPTH-1),
   localparam NB_INS = clogb2(INS_MEM_DEPTH-1)
   )
   (
    output [NB_INS-1:0]  o_addr_ins,
    output [NB_DTA-1:0]  o_data_ins,
    output [NB_SELA-1:0] o_sel_a,
    output               o_sel_b,
    output               o_wr_acc,
    output               o_op_code,
    output               o_wr,
    output               o_rd,
    input [NB_BITS-1:0]  i_instruction,
    input                i_clk,
    input                i_rst
    );
   
   reg [NB_INS-1:0]      pc;
   reg [NB_SELA-1:0]     sel_a;
   reg                   sel_b;
   reg                   wr_pc;
   reg                   wr_acc;
   reg                   op_code;
   reg                   wr;
   reg                   rd;
   
   assign o_sel_a = sel_a;
   assign o_sel_b = sel_b;
   assign o_wr_acc = wr_acc;
   assign o_op_code = op_code;
   assign o_wr = wr;
   assign o_rd = rd;
   
   assign o_addr_ins = pc;
   /* operando */
   assign o_data_ins = i_instruction[NB_DTA-1:0];
   
   /* actualizacion del pc */
   always @(posedge i_clk) begin
      if (i_rst) begin
         pc <= {NB_INS{1'b0}};
      end
      else if (wr_pc) begin
         pc <= pc + 1;
      end
      else begin
         pc <= pc;
      end
   end // always @ (posedge i_clk)
   
   always @(*) begin
      case(i_instruction[NB_BITS-1:NB_SIGX])
        5'b00000:begin //halt
           wr_pc = 1'b0;
           sel_a = 2'b00;
           sel_b = 1'b0;
           wr_acc = 1'b0;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00001:begin //Store Variable
           wr_pc = 1'b1;
           sel_a = 2'b11;
           sel_b = 1'b0;
           wr_acc = 1'b0;
           op_code = 1'b0;
           wr = 1'b1;
           rd = 1'b0;
        end
        5'b00010:begin //Load Variable
           wr_pc = 1'b1;
           sel_a = 2'b00;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00011:begin //Load inmediate
           wr_pc = 1'b1;
           sel_a = 2'b01;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00100:begin //Add Variable
           wr_pc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b1;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00101:begin //Add Inmediate
           wr_pc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b1;
           wr_acc = 1'b1;
           op_code = 1'b1;
           wr = 1'b0;
           rd = 1'b0;
        end
        5'b00110:begin //Substract Variable
           wr_pc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b0;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b1;
        end
        5'b00111:begin //Substract Inmediate
           wr_pc = 1'b1;
           sel_a = 2'b10;
           sel_b = 1'b1;
           wr_acc = 1'b1;
           op_code = 1'b0;
           wr = 1'b0;
           rd = 1'b0;
        end
        default: begin
           wr_pc = 1'b0;
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
